import "package:flutter/material.dart";
import "../../../models/plan.dart";

/// PLAN-03. Plan.reasons(구 trace) 표시. 서버가 정렬하지 않으므로
/// 받은 순서 그대로 노출한다.
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
                const Text("계산 근거", style: TextStyle(fontWeight: FontWeight.w600)),
                const Spacer(),
                Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              ],
            ),
          ),
        ),
        if (_expanded)
          ...widget.reasons.map((item) => _ReasonRow(item: item)),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.label),
                if (item.reason != null)
                  Text(
                    item.reason!,
                    style: TextStyle(
                      fontSize: 12,
                      color: item.adjusted ? Colors.orange[800] : Colors.grey,
                    ),
                  ),
              ],
            ),
          ),
          Text(
            "${item.minutes}분",
            style: TextStyle(
              fontWeight: item.adjusted ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}