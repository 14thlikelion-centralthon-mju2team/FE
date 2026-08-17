import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "../../../models/plan.dart";
import "trace_section.dart";
import "checklist_section.dart";

/// HOME-01/02. PRD §10.2의 6개 고정 상태 문구를 그대로 쓴다 -- 프론트가
/// 임의로 문구를 재구성하지 않는다는 원칙(TR-09와 동일 취지).
///
/// 주의: Plan 모델에 서버가 내려주는 statusMessage 필드가 아직 없다.
/// 지금은 state + feasible로 클라이언트가 문구를 임시 매핑하지만,
/// 이건 미봉책이다 -- API 응답에 statusMessage/statusMessageKey가
/// 추가되는 대로 이 매핑 로직을 통째로 걷어내야 한다 (TODO 하단 참고).
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
    switch (plan.state) {
      case "PLANNED":
        return "아직 충분한 여유가 있습니다.";
      case "NOTIFIED":
        return "곧 준비를 시작하세요.";
      case "PREPARING":
        return "지금부터 준비하는 것이 좋습니다.";
      case "ENROUTE":
        return "10분 안에 출발해야 합니다.";
      default:
        return "일정을 확인해주세요.";
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
            _TimeRow(label: "권장 출발", time: timeFormat.format(plan.departAt)),
            _TimeRow(label: "도착 예상", time: timeFormat.format(plan.etaAt)),
            if (plan.degraded.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                "일부 정보를 최신으로 반영하지 못했어요.",
                style: TextStyle(fontSize: 12, color: Colors.orange[800]),
              ),
            ],
            const Divider(height: 24),
            TraceSection(trace: plan.trace),
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

// TODO(fe-plan-route): 서버 응답에 statusMessage/statusMessageKey가
// 추가되면 _statusMessage 게터를 지우고 plan.statusMessage를 그대로
// 쓰도록 교체. 지금처럼 state 문자열을 클라이언트가 해석하면, 서버가
// 문구를 바꿀 때마다(PRD가 이미 v0.2->v0.4.3 사이 세 번 문구를
// 바꾼 이력이 있음) 이 파일도 매번 같이 고쳐야 한다.