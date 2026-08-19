import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "../../../models/plan.dart";
import "reason_section.dart";
import "checklist_section.dart";
import "wellness_actions_section.dart";
import "plan_change_banner.dart";

/// HOME-01/02. 상태 문구는 eventStatus 기준(API v5.0 §9.2).
class PlanCard extends StatelessWidget {
  const PlanCard({
    super.key,
    required this.eventTitle,
    required this.plan,
    this.previousPlan,
    this.onTap,
    required this.onPrepStart,
    required this.onPrepFinished,
    required this.onDeparted,
    this.onArrived,
    required this.onSnooze,
    required this.onSkip,
    required this.onSelectRoute,
    required this.onToggleChecklistItem,
    required this.onResolveWellnessAction,
  });

  final String eventTitle;
  final Plan plan;
  final Plan? previousPlan;
  final VoidCallback? onTap;
  final VoidCallback onPrepStart;
  final VoidCallback onPrepFinished;
  final VoidCallback onDeparted;
  // 지오펜스가 도착을 자동 확정하지 못했을 때(무신호·권한 거부)의
  // 수동 폴백(TRD §9.3). enroute·unresolved 상태에서만 노출한다.
  final VoidCallback? onArrived;
  final VoidCallback onSnooze;
  final VoidCallback onSkip;
  final VoidCallback onSelectRoute;
  final void Function(ChecklistItem item, bool completed) onToggleChecklistItem;
  final void Function(WellnessAction action, WellnessActionCompletionStatus status)
      onResolveWellnessAction;

  String get _statusMessage {
    if (!plan.feasible) return "현재 출발하면 약속 시간보다 늦을 수 있습니다.";
    switch (plan.eventStatus) {
      case EventLifecycleStatus.planned:
        return "아직 충분한 여유가 있습니다.";
      case EventLifecycleStatus.notified:
        return "곧 준비를 시작하세요.";
      case EventLifecycleStatus.preparing:
        return "지금부터 준비하는 것이 좋습니다.";
      case EventLifecycleStatus.enroute:
        return "이동 중이에요. 곧 도착 예정입니다.";
      case EventLifecycleStatus.arrived:
        return "도착했어요.";
      case EventLifecycleStatus.closed:
        return "일정이 마무리됐어요.";
      case EventLifecycleStatus.skipped:
        return "이 일정은 건너뛰었어요.";
      case EventLifecycleStatus.cancelled:
        return "이 일정은 취소됐어요.";
      case EventLifecycleStatus.unresolved:
        return "도착 여부를 확인하지 못했어요.";
    }
  }

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat("a h:mm", "ko_KR");
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 계획 변경 배너 — 리비전이 바뀌었을 때만 표시
            PlanChangeBanner(currentPlan: plan, previousPlan: previousPlan),
            Text(eventTitle,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(_statusMessage, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            _TimeRow(label: "준비 시작", time: timeFormat.format(plan.prepStartAt)),
            _TimeRow(label: "권장 출발", time: timeFormat.format(plan.recommendedDepartAt)),
            _TimeRow(label: "도착 예상", time: timeFormat.format(plan.targetArriveAt)),
            const SizedBox(height: 8),
            _BreakdownSummary(breakdown: plan.breakdown),
            if (plan.degraded.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                "일부 정보를 최신으로 반영하지 못했어요.",
                style: TextStyle(fontSize: 12, color: Colors.orange[800]),
              ),
            ],
            const Divider(height: 24),
            ReasonSection(reasons: plan.reasons),
            const Divider(height: 24),
            ChecklistSection(
              checklist: plan.checklist,
              onToggle: onToggleChecklistItem,
            ),
            if (plan.wellnessActions.isNotEmpty) ...[
              const Divider(height: 24),
              WellnessActionsSection(
                actions: plan.wellnessActions,
                onResolve: onResolveWellnessAction,
              ),
            ],
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(onPressed: onPrepStart, child: const Text("준비 시작")),
                OutlinedButton(onPressed: onPrepFinished, child: const Text("준비 완료")),
                OutlinedButton(onPressed: onDeparted, child: const Text("출발했어요")),
                if (onArrived != null &&
                    (plan.eventStatus == EventLifecycleStatus.enroute ||
                        plan.eventStatus == EventLifecycleStatus.unresolved))
                  OutlinedButton(onPressed: onArrived, child: const Text("도착했어요")),
                OutlinedButton(onPressed: onSnooze, child: const Text("5분 뒤 알림")),
                OutlinedButton(onPressed: onSelectRoute, child: const Text("경로 확인")),
                TextButton(onPressed: onSkip, child: const Text("이번 일정 제외")),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}

class _TimeRow extends StatelessWidget {
  const _TimeRow({required this.label, required this.time});

  final String label;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(width: 80, child: Text(label, style: const TextStyle(color: Colors.grey))),
          Text(time, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _BreakdownSummary extends StatelessWidget {
  const _BreakdownSummary({required this.breakdown});

  final PlanBreakdown breakdown;

  @override
  Widget build(BuildContext context) {
    final total = breakdown.estimatedPrepMinutes +
        breakdown.extraPrepMinutes +
        breakdown.personalRoutineMinutes +
        breakdown.travelMinutes +
        breakdown.trafficBufferMinutes +
        breakdown.arrivalBufferMinutes;
    return Text(
      "준비 ${breakdown.estimatedPrepMinutes}분 · 이동 ${breakdown.travelMinutes}분 · "
      "여유 ${breakdown.arrivalBufferMinutes}분 (총 $total분)",
      style: const TextStyle(fontSize: 12, color: Colors.grey),
    );
  }
}