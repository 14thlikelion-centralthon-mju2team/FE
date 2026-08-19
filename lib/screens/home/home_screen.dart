import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:uuid/uuid.dart";
import "../../core/local_notification_service.dart";
import "../../models/action_log.dart";
import "../../models/plan.dart";
import "../../providers/home_providers.dart";
import "../../providers/offline_queue_providers.dart";
import "../../repository/providers.dart";
import "../../widgets/permission_degraded_banner.dart";
import "../../theme/ensom_colors.dart";
import "widgets/arrival_result_card.dart";
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
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("오프라인 상태예요. 연결되면 자동으로 반영돼요.")));
  }

  // 지오펜스가 도착을 확정하지 못했을 때(무신호·권한 거부)의 수동 폴백
  // (TRD §9.3). 배치 큐가 아니라 즉시 호출한다 -- 지오펜스 경로도 큐를
  // 거치지 않고 바로 reportArrival을 부르므로 동일한 방식을 쓴다.
  Future<void> _reportArrived(String eventId, String planId) async {
    try {
      await ref
          .read(ensomRepositoryProvider)
          .reportArrival(
            eventId,
            planId,
            clientEventId: const Uuid().v4(),
            source: ActionSource.user,
          );
      ref.read(planControllerProvider(eventId).notifier).retry();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("처리하지 못했어요. 다시 시도해주세요.")));
    }
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
                  Icon(
                    Icons.event_available,
                    size: 48,
                    color: EnsomColors.inkMuted,
                  ),
                  SizedBox(height: 12),
                  Text(
                    "다가오는 일정이 없어요.",
                    style: TextStyle(color: EnsomColors.inkMuted),
                  ),
                ],
              ),
            );
          }

          final planState = ref.watch(planControllerProvider(event.eventId));
          final controller = ref.read(
            planControllerProvider(event.eventId).notifier,
          );

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
            data: (plan) {
              _scheduleLocalNotifications(plan, event.displayName);
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const PermissionDegradedBanner(
                    type: DegradedPermissionType.notification,
                  ),
                  const PermissionDegradedBanner(
                    type: DegradedPermissionType.location,
                  ),
                  PlanCard(
                    eventTitle: event.displayName,
                    plan: plan,
                    previousPlan: controller.previousPlan,
                    onTap: () => context.push("/events/${event.eventId}"),
                    onPrepStart: () => _enqueueAndMaybeRefresh(
                      event.eventId,
                      plan.planId,
                      ActionType.prepStarted,
                    ),
                    onPrepFinished: () => _enqueueAndMaybeRefresh(
                      event.eventId,
                      plan.planId,
                      ActionType.prepFinished,
                    ),
                    onDeparted: () => _enqueueAndMaybeRefresh(
                      event.eventId,
                      plan.planId,
                      ActionType.departed,
                    ),
                    onArrived: () => _reportArrived(event.eventId, plan.planId),
                    onSnooze: () => _enqueueAndMaybeRefresh(
                      event.eventId,
                      plan.planId,
                      ActionType.snoozed,
                    ),
                    onSkip: () => _enqueueAndMaybeRefresh(
                      event.eventId,
                      plan.planId,
                      ActionType.excluded,
                    ),
                    onSelectRoute: () => context.push(
                      "/plans/${plan.planId}/routes?eventId=${event.eventId}",
                    ),
                    onToggleChecklistItem: (item, completed) async {
                      try {
                        await controller.toggleChecklistItem(item, completed);
                      } catch (_) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("처리하지 못했어요. 다시 시도해주세요."),
                          ),
                        );
                      }
                    },
                    onResolveWellnessAction: (action, status) async {
                      try {
                        await controller.resolveWellnessAction(action, status);
                      } catch (_) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("처리하지 못했어요. 다시 시도해주세요."),
                          ),
                        );
                      }
                    },
                  ),
                  if (plan.eventStatus == EventLifecycleStatus.arrived ||
                      plan.eventStatus == EventLifecycleStatus.closed) ...[
                    const SizedBox(height: 16),
                    ArrivalResultCard(eventId: event.eventId),
                    const SizedBox(height: 12),
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.nightlight_round_outlined),
                        title: const Text("오늘의 마무리"),
                        subtitle: const Text("하루를 돌아보세요"),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.push("/summary/daily"),
                      ),
                    ),
                  ],
                ],
              );
            },
          );
        },
      ),
    );
  }
}
