import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "../../../models/plan.dart";
import "../../../theme/ensom_colors.dart";

/// 계획이 재계산되어 리비전이 바뀌었을 때 "무엇이 바뀌었는지" 보여주는 배너.
///
/// TRD §8.1 실질 변화 판정:
///   Δ < 2분: 리비전조차 만들지 않음 (여기 도달하지 않음)
///   2 ≤ Δ < 5분: 리비전 갱신 · 홈 반영 · 푸시 없음
///   Δ ≥ 5분: 돌발 슬롯 사용 (서버 푸시 발송)
///
/// 이 위젯은 새 리비전이 로드됐을 때 **이전 리비전과의 차이**를 한눈에 보여준다.
/// 이전 계획이 null이면 (첫 로드) 배너를 표시하지 않는다.
class PlanChangeBanner extends StatelessWidget {
  const PlanChangeBanner({
    super.key,
    required this.currentPlan,
    required this.previousPlan,
  });

  final Plan currentPlan;
  final Plan? previousPlan;

  @override
  Widget build(BuildContext context) {
    if (previousPlan == null) return const SizedBox.shrink();
    if (previousPlan!.revisionNo == currentPlan.revisionNo) {
      return const SizedBox.shrink();
    }

    final changes = _computeChanges();
    if (changes.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: EnsomColors.caution.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: EnsomColors.caution.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.update, size: 16, color: EnsomColors.caution),
              const SizedBox(width: 6),
              Text(
                "계획이 업데이트됐어요",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: EnsomColors.caution,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (final change in changes)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("• ", style: TextStyle(color: EnsomColors.caution)),
                  Expanded(
                    child: Text(change, style: const TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
          // reasons에서 adjusted=true인 항목을 근거로 표시
          ..._adjustedReasons(),
        ],
      ),
    );
  }

  List<String> _computeChanges() {
    final prev = previousPlan!;
    final curr = currentPlan;
    final changes = <String>[];
    final timeFormat = DateFormat("a h:mm", "ko_KR");

    // 준비 시작 시각 변화
    final prepDiff = curr.prepStartAt.difference(prev.prepStartAt).inMinutes;
    if (prepDiff.abs() >= 2) {
      final direction = prepDiff < 0 ? "앞당겨" : "늦춰";
      changes.add(
        "준비 시작이 ${prepDiff.abs()}분 ${direction}졌어요 → ${timeFormat.format(curr.prepStartAt)}",
      );
    }

    // 출발 시각 변화
    final departDiff = curr.recommendedDepartAt
        .difference(prev.recommendedDepartAt)
        .inMinutes;
    if (departDiff.abs() >= 2) {
      final direction = departDiff < 0 ? "앞당겨" : "늦춰";
      changes.add(
        "권장 출발이 ${departDiff.abs()}분 ${direction}졌어요 → ${timeFormat.format(curr.recommendedDepartAt)}",
      );
    }

    // feasible 변화
    if (prev.feasible && !curr.feasible) {
      changes.add("지금 출발해도 약속 시간보다 늦을 수 있어요");
    } else if (!prev.feasible && curr.feasible) {
      changes.add("여유가 생겼어요 — 제시간에 도착할 수 있어요");
    }

    // 이동 시간 변화
    final travelDiff =
        curr.breakdown.travelMinutes - prev.breakdown.travelMinutes;
    if (travelDiff.abs() >= 3) {
      final direction = travelDiff > 0 ? "늘어" : "줄어";
      changes.add("이동 시간이 ${travelDiff.abs()}분 ${direction}들었어요");
    }

    // 교통 버퍼 변화 (교통 지연)
    final bufferDiff =
        curr.breakdown.trafficBufferMinutes -
        prev.breakdown.trafficBufferMinutes;
    if (bufferDiff.abs() >= 3) {
      if (bufferDiff > 0) {
        changes.add("교통 상황을 반영해 여유를 ${bufferDiff}분 추가했어요");
      }
    }

    return changes;
  }

  /// reasons 배열에서 adjusted=true인 항목의 text를 근거로 표시.
  List<Widget> _adjustedReasons() {
    final adjusted = currentPlan.reasons
        .where((r) => r.adjusted)
        .take(2)
        .toList();
    if (adjusted.isEmpty) return [];

    return [
      const SizedBox(height: 4),
      for (final reason in adjusted)
        Padding(
          padding: const EdgeInsets.only(left: 12, bottom: 2),
          child: Text(
            "↳ ${reason.text}",
            style: TextStyle(fontSize: 11, color: EnsomColors.inkFaint),
          ),
        ),
    ];
  }
}
