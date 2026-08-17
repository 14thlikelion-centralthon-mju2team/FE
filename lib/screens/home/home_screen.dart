import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "../../models/action_log.dart";
import "../../providers/home_providers.dart";
import "../../repository/providers.dart";
import "widgets/plan_card.dart";

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<void> _sendAction(WidgetRef ref, String planId, ActionType type) async {
    final repo = ref.read(ensomRepositoryProvider);
    // TODO(fe-notification-offline): clientEventId는 오프라인 큐에 넣는
    // 시점에 한 번만 발급해서 재사용해야 한다 (TR-03). 지금은 즉시 전송만
    // 가정하고 매번 새로 만들지만, Drift 큐가 붙으면 이 부분을 큐 경유로
    // 바꿔야 한다.
    await repo.submitAction(
      planId,
      ActionLogEntry(
        clientEventId: DateTime.now().microsecondsSinceEpoch.toString(),
        type: type,
        deviceTs: DateTime.now(),
        source: ActionSource.manual,
      ),
    );
    ref.invalidate(latestPlanProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nextEventAsync = ref.watch(nextEventProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("홈"),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              // TODO(fe-notification-offline): 알림 로그 드래그 시트 연결
            },
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
          final planAsync = ref.watch(latestPlanProvider(event.eventId));
          return planAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, st) => Center(child: Text("계획을 불러오지 못했어요: $err")),
            data: (plan) => ListView(
              padding: const EdgeInsets.all(16),
              children: [
                PlanCard(
                  eventTitle: event.title,
                  plan: plan,
                  onPrepStart: () =>
                      _sendAction(ref, plan.planId, ActionType.prepStarted),
                  onDeparted: () =>
                      _sendAction(ref, plan.planId, ActionType.departed),
                  onSnooze: () =>
                      _sendAction(ref, plan.planId, ActionType.snoozed),
                  onSkip: () =>
                      _sendAction(ref, plan.planId, ActionType.skipped),
                  onSelectRoute: () =>
                      context.push("/plans/${plan.planId}/routes"),
                  onToggleChecklistItem: (item, completed) {
                    // TODO(fe-plan-route): repo.resolveChecklistItem 연결
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