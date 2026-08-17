import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_riverpod/legacy.dart"; // StateNotifier(Provider)는 riverpod 3.x에서 이 경로로 이관됨
import "../models/event.dart";
import "../models/plan.dart";
import "../models/action_log.dart";
import "../repository/ensom_repository.dart";
import "../repository/providers.dart";

final nextEventProvider = FutureProvider.autoDispose<Event?>((ref) async {
  final repo = ref.watch(ensomRepositoryProvider);
  return repo.fetchNextEvent();
});

final routeOptionsProvider = FutureProvider.autoDispose
    .family<List<RouteOption>, String>((ref, planId) async {
  final repo = ref.watch(ensomRepositoryProvider);
  return repo.fetchRouteOptions(planId);
});

final planControllerProvider = StateNotifierProvider.autoDispose
    .family<PlanController, AsyncValue<Plan>, String>((ref, eventId) {
  final repo = ref.watch(ensomRepositoryProvider);
  return PlanController(repo: repo, eventId: eventId);
});

/// 계획의 단일 진실원천 (리뷰 High-1 반영).
///
/// 행동(submitAction/selectRoute) 실패 시 state를 AsyncError로 바꾸지
/// 않는다 -- 그냥 예외를 던지고 마지막 성공 상태를 유지한다. 호출부
/// (화면)가 try/catch로 잡아 스낵바 등으로 알린다. AsyncValue.error(...)
/// .copyWithPrevious(...)로 "에러이면서 이전 데이터 유지"를 표현하는
/// 방식은 riverpod 패키지 내부 전용(@internal)이라 쓰지 않는다.
class PlanController extends StateNotifier<AsyncValue<Plan>> {
  PlanController({required this.repo, required this.eventId})
      : super(const AsyncValue.loading()) {
    _load();
  }

  final EnsomRepository repo;
  final String eventId;

  Future<void> _load() async {
    state = const AsyncValue.loading();
    try {
      final plan = await repo.fetchLatestPlan(eventId);
      state = AsyncValue.data(plan);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> retry() => _load();

  Future<void> submitAction(ActionLogEntry entry) async {
    final plan = state.value;
    if (plan == null) return;
    final response = await repo.submitAction(plan.planId, entry);
    state = AsyncValue.data(Plan.fromJson(response.plan));
  }

  Future<void> selectRoute(String routeOptionId) async {
    final plan = state.value;
    if (plan == null) return;
    final updated = await repo.selectRoute(plan.planId, routeOptionId);
    state = AsyncValue.data(updated);
  }

  /// 낙관적 갱신 + 실패 시 롤백.
  Future<void> toggleChecklistItem(ChecklistItem item, bool completed) async {
    final plan = state.value;
    if (plan == null) return;

    final newStatus = completed
        ? ChecklistCompletionStatus.completed
        : ChecklistCompletionStatus.pending;

    final optimistic = plan.copyWith(
      checklist: [
        for (final c in plan.checklist)
          if (c.itemId == item.itemId)
            c.copyWith(completionStatus: newStatus)
          else
            c,
      ],
    );
    state = AsyncValue.data(optimistic);

    try {
      await repo.resolveChecklistItem(plan.planId, item.itemId, newStatus);
    } catch (_) {
      state = AsyncValue.data(plan); // 롤백
    }
  }
}