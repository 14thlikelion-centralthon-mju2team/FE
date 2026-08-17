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
    return ActionLogEntry(
      clientEventId: _uuid.v4(),
      actionType: type,
      deviceTs: DateTime.now(),
      actionSource: ActionSource.user,
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

          // API v5.0 §8.3: displayName은 서버가 displayLabel->
          // destinationName->"오후 2시 일정" 순으로 이미 해석해서
          // 채워준다. 클라이언트가 자체 폴백을 만들 필요가 없다.
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
                  onPrepStart: () => _runAction(
                    context,
                    () => controller
                        .submitActions([_buildAction(ActionType.prepStarted)]),
                  ),
                  onDeparted: () => _runAction(
                    context,
                    () => controller
                        .submitActions([_buildAction(ActionType.departed)]),
                  ),
                  onSnooze: () => _runAction(
                    context,
                    () => controller
                        .submitActions([_buildAction(ActionType.snoozed)]),
                  ),
                  onSkip: () => _runAction(
                    context,
                    () => controller
                        .submitActions([_buildAction(ActionType.excluded)]),
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