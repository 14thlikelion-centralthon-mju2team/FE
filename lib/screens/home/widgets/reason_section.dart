import "package:flutter/material.dart";
import "../../../models/plan.dart";
import "../../../theme/ensom_colors.dart";

/// PLAN-03. API v5.0 §9.1 reasons 배열. 분 단위 값은 여기 없다(원본은
/// breakdown에 있고, 이건 그 값의 근거 문장만 담는다) -- 지난 라운드의
/// PlanReason(label/minutes) 구조를 field/source/adjusted/text로 교체.
class ReasonSection extends StatefulWidget {
  const ReasonSection({super.key, required this.reasons});

  final List<PlanReason> reasons;

  @override
  State<ReasonSection> createState() => _ReasonSectionState();
}

class _ReasonSectionState extends State<ReasonSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.reasons.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                const Text(
                  "계산 근거",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              ],
            ),
          ),
        ),
        if (_expanded) ...widget.reasons.map((item) => _ReasonRow(item: item)),
      ],
    );
  }
}

class _ReasonRow extends StatelessWidget {
  const _ReasonRow({required this.item});

  final PlanReason item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            item.adjusted ? Icons.trending_up : Icons.circle_outlined,
            size: 14,
            color: item.adjusted ? EnsomColors.caution : EnsomColors.inkMuted,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.text,
                  style: TextStyle(
                    fontWeight: item.adjusted
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
                if (item.sampleCount != null)
                  Text(
                    "최근 ${item.sampleCount}회 기록 기준",
                    style: const TextStyle(
                      fontSize: 12,
                      color: EnsomColors.inkMuted,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
