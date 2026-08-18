import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "../../core/local_notification_service.dart";
import "../../models/action_log.dart";
import "../../models/plan.dart";
import "../../providers/home_providers.dart";
import "../../providers/offline_queue_providers.dart";
import "widgets/plan_card.dart";

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int? _lastScheduledRevision;

  Future<void> _enqueueAndMaybeRefresh(
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

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("오프라인 상태예요. 연결되면 자동으로 반영돼요.")),
    );
  }

  void _scheduleLocalNotifications(Plan plan, String eventDisplayName) {
    if (_lastScheduledRevision == plan.revisionNo) return;
    _lastScheduledRevision = plan.revisionNo;
    LocalNotificationService.instance.schedulePlanNotifications(
      eventId: plan.eventId,
      revisionNo: plan.revisionNo,
      prepStartAt: plan.prepStartAt,
      recommendedDepartAt: plan.recommendedDepartAt,
      eventDisplayName: eventDisplayName,
    );
  }

  @override
  Widget build(BuildContext context) {
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
        error: (err, st) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("불러오지 못했어요: $err"),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => ref.invalidate(nextEventProvider),
                child: const Text("다시 시도"),
              ),
            ],
          ),
        ),
        data: (event) {
          if (event == null) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.event_available, size: 48, color: Colors.grey),
                  SizedBox(height: 12),
                  Text("다가오는 일정이 없어요.", style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          final planState = ref.watch(planControllerProvider(event.eventId));
          final controller = ref.read(planControllerProvider(event.eventId).notifier);

          return planState.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, st) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("계획을 불러오지 못했어요: $err"),
                  const SizedBox(height: 12),
                  ElevatedButton(onPressed: controller.retry, child: const Text("다시 시도")),
                ],
              ),
            ),
            data: (plan) {
              _scheduleLocalNotifications(plan, event.displayName);
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  PlanCard(
                    eventTitle: event.displayName,
                    plan: plan,
                    previousPlan: controller.previousPlan,
                    onPrepStart: () => _enqueueAndMaybeRefresh(
                      event.eventId, plan.planId, ActionType.prepStarted,
                    ),
                    onDeparted: () => _enqueueAndMaybeRefresh(
                      event.eventId, plan.planId, ActionType.departed,
                    ),
                    onSnooze: () => _enqueueAndMaybeRefresh(
                      event.eventId, plan.planId, ActionType.snoozed,
                    ),
                    onSkip: () => _enqueueAndMaybeRefresh(
                      event.eventId, plan.planId, ActionType.excluded,
                    ),
                    onSelectRoute: () => context.push(
                      "/plans/${plan.planId}/routes?eventId=${event.eventId}",
                    ),
                    onToggleChecklistItem: (item, completed) async {
                      try {
                        await controller.toggleChecklistItem(item, completed);
                      } catch (_) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("처리하지 못했어요. 다시 시도해주세요.")),
                        );
                      }
                    },
                    onResolveWellnessAction: (action, status) async {
                      try {
                        await controller.resolveWellnessAction(action, status);
                      } catch (_) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("처리하지 못했어요. 다시 시도해주세요.")),
                        );
                      }
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
