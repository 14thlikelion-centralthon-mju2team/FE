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
  // 아래부터는 이번 PR(M1) 범위 밖. 호출 시 즉시 예외를 던진다.
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
  Future<List<PrepItem>> fetchPrepItems() =>
      throw UnimplementedError("맞춤 준비 항목 목록은 feat/fe-auth-onboarding(온보딩) 범위");

  @override
  Future<PrepItem> createPrepItem(PrepItem item) =>
      throw UnimplementedError("feat/fe-auth-onboarding 범위");

  @override
  Future<PrepItem> updatePrepItem(String id, PrepItem item) =>
      throw UnimplementedError("feat/fe-auth-onboarding 범위");

  @override
  Future<void> deletePrepItem(String id) =>
      throw UnimplementedError("feat/fe-auth-onboarding 범위");

  @override
  Future<List<AppNotification>> fetchTodayNotifications() async {
    final json = await _client.get<List<dynamic>>("/notifications/today");
    return json
        .map((e) => AppNotification.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> respondToNotification(
    String notificationId,
    WellnessResponseAction action,
  ) =>
      throw UnimplementedError("feat/fe-notification-offline(M2) 범위");

  @override
  Future<DailyWellnessSummary?> fetchDailySummary(String date) =>
      throw UnimplementedError("일일 마무리 카드는 feat/fe-wellness(M3) 범위");

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