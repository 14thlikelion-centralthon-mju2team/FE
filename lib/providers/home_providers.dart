import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_riverpod/legacy.dart";
import "package:uuid/uuid.dart";
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

/// 계획의 단일 진실원천.
/// previousPlan을 추적해서 리비전 변경 시 UI가 "무엇이 바뀌었는지"를 표시한다.
class PlanController extends StateNotifier<AsyncValue<Plan>> {
  PlanController({required this.repo, required this.eventId})
      : super(const AsyncValue.loading()) {
    _load();
  }

  final EnsomRepository repo;
  final String eventId;
  static const _uuid = Uuid();

  /// 직전 계획 — 리비전 변경 배너에 사용
  Plan? previousPlan;

  Future<void> _load() async {
    state = const AsyncValue.loading();
    try {
      final plan = await repo.fetchLatestPlan(eventId);
      // 이전 계획과 리비전이 다를 때만 previousPlan 갱신
      final current = state.valueOrNull;
      if (current != null && current.revisionNo != plan.revisionNo) {
        previousPlan = current;
      }
      state = AsyncValue.data(plan);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> retry() => _load();

  /// API v5.0 §13: 배치 엔드포인트다. 지금은 항상 1건씩 보내지만,
  /// M2(Drift 큐)가 붙으면 큐에 쌓인 여러 건을 한 번에 실어 보낼 수
  /// 있도록 시그니처 자체를 리스트로 잡아뒀다.
  Future<void> submitActions(List<ActionLogEntry> actions) async {
    final plan = state.value;
    if (plan == null) return;
    final response = await repo.submitActions(plan.planId, actions);
    state = AsyncValue.data(Plan.fromJson(response.plan));
  }

  Future<void> selectRoute(String routeOptionId) async {
    final plan = state.value;
    if (plan == null) return;
    final updated = await repo.selectRoute(plan.planId, routeOptionId);
    state = AsyncValue.data(updated);
  }

  /// 낙관적 갱신 + 실패 시 롤백.
  /// clientEventId는 오프라인 큐(enqueueResolve) 내부에서 발급·영속 저장된다.
  /// 네트워크 유실 후 재시도에서도 동일 ID가 재사용된다 (TR-03).
  Future<void> toggleChecklistItem(ChecklistItem item, bool completed) async {
    final plan = state.value;
    if (plan == null) return;

    final newStatus = completed
        ? ChecklistCompletionStatus.completed
        : ChecklistCompletionStatus.pending;

    final optimistic = plan.copyWith(
      checklist: [
        for (final c in plan.checklist)
          if (c.planPrepItemId == item.planPrepItemId)
            c.copyWith(completionStatus: newStatus)
          else
            c,
      ],
    );
    state = AsyncValue.data(optimistic);

    try {
      await repo.resolveChecklistItem(
          plan.planId, item.planPrepItemId, newStatus,
          clientEventId: _uuid.v4());
    } catch (_) {
      state = AsyncValue.data(plan); // 롤백
    }
  }

  /// 웰니스 행동 resolve — 동일하게 clientEventId를 호출 시점에 발급.
  Future<void> resolveWellnessAction(
    WellnessAction action,
    WellnessActionCompletionStatus status,
  ) async {
    final plan = state.value;
    if (plan == null) return;

    final optimistic = plan.copyWith(
      wellnessActions: [
        for (final w in plan.wellnessActions)
          if (w.wellnessActionId == action.wellnessActionId)
            w.copyWith(completionStatus: status)
          else
            w,
      ],
    );
    state = AsyncValue.data(optimistic);

    try {
      await repo.resolveWellnessAction(
          plan.planId, action.wellnessActionId, status,
          clientEventId: _uuid.v4());
    } catch (_) {
      state = AsyncValue.data(plan);
    }
  }
}