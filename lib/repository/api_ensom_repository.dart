import "package:uuid/uuid.dart";
import "ensom_repository.dart";
import "../models/place.dart";
import "../models/event.dart";
import "../models/plan.dart";
import "../models/prep_item.dart";
import "../models/notification.dart";
import "../models/action_log.dart";
import "../models/daily_wellness_summary.dart";
import "../models/prep_estimate.dart";
import "../models/wellness_pref.dart";
import "../network/api_client.dart";

/// API v5.0 기준 실제 구현체. 이번 PR(M1)이 화면에서 실제로 쓰는
/// 5개 엔드포인트만 진짜로 붙였다:
///   GET  /events/next
///   GET  /events/{eventId}/plans/latest
///   POST /plans/{planId}/actions
///   GET  /plans/{planId}/routes
///   POST /plans/{planId}/routes/select
///
/// 나머지 메서드(장소·맞춤준비항목·알림·개인화·캘린더연동·계정)는
/// 각각 다른 브랜치 범위(주로 feat/fe-auth-onboarding, feat/fe-wellness,
/// feat/fe-map-summary-settings)라 UnimplementedError로 남겨둔다 --
/// 이 리포지토리를 그 화면에 조기 연결하면 조용히 죽는 대신 바로
/// 터지게 하기 위함이다.
class ApiEnsomRepository implements EnsomRepository {
  ApiEnsomRepository(this._client);

  final ApiClient _client;
  final _uuid = const Uuid();

  // -- 일정 (M1에서 쓰는 것만 구현) -----------------------------------
  @override
  Future<Event?> fetchNextEvent() async {
    try {
      final json = await _client.get<Map<String, dynamic>>("/events/next");
      return Event.fromJson(json);
    } on ApiException catch (e) {
      if (e.code == "EVENT_NOT_FOUND") return null;
      rethrow;
    }
  }

  // -- 계획 --------------------------------------------------------
  @override
  Future<Plan> fetchLatestPlan(String eventId) async {
    final json = await _client
        .get<Map<String, dynamic>>("/events/$eventId/plans/latest");
    return Plan.fromJson(json);
  }

  @override
  Future<Plan> fetchPlan(String planId) async {
    final json = await _client.get<Map<String, dynamic>>("/plans/$planId");
    return Plan.fromJson(json);
  }

  @override
  Future<Plan> recalculatePlan(String eventId) async {
    final json = await _client.post<Map<String, dynamic>>(
      "/events/$eventId/plan/recalculate",
      body: {"reason": "user_request"},
    );
    return Plan.fromJson(json);
  }

  // -- 경로 --------------------------------------------------------
  @override
  Future<List<RouteOption>> fetchRouteOptions(String planId) async {
    final json =
        await _client.get<List<dynamic>>("/plans/$planId/routes");
    return json
        .map((e) => RouteOption.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Plan> selectRoute(String planId, String routeOptionId) async {
    final json = await _client.post<Map<String, dynamic>>(
      "/plans/$planId/routes/select",
      body: {"routeOptionId": routeOptionId},
    );
    return Plan.fromJson(json);
  }

  // -- 행동 기록 -----------------------------------------------------
  @override
  Future<ActionBatchResponse> submitActions(
    String planId,
    List<ActionLogEntry> actions,
  ) async {
    final json = await _client.post<Map<String, dynamic>>(
      "/plans/$planId/actions",
      body: {"actions": actions.map((a) => a.toJson()).toList()},
    );
    return ActionBatchResponse.fromJson(json);
  }

  // -- 웰니스 (resolve만 구현 -- 화면에서 이미 호출하므로) ----------------
  @override
  Future<void> resolveChecklistItem(
    String planId,
    String planPrepItemId,
    ChecklistCompletionStatus status,
  ) async {
    await _client.post<Map<String, dynamic>>(
      "/plans/$planId/prep-items/$planPrepItemId/resolve",
      body: {
        "completionStatus": status.name, // pending|completed, JsonValue와 동일 문자열
        "clientEventId": _uuid.v4(),
      },
    );
  }

  @override
  Future<void> resolveWellnessAction(
    String planId,
    String wellnessActionId,
    WellnessActionCompletionStatus status,
  ) async {
    await _client.post<Map<String, dynamic>>(
      "/plans/$planId/wellness-actions/$wellnessActionId/resolve",
      body: {
        "completionStatus": status.name, // proposed|completed|dismissed
        "clientEventId": _uuid.v4(),
      },
    );
  }

  // ================================================================
  // 설정 (SET-03, ONB-01) — PATCH /me/settings
  // ================================================================

  @override
  Future<void> updateSettings(Map<String, dynamic> patch) async {
    await _client.patch<Map<String, dynamic>>(
      "/me/settings",
      body: patch,
    );
  }

  // ================================================================
  // 맞춤 준비 항목 (ONB-01, SET-02, PLAN-05)
  // API 명세 §6: POST /prep-items
  // ================================================================

  @override
  Future<List<PrepItem>> fetchPrepItems() async {
    final json = await _client.get<List<dynamic>>("/prep-items");
    return json
        .map((e) => PrepItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<PrepItem> createPrepItem(PrepItem item) async {
    final json = await _client.post<Map<String, dynamic>>(
      "/prep-items",
      body: _prepItemToRequestBody(item),
    );
    return PrepItem.fromJson(json);
  }

  @override
  Future<PrepItem> updatePrepItem(String id, PrepItem item) async {
    final json = await _client.patch<Map<String, dynamic>>(
      "/prep-items/$id",
      body: _prepItemToRequestBody(item),
    );
    return PrepItem.fromJson(json);
  }

  @override
  Future<void> deletePrepItem(String id) async {
    await _client.delete<Map<String, dynamic>>("/prep-items/$id");
  }

  /// API 명세 §6.1의 요청 바디 구성.
  /// PrepItem 모델의 필드를 서버가 기대하는 camelCase 필드로 변환한다.
  Map<String, dynamic> _prepItemToRequestBody(PrepItem item) {
    // PrepKind → (ruleCategory, actionType) 매핑
    // API 명세 §6: ruleCategory × actionType 2축 구조
    String ruleCategory;
    String actionType;

    switch (item.kind) {
      case PrepKind.carry:
        ruleCategory = "general_item";
        actionType = "carry";
      case PrepKind.consume:
        // sensitive가 medication 판별 기준 (§6.2: medication → isSensitive 강제)
        ruleCategory = item.sensitive ? "medication" : "supplement";
        actionType = "consume";
      case PrepKind.purchase:
        ruleCategory = "personal_item";
        actionType = "purchase";
      case PrepKind.routine:
        ruleCategory = "routine";
        actionType = "timed_routine";
    }

    return {
      "ruleName": item.label,
      "ruleCategory": ruleCategory,
      "actionType": actionType,
      "ruleTiming": "pre_departure",
      "defaultMinutes": item.kind == PrepKind.routine ? item.extraMin : null,
      "applyEventKind": null,
      "applyTimeBand": null,
      "applyPlaceId": null,
      "applyWeather": null,
      "isRequired": false,
      "isSensitive": item.sensitive,
      "fromChip": item.fromChip,
    };
  }

  // ================================================================
  // 아래부터는 이번 PR 범위 밖. 호출 시 즉시 예외를 던진다.
  // ================================================================

  @override
  Future<List<Event>> fetchEvents({
    required DateTime from,
    required DateTime to,
  }) =>
      throw UnimplementedError("캘린더 화면(M4, feat/fe-map-summary-settings) 범위");

  @override
  Future<Event> createEvent(Event event) =>
      throw UnimplementedError("일정 생성(CAL-01/05)은 M4 범위");

  @override
  Future<Event> updateEvent(String eventId, Event event) =>
      throw UnimplementedError("일정 수정은 M4 범위");

  @override
  Future<void> deleteEvent(String eventId) =>
      throw UnimplementedError("일정 삭제는 M4 범위");

  @override
  Future<void> reviewEventClassification(
    String eventId,
    EventClassificationReview review,
  ) =>
      throw UnimplementedError("분류 확인 흐름은 M4 범위");

  @override
  Future<Plan> updatePlan(
    String planId, {
    DateTime? prepStartAt,
    String? originPlaceId,
  }) =>
      throw UnimplementedError("계획 수동 수정 UI는 M1 이후 범위");

  @override
  @override
  Future<List<AppNotification>> fetchTodayNotifications() async {
    final json = await _client.get<List<dynamic>>("/notifications/today");
    return json
        .map((e) => AppNotification.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static const Map<WellnessResponseAction, String> _responseActionValues = {
    WellnessResponseAction.completed: "completed",
    WellnessResponseAction.snoozed: "snoozed",
    WellnessResponseAction.stopToday: "stop_today",
    WellnessResponseAction.ignored: "ignored",
  };

  @override
  Future<void> respondToNotification(
    String notificationId,
    WellnessResponseAction action,
  ) async {
    await _client.post<Map<String, dynamic>>(
      "/notifications/$notificationId/respond",
      body: {
        "action": _responseActionValues[action],
        "clientEventId": _uuid.v4(),
      },
    );
  }

  @override
  Future<DailyWellnessSummary?> fetchDailySummary(String date) async {
    try {
      final json = await _client
          .get<Map<String, dynamic>>("/summary/daily", query: {"date": date});
      return DailyWellnessSummary.fromJson(json);
    } on ApiException catch (e) {
      // 관리 일정 0건이면 카드를 만들지 않는다 (숫자를 지어내지 않음, PRD §14.8)
      if (e.code == "SUMMARY_NOT_GENERATED" || e.code == "NOT_FOUND") {
        return null;
      }
      rethrow;
    }
  }

  @override
  Future<List<WellnessPref>> fetchWellnessPrefs() async {
    final json = await _client.get<Map<String, dynamic>>("/me/wellness-prefs");
    final list = json["prefs"] as List<dynamic>? ?? [];
    return list
        .map((e) => WellnessPref.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> updateWellnessPrefs(List<WellnessPref> prefs) async {
    await _client.patch<Map<String, dynamic>>(
      "/me/wellness-prefs",
      body: {"prefs": prefs.map((p) => p.toJson()).toList()},
    );
  }

  @override
  Future<List<PrepEstimate>> fetchPrepEstimates() =>
      throw UnimplementedError("개인화 조회 화면은 아직 스코프 미배정");

  @override
  Future<void> revertPersonalization(String eventId) =>
      throw UnimplementedError("개인화 되돌리기 UI는 아직 스코프 미배정");

  @override
  Future<void> resetPersonalization() =>
      throw UnimplementedError("설정 화면(feat/fe-map-summary-settings, M4) 범위");

  @override
  Future<List<Place>> fetchPlaces() =>
      throw UnimplementedError("장소 목록은 feature/geofence-place-management 범위");

  @override
  Future<Place> registerPlace(Place place) =>
      throw UnimplementedError("feature/geofence-place-management 범위");

  @override
  Future<void> deletePlace(String placeId) =>
      throw UnimplementedError("feature/geofence-place-management 범위");

  @override
  Future<void> syncCalendar() =>
      throw UnimplementedError("캘린더 연동은 feat/fe-map-summary-settings(M4) 범위");

  @override
  Future<void> deleteAccount() =>
      throw UnimplementedError("계정 삭제는 feat/fe-map-summary-settings(M4) 범위");
}