import "../models/place.dart";
import "../models/event.dart";
import "../models/plan.dart";
import "../models/prep_item.dart";
import "../models/notification.dart";
import "../models/action_log.dart";
import "../models/daily_wellness_summary.dart";
import "../models/prep_estimate.dart";
import "../models/wellness_pref.dart";
import "../models/execution.dart";
import "../models/environment_data.dart";

/// API v5.0 기준. submitAction(단건) -> submitActions(배치)로 개명,
/// resolveChecklistItem/resolveWellnessAction 분리(§12.2, 서로 다른
/// 테이블·enum이라 엔드포인트도 분리됨).
abstract class EnsomRepository {
  // 일정 (CAL-01, 03, 04, 05)
  Future<Event?> fetchNextEvent();
  Future<Event> fetchEvent(String eventId);
  Future<List<Event>> fetchEvents({
    required DateTime from,
    required DateTime to,
  });
  Future<Event> createEvent(
    Event event, {
    String? originPlaceId,
    String? selectedRouteOptionId,
    String? writeToCalendarSourceId,
  });
  Future<Event> updateEvent(String eventId, Event event);
  Future<void> deleteEvent(String eventId);
  Future<void> reviewEventClassification(
    String eventId,
    EventClassificationReview review,
  );

  // 계획 (PLAN-01~05)
  Future<Plan> fetchLatestPlan(String eventId);
  Future<Plan> fetchPlan(String planId);
  Future<Plan> recalculatePlan(String eventId);
  Future<Plan> updatePlan(
    String planId, {
    DateTime? prepStartAt,
    String? originPlaceId,
  });

  // 경로 (MAP-01~04)
  Future<List<RouteOption>> fetchRouteOptions(String planId);
  Future<Plan> selectRoute(String planId, String routeOptionId);

  /// 계획 없이 지도 화면에서 검색 (CAL-05 진입점, §10.3 GET /routes/search).
  /// routeOptionId는 TTL 30분짜리 임시 키이며, POST /events의
  /// selectedRouteOptionId로 넘기면 계획 생성 시점에 확정된다.
  Future<List<RouteOption>> fetchRouteSearch({
    double? originLat,
    double? originLng,
    String? originPlaceId,
    required double destLat,
    required double destLng,
    required String destName,
    required EventAnchor anchorMode,
    required DateTime at,
  });

  // 설정 (SET-03, ONB-01)
  Future<void> updateSettings(Map<String, dynamic> patch);

  // 맞춤 준비 항목 (ONB-01, SET-02, PLAN-05)
  Future<List<PrepItem>> fetchPrepItems();
  Future<PrepItem> createPrepItem(PrepItem item);
  Future<PrepItem> updatePrepItem(String id, PrepItem item);
  Future<void> deletePrepItem(String id);

  // 알림 (NOTI-01~05)
  Future<List<AppNotification>> fetchTodayNotifications();
  Future<void> respondToNotification(
    String notificationId,
    WellnessResponseAction action,
  );

  // 웰니스 (WELL-01~06) -- API v5.0 §12.2: 두 경로 분리
  Future<void> resolveChecklistItem(
    String planId,
    String planPrepItemId,
    ChecklistCompletionStatus status, {
    required String clientEventId,
  });
  Future<void> resolveWellnessAction(
    String planId,
    String wellnessActionId,
    WellnessActionCompletionStatus status, {
    required String clientEventId,
  });
  Future<DailyWellnessSummary?> fetchDailySummary(String date);
  Future<void> markDailySummaryViewed(String summaryId);

  // 웰니스 관심 항목 설정 (WELL-06) — GET/PATCH /me/wellness-prefs
  Future<List<WellnessPref>> fetchWellnessPrefs();
  Future<void> updateWellnessPrefs(List<WellnessPref> prefs);

  // 행동 기록 -- API v5.0 §13: 배치 {actions:[...]}, clientEventId로 멱등 보장 (TR-03)
  Future<ActionBatchResponse> submitActions(
    String planId,
    List<ActionLogEntry> actions,
  );

  /// 도착 처리 (지오펜스 ENTER+체류검증 또는 수동 "도착했어요" 버튼).
  /// API v5.0 §13에서 v3.0의 `arrived` ActionType은 제거되고
  /// EVENT_EXECUTION으로 옮겨갔다고만 명시돼 있고, 실제 쓰기 엔드포인트가
  /// 문서에 없다 — 백엔드 확인 필요(TODO, map_screen.dart의 기존 관례와 동일).
  Future<void> reportArrival(
    String eventId,
    String planId, {
    required String clientEventId,
    required ActionSource source,
    double? confidence,
  });

  // 도착 결과·사후 평가 (REPORT-01, §14)
  Future<EventExecution> fetchExecution(String eventId);
  Future<void> submitFeedback(
    String eventId, {
    required PrepTimingAssessment prepTimingAssessment,
    required ArrivalResult arrivalResult,
    required RushAssessment rushAssessment,
  });

  // 개인화 (MODEL-01/02)
  Future<List<PrepEstimate>> fetchPrepEstimates();
  Future<void> revertPersonalization(String eventId);
  Future<void> resetPersonalization();

  // 장소 (SET-01)
  Future<List<Place>> fetchPlaces();
  Future<Place> registerPlace(Place place);
  Future<void> deletePlace(String placeId);

  // 캘린더 연동 (CAL-02)
  Future<void> syncCalendar();

  // 환경 데이터 (날씨 + 대기질)
  Future<EnvironmentData> getEnvironment();

  // 계정 (AUTH-04, DATA-01)
  // 로그아웃은 AuthNotifier.logout()(lib/providers/auth_providers.dart)이
  // AuthService를 통해 이미 처리한다 — 여기서 중복 정의하지 않는다.
  Future<void> deleteAccount();
}