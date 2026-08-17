import '../models/place.dart';
import '../models/event.dart';
import '../models/plan.dart';
import '../models/prep_item.dart';
import '../models/notification.dart';
import '../models/action_log.dart';
import '../models/daily_wellness_summary.dart';
import '../models/prep_estimate.dart';

/// API 명세서 기준 재작성. 기존 루틴/체크인/AAC 연동/챗봇 관련 메서드는
/// 전부 제거 -- 새 API 명세 어디에도 대응 엔드포인트가 없다.
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
    DateTime? departAt,
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

  // 웰니스 (WELL-01~06)
  Future<void> resolveChecklistItem(
    String planId,
    String itemId,
    ChecklistCompletionStatus status,
  );
  Future<DailyWellnessSummary?> fetchDailySummary(String date);

  // 행동 기록 -- 오프라인 큐의 최종 도착지, clientEventId로 멱등 보장 (TR-03)
  Future<ActionLogResponse> submitAction(String planId, ActionLogEntry entry);

  // 개인화 (MODEL-01/02)
  Future<List<PrepEstimate>> fetchPrepEstimates();
  Future<void> revertPersonalization(String planId);
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