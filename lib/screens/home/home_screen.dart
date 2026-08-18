import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:uuid/uuid.dart";
import "../../core/local_notification_service.dart";
import "../../models/action_log.dart";
import "../../models/plan.dart";
import "../../providers/home_providers.dart";
import "widgets/plan_card.dart";

const _uuid = Uuid();

/// 홈 화면. 다음 일정과 활성 계획을 표시하고,
/// 계획이 로드/갱신될 때마다 로컬 알림을 자동 예약한다 (TR-07).
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  /// 마지막으로 로컬 알림을 예약한 리비전 — 중복 예약 방지
  int? _lastScheduledRevision;

  ActionLogEntry _buildAction(ActionType type) {
    return ActionLogEntry(
      clientEventId: _uuid.v4(),
      actionType: type,
      deviceTs: DateTime.now(),
      actionSource: ActionSource.user,
    );
  }

  Future<void> _runAction(Future<void> Function() action) async {
    try {
      await action();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("처리하지 못했어요. 다시 시도해주세요.")),
      );
    }
  }

  /// 계획이 로드/갱신되면 로컬 알림을 (재)예약한다.
  /// 같은 리비전이면 스킵 — 불필요한 OS 호출 방지.
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
                  Text("다가오는 일정이 없어요.",
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
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
            data: (plan) {
              // 계획이 로드될 때마다 로컬 알림 예약 (TR-07)
              _scheduleLocalNotifications(plan, event.displayName);

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  PlanCard(
                    eventTitle: event.displayName,
                    plan: plan,
                    previousPlan: controller.previousPlan,
                    onPrepStart: () => _runAction(
                      () => controller
                          .submitActions([_buildAction(ActionType.prepStarted)]),
                    ),
                    onDeparted: () => _runAction(
                      () => controller
                          .submitActions([_buildAction(ActionType.departed)]),
                    ),
                    onSnooze: () => _runAction(
                      () => controller
                          .submitActions([_buildAction(ActionType.snoozed)]),
                    ),
                    onSkip: () => _runAction(
                      () => controller
                          .submitActions([_buildAction(ActionType.excluded)]),
                    ),
                    onSelectRoute: () => context.push(
                        "/plans/${plan.planId}/routes?eventId=${event.eventId}"),
                    onToggleChecklistItem: (item, completed) => _runAction(
                      () => controller.toggleChecklistItem(item, completed),
                    ),
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
