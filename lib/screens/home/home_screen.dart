import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:uuid/uuid.dart";
import "../../core/coachmark_service.dart";
import "../../core/local_notification_service.dart";
import "../../models/action_log.dart";
import "../../models/event.dart";
import "../../models/plan.dart";
import "../../providers/home_providers.dart";
import "../../providers/offline_queue_providers.dart";
import "../../repository/providers.dart";
import "../../theme/ensom_colors.dart";
import "../../widgets/coachmark_overlay.dart";
import "../../widgets/ensom/ensom_pill_button.dart";
import "../../widgets/ensom/ensom_wordmark.dart";
import "../../widgets/permission_degraded_banner.dart";
import "widgets/arrival_result_card.dart";
import "widgets/home_empty_state.dart";
import "widgets/plan_card.dart";
import "widgets/weather_widget.dart";

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int? _lastScheduledRevision;
  bool _coachmarkChecked = false;

  Future<void> _maybeShowCoachmark() async {
    final shouldShow = await CoachmarkService.instance.shouldShowCoachmark();
    if (!shouldShow || !mounted) return;
    _showCoachmarkOverlay();
  }

  void _showCoachmarkOverlay() {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => CoachmarkOverlay(
        onDismiss: () {
          entry.remove();
          CoachmarkService.instance.markCoachmarkShown();
        },
      ),
    );
    overlay.insert(entry);
  }

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
      backgroundColor: EnsomColors.canvas,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const EnsomWordmark(fontSize: 15),
                  _IconAction(
                    icon: Icons.notifications_none,
                    tooltip: "오늘의 알림",
                    onTap: () => context.push("/notifications/today"),
                  ),
                ],
              ),
            ),
            Expanded(child: _buildBody(nextEventAsync)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(AsyncValue<Event?> nextEventAsync) {
    return nextEventAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("불러오지 못했어요.", style: TextStyle(color: EnsomColors.inkMuted)),
              const SizedBox(height: 14),
              EnsomPillButton(
                label: "다시 시도",
                expand: false,
                onPressed: () => ref.invalidate(nextEventProvider),
              ),
            ],
          ),
        ),
        data: (event) {
          if (event == null) {
            return ListView(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 16),
              children: const [
                WeatherWidget(),
                SizedBox(height: 16),
                HomeEmptyState(),
              ],
            );
          }

          final planState = ref.watch(planControllerProvider(event.eventId));
          final controller = ref.read(
            planControllerProvider(event.eventId).notifier,
          );

          // 코치마크: 데이터 로딩 완료 + 일정 있을 때만 1회 표시
          if (!_coachmarkChecked) {
            _coachmarkChecked = true;
            WidgetsBinding.instance.addPostFrameCallback((_) => _maybeShowCoachmark());
          }

          return planState.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, st) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("계획을 불러오지 못했어요.", style: TextStyle(color: EnsomColors.inkMuted)),
                  const SizedBox(height: 14),
                  EnsomPillButton(label: "다시 시도", expand: false, onPressed: controller.retry),
                ],
              ),
            ),
            data: (plan) {
              _scheduleLocalNotifications(plan, event.displayName);
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const WeatherWidget(),
                  const SizedBox(height: 12),
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
                    _DailySummaryRow(onTap: () => context.push("/summary/daily")),
                  ],
                ],
              );
            },
          );
        },
      );
  }
}

class _IconAction extends StatelessWidget {
  const _IconAction({required this.icon, required this.tooltip, required this.onTap});

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: EnsomColors.surface2,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: 32,
            height: 32,
            child: Icon(icon, size: 16, color: EnsomColors.ink),
          ),
        ),
      ),
    );
  }
}

class _DailySummaryRow extends StatelessWidget {
  const _DailySummaryRow({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: EnsomColors.surface1,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: EnsomColors.hairline),
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(color: EnsomColors.surface2, shape: BoxShape.circle),
                child: const Icon(Icons.nightlight_round_outlined, size: 15, color: EnsomColors.ink),
              ),
              const SizedBox(width: 11),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "오늘의 마무리",
                      style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, letterSpacing: -.2, color: EnsomColors.ink),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "하루를 돌아보세요",
                      style: TextStyle(fontSize: 11.5, color: EnsomColors.inkFaint),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, size: 16, color: EnsomColors.inkFaint),
            ],
          ),
        ),
      ),
    );
  }
}
