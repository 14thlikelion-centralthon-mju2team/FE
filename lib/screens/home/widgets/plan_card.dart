import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "../../../models/plan.dart";
import "reason_section.dart";
import "checklist_section.dart";

/// HOME-01/02.
///
/// 리뷰 Blocker-3 반영: PlanStatus 9개 값을 전부 명시적으로 처리한다
/// (default로 뭉개지 않음 -- 정상 상태가 조용히 기본 문구로 떨어지는
/// 걸 막기 위함). 서버가 statusMessage/statusMessageKey를 내려주는
/// API가 아직 없어서(팀 확인 대기 중, 이슈 트래킹됨) 지금은 enum 값
/// 기준으로 클라이언트가 문구를 소유한다 -- 이건 임시 조치이며,
/// 해당 필드가 API에 추가되는 대로 이 switch 전체를 걷어내야 한다.
class PlanCard extends StatelessWidget {
  const PlanCard({
    super.key,
    required this.eventTitle,
    required this.plan,
    required this.onPrepStart,
    required this.onDeparted,
    required this.onSnooze,
    required this.onSkip,
    required this.onSelectRoute,
    required this.onToggleChecklistItem,
  });

  final String eventTitle;
  final Plan plan;
  final VoidCallback onPrepStart;
  final VoidCallback onDeparted;
  final VoidCallback onSnooze;
  final VoidCallback onSkip;
  final VoidCallback onSelectRoute;
  final void Function(ChecklistItem item, bool completed) onToggleChecklistItem;

  String get _statusMessage {
    if (!plan.feasible) return "현재 출발하면 약속 시간보다 늦을 수 있습니다.";
    switch (plan.planStatus) {
      case PlanStatus.planned:
        return "아직 충분한 여유가 있습니다.";
      case PlanStatus.notified:
        return "곧 준비를 시작하세요.";
      case PlanStatus.preparing:
        return "지금부터 준비하는 것이 좋습니다.";
      case PlanStatus.enroute:
        return "이동 중이에요. 곧 도착 예정입니다.";
      case PlanStatus.arrived:
        return "도착했어요.";
      case PlanStatus.unresolved:
        return "도착 여부를 확인해주세요.";
      case PlanStatus.closed:
        return "일정이 마무리됐어요.";
      case PlanStatus.skipped:
        return "이번 일정은 관리 대상에서 제외됐어요.";
      case PlanStatus.cancelled:
        return "일정이 취소됐어요.";
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
    final total = breakdown.prepMinutes +
        breakdown.extraPrepMinutes +
        breakdown.personalRoutineMinutes +
        breakdown.travelMinutes +
        breakdown.trafficBufferMinutes;
    return Text(
      "준비 ${breakdown.prepMinutes}분 · 이동 ${breakdown.travelMinutes}분 · 여유 ${breakdown.trafficBufferMinutes}분 (총 $total분)",
      style: const TextStyle(fontSize: 12, color: Colors.grey),
    );
  }
}