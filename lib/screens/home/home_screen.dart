import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:uuid/uuid.dart";
import "../../models/action_log.dart";
import "../../providers/home_providers.dart";
import "widgets/plan_card.dart";

const _uuid = Uuid();

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  ActionLogEntry _buildAction(ActionType type) {
    // 리뷰 High-3 부분 반영: timestamp 대신 uuid v4. 완전한 해결(오프라인
    // 큐에 넣는 시점에 한 번 발급해 앱 재시작 후에도 재사용)은
    // feat/fe-notification-offline(M2)에서 Drift 큐가 붙어야 가능하다.
    return ActionLogEntry(
      clientEventId: _uuid.v4(),
      type: type,
      deviceTs: DateTime.now(),
      source: ActionSource.manual,
    );
  }

  Future<void> _runAction(
    BuildContext context,
    Future<void> Function() action,
  ) async {
    try {
      await action();
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("처리하지 못했어요. 다시 시도해주세요.")),
      );
    }
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

          // 리뷰 High-2: 승인된 displayLabel이 없으면 원문 title을
          // 그대로 보여주지 않는다.
          final displayTitle = event.displayLabel ?? "다음 일정";

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
                  eventTitle: displayTitle,
                  plan: plan,
                  onPrepStart: () => _runAction(
                    context,
                    () => controller.submitAction(_buildAction(ActionType.prepStarted)),
                  ),
                  onDeparted: () => _runAction(
                    context,
                    () => controller.submitAction(_buildAction(ActionType.departed)),
                  ),
                  onSnooze: () => _runAction(
                    context,
                    () => controller.submitAction(_buildAction(ActionType.snoozed)),
                  ),
                  onSkip: () => _runAction(
                    context,
                    () => controller.submitAction(_buildAction(ActionType.skipped)),
                  ),
                  onSelectRoute: () => context
                      .push("/plans/${plan.planId}/routes?eventId=${event.eventId}"),
                  onToggleChecklistItem: (item, completed) => _runAction(
                    context,
                    () => controller.toggleChecklistItem(item, completed),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}