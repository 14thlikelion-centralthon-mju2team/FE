import "../models/place.dart";
import "../models/event.dart";
import "../models/plan.dart";
import "../models/prep_item.dart";
import "../models/notification.dart";
import "../models/action_log.dart";
import "../models/daily_wellness_summary.dart";
import "../models/prep_estimate.dart";
import "../models/wellness_pref.dart";

/// API v5.0 기준. submitAction(단건) -> submitActions(배치)로 개명,
/// resolveChecklistItem/resolveWellnessAction 분리(§12.2, 서로 다른
/// 테이블·enum이라 엔드포인트도 분리됨).
abstract class EnsomRepository {
  // 일정 (CAL-01, 03, 04, 05)
  Future<Event?> fetchNextEvent();
  Future<List<Event>> fetchEvents({
    required DateTime from,
    required DateTime to,
  });
  Future<Event> createEvent(Event event);
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
    ChecklistCompletionStatus status,
  );
  Future<void> resolveWellnessAction(
    String planId,
    String wellnessActionId,
    WellnessActionCompletionStatus status,
  );
  Future<DailyWellnessSummary?> fetchDailySummary(String date);
  Future<void> markDailySummaryViewed(String summaryId);

  // 웰니스 관심 항목 설정 (WELL-06)
  Future<List<WellnessPref>> fetchWellnessPrefs();
  Future<void> updateWellnessPrefs(List<WellnessPref> prefs);

  // 행동 기록 -- API v5.0 §13: 배치 {actions:[...]}, clientEventId로 멱등 보장 (TR-03)
  Future<ActionBatchResponse> submitActions(
    String planId,
    List<ActionLogEntry> actions,
  );

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

  // 계정 (AUTH-04, DATA-01)
  Future<void> deleteAccount();
}