import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "../../models/action_log.dart";
import "../../providers/home_providers.dart";
import "../../providers/offline_queue_providers.dart";
import "widgets/plan_card.dart";

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  /// 큐에 넣고, 온라인이라 즉시 반영됐으면(true) 계획을 새로고침한다.
  /// 오프라인이면(false) 마지막으로 보여주던 정상 상태를 그대로 두고
  /// 스낵바로만 안내한다 -- 무작정 새로고침하면 좋은 캐시가 에러
  /// 화면으로 바뀔 수 있다.
  Future<void> _enqueueAndMaybeRefresh(
    BuildContext context,
    WidgetRef ref,
    String eventId,
    String planId,
    ActionType type,
  ) async {
    final queue = ref.read(offlineActionQueueServiceProvider);
    final sent = await queue.enqueue(
      planId: planId,
      actionType: type,
      actionSource: ActionSource.user,
    );

    if (sent) {
      ref.read(planControllerProvider(eventId).notifier).retry();
      return;
    }

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("오프라인 상태예요. 연결되면 자동으로 반영돼요.")),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 앱 재시작·홈 진입 시 오프라인 큐 자동 재전송 (BLOCKER #1 해결)
    ref.watch(offlineQueueFlushProvider);

    final nextEventAsync = ref.watch(nextEventProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("홈"),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () => context.push("/notifications/today"),
          ),
        ],
      ),
      body: nextEventAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text("불러오지 못했어요: $err")),
        data: (event) {
          if (event == null) {
            return const Center(child: Text("다가오는 일정이 없어요."));
          }

          final planState = ref.watch(planControllerProvider(event.eventId));
          final controller =
              ref.read(planControllerProvider(event.eventId).notifier);

          return planState.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, st) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("계획을 불러오지 못했어요: $err"),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: controller.retry,
                    child: const Text("다시 시도"),
                  ),
                ],
              ),
            ),
            data: (plan) => ListView(
              padding: const EdgeInsets.all(16),
              children: [
                PlanCard(
                  eventTitle: event.displayName,
                  plan: plan,
                  onPrepStart: () => _enqueueAndMaybeRefresh(
                    context, ref, event.eventId, plan.planId, ActionType.prepStarted,
                  ),
                  onDeparted: () => _enqueueAndMaybeRefresh(
                    context, ref, event.eventId, plan.planId, ActionType.departed,
                  ),
                  onSnooze: () => _enqueueAndMaybeRefresh(
                    context, ref, event.eventId, plan.planId, ActionType.snoozed,
                  ),
                  onSkip: () => _enqueueAndMaybeRefresh(
                    context, ref, event.eventId, plan.planId, ActionType.excluded,
                  ),
                  onSelectRoute: () => context
                      .push("/plans/${plan.planId}/routes?eventId=${event.eventId}"),
                  onToggleChecklistItem: (item, completed) async {
                    try {
                      await controller.toggleChecklistItem(item, completed);
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("처리하지 못했어요. 다시 시도해주세요.")),
                      );
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}