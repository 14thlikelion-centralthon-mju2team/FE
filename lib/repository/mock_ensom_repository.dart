import "ensom_repository.dart";
import "../models/place.dart";
import "../models/event.dart";
import "../models/plan.dart";
import "../models/prep_item.dart";
import "../models/notification.dart";
import "../models/action_log.dart";
import "../models/daily_wellness_summary.dart";
import "../models/prep_estimate.dart";

class MockEnsomRepository implements EnsomRepository {
  // -- 일정 --------------------------------------------------------
  @override
  Future<Event?> fetchNextEvent() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Event(
      eventId: "mock-event-1",
      title: "강남역 미팅",
      startsAt: DateTime.now().add(const Duration(hours: 3)),
      endsAt: DateTime.now().add(const Duration(hours: 4)),
      placeNeed: PlaceNeed.requiredResolved,
      destinationName: "강남역",
      destinationLat: 37.498,
      destinationLng: 127.027,
      anchor: EventAnchor.arriveBy,
      sourceType: EventSourceType.internal,
      status: "confirmed",
    );
  }

  @override
  Future<List<Event>> fetchEvents({
    required DateTime from,
    required DateTime to,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final next = await fetchNextEvent();
    return next == null ? [] : [next];
  }

  @override
  Future<Event> createEvent(Event event) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return event;
  }

  @override
  Future<Event> updateEvent(String eventId, Event event) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return event;
  }

  @override
  Future<void> deleteEvent(String eventId) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }

  @override
  Future<void> reviewEventClassification(
    String eventId,
    EventClassificationReview review,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  // -- 계획 --------------------------------------------------------
  @override
  Future<Plan> fetchLatestPlan(String eventId) => _mockPlan();

  @override
  Future<Plan> fetchPlan(String planId) => _mockPlan();

  @override
  Future<Plan> recalculatePlan(String eventId) => _mockPlan();

  @override
  Future<Plan> updatePlan(
    String planId, {
    DateTime? prepStartAt,
    DateTime? departAt,
    String? originPlaceId,
  }) => _mockPlan();

  Future<Plan> _mockPlan() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final now = DateTime.now();
    return Plan(
      planId: "mock-plan-1",
      revisionNo: 3,
      engineVer: "2.1.0",
      state: "NOTIFIED",
      feasible: true,
      prepStartAt: now.add(const Duration(hours: 2)),
      departAt: now.add(const Duration(hours: 2, minutes: 45)),
      etaAt: now.add(const Duration(hours: 3, minutes: 25)),
      trace: const [
        TraceItem(
          label: "개인 준비 시간",
          minutes: 35,
          source: "model",
          adjusted: true,
          reason: "최근 8회 기록 기준, 초기 설정보다 5분 증가",
        ),
        TraceItem(
          label: "이동 시간",
          minutes: 42,
          source: "provider",
          adjusted: false,
          reason: "외부 지도 API 기준",
        ),
      ],
      checklist: const [
        ChecklistItem(
          label: "영양제",
          origin: ChecklistOrigin.user,
          kind: "consume",
          state: ChecklistState.pending,
        ),
        ChecklistItem(
          label: "선크림",
          origin: ChecklistOrigin.wellness,
          kind: "carry",
          state: ChecklistState.pending,
          reason: "자외선 높음, 야외 45분",
        ),
      ],
      wellness: const WellnessSummary(
        wis: 72,
        wisVer: "w1",
        actionsShown: 2,
        eventArmed: true,
      ),
      degraded: const [],
    );
  }

  // -- 경로 --------------------------------------------------------
  @override
  Future<List<RouteOption>> fetchRouteOptions(String planId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return const [
      RouteOption(
        routeId: "r1",
        rank: RouteRank.fastest,
        totalSec: 2520,
        walkSec: 660,
        transfers: 1,
        outdoorSec: 480,
      ),
      RouteOption(
        routeId: "r2",
        rank: RouteRank.leastWalk,
        totalSec: 2820,
        walkSec: 240,
        transfers: 2,
        outdoorSec: 200,
      ),
      RouteOption(
        routeId: "r3",
        rank: RouteRank.leastTransfer,
        totalSec: 3060,
        walkSec: 540,
        transfers: 0,
        outdoorSec: 420,
      ),
    ];
  }

  @override
  Future<Plan> selectRoute(String planId, String routeOptionId) =>
      _mockPlan();

  // -- 맞춤 준비 항목 ------------------------------------------------
  @override
  Future<List<PrepItem>> fetchPrepItems() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const [
      PrepItem(
        id: "pi1",
        label: "영양제",
        kind: PrepKind.consume,
        fromChip: true,
      ),
      PrepItem(
        id: "pi2",
        label: "물 텀블러",
        kind: PrepKind.carry,
        fromChip: true,
      ),
    ];
  }

  @override
  Future<PrepItem> createPrepItem(PrepItem item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return item;
  }

  @override
  Future<PrepItem> updatePrepItem(String id, PrepItem item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return item;
  }

  @override
  Future<void> deletePrepItem(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }

  // -- 알림 --------------------------------------------------------
  @override
  Future<List<AppNotification>> fetchTodayNotifications() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      AppNotification(
        notificationId: "n1",
        notificationClass: NotificationClass.time,
        slot: "A",
        sentAt: DateTime.now().subtract(const Duration(minutes: 20)),
        message: "20분 뒤 준비를 시작할 예정입니다.",
        reaction: "prep_started",
      ),
    ];
  }

  @override
  Future<void> respondToNotification(
    String notificationId,
    WellnessResponseAction action,
  ) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }

  // -- 웰니스 ------------------------------------------------------
  @override
  Future<void> resolveChecklistItem(
    String planId,
    String itemId,
    ChecklistState state,
  ) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }

  @override
  Future<DailyWellnessSummary?> fetchDailySummary(String date) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return DailyWellnessSummary(
      summaryDate: date,
      eventCount: 3,
      totalOutdoorMinutes: 43,
      dwlBand: DwlBand.mid,
      cardScenario: "exposure",
      message: "자외선이 높은 시간대의 예상 야외 이동이 길었어요. 지금은 수분을 보충하고 편안하게 쉬어주세요.",
    );
  }

  // -- 행동 기록 -----------------------------------------------------
  @override
  Future<ActionLogResponse> submitAction(
    String planId,
    ActionLogEntry entry,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final plan = await _mockPlan();
    return ActionLogResponse(
      accepted: true,
      duplicated: false,
      plan: plan.toJson(),
    );
  }

  // -- 개인화 ------------------------------------------------------
  @override
  Future<List<PrepEstimate>> fetchPrepEstimates() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const [
      PrepEstimate(
        scopeType: "global",
        estimatedMinutes: 35,
        sampleCount: 12,
      ),
      PrepEstimate(
        scopeType: "event_kind",
        scopeValue: "저녁 약속",
        estimatedMinutes: 42,
        sampleCount: 5,
      ),
    ];
  }

  @override
  Future<void> revertPersonalization(String planId) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> resetPersonalization() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  // -- 장소 --------------------------------------------------------
  @override
  Future<List<Place>> fetchPlaces() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const [
      Place(id: "p1", label: "집", lat: 37.5665, lng: 126.9780, radiusM: 300),
    ];
  }

  @override
  Future<Place> registerPlace(Place place) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return place;
  }

  @override
  Future<void> deletePlace(String placeId) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }

  // -- 캘린더 연동 ---------------------------------------------------
  @override
  Future<void> syncCalendar() async {
    await Future.delayed(const Duration(milliseconds: 400));
  }

  // -- 계정 --------------------------------------------------------
  @override
  Future<void> deleteAccount() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
