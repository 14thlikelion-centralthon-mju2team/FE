import "package:flutter/material.dart";
import "../../../models/plan.dart";

/// PLAN-03 "계산에 사용된 시간과 요인을 보여줘야 한다".
/// 서버가 정렬하지 않으므로(API 명세 §9) 받은 순서 그대로 표시한다.
/// adjusted: true인 항목은 보정 사유(reason)를 강조 표시한다.
class TraceSection extends StatefulWidget {
  const TraceSection({super.key, required this.trace});

  final List<TraceItem> trace;

  @override
  State<TraceSection> createState() => _TraceSectionState();
}

class _TraceSectionState extends State<TraceSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.trace.isEmpty) return const SizedBox.shrink();

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
          ...widget.trace.map((item) => _TraceRow(item: item)),
      ],
    );
  }
}

class _TraceRow extends StatelessWidget {
  const _TraceRow({required this.item});

  final TraceItem item;

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