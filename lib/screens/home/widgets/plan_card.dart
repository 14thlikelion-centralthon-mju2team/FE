import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "../../../models/plan.dart";
import "reason_section.dart";
import "checklist_section.dart";
import "plan_change_banner.dart";

/// HOME-01/02.
///
/// 리뷰 3라운드째 지적됐던 문제가 여기서 확정됩니다: 상태 문구는
/// planStatus가 아니라 eventStatus 기준이어야 한다(API v5.0 §9.2).
/// planStatus는 리비전 관리값(active/superseded)이라 사용자에게
/// "지금 뭘 해야 하는지"를 설명하지 않는다.
class PlanCard extends StatelessWidget {
  const PlanCard({
    super.key,
    required this.eventTitle,
    required this.plan,
    this.previousPlan,
    required this.onPrepStart,
    required this.onDeparted,
    required this.onSnooze,
    required this.onSkip,
    required this.onSelectRoute,
    required this.onToggleChecklistItem,
  });

  final String eventTitle;
  final Plan plan;
  final Plan? previousPlan;
  final VoidCallback onPrepStart;
  final VoidCallback onDeparted;
  final VoidCallback onSnooze;
  final VoidCallback onSkip;
  final VoidCallback onSelectRoute;
  final void Function(ChecklistItem item, bool completed) onToggleChecklistItem;

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
    }
  }

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat("a h:mm", "ko_KR");
    return Card(
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
              _WellnessActionsPreview(actions: plan.wellnessActions),
            ],
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(onPressed: onPrepStart, child: const Text("준비 시작")),
                OutlinedButton(onPressed: onDeparted, child: const Text("출발했어요")),
                OutlinedButton(onPressed: onSnooze, child: const Text("5분 뒤 알림")),
                OutlinedButton(onPressed: onSelectRoute, child: const Text("경로 확인")),
                TextButton(onPressed: onSkip, child: const Text("이번 일정 제외")),
              ],
            ),
          ],
        ),
      ),
    );
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

/// 읽기 전용 미리보기만 제공한다. 완료/해제 상호작용은
/// feat/fe-wellness(M3)에서 본격적으로 만든다 -- 여기서는 Plan 응답에
/// 이미 포함된 데이터를 조용히 버리지 않는다는 정도의 의미다.
class _WellnessActionsPreview extends StatelessWidget {
  const _WellnessActionsPreview({required this.actions});

  final List<WellnessAction> actions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("웰니스 행동", style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        for (final action in actions)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                Icon(Icons.wb_sunny_outlined, size: 14, color: Colors.orange[700]),
                const SizedBox(width: 6),
                Text(action.actionLabel),
              ],
            ),
          ),
      ],
    );
  }
}