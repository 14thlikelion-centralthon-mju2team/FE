import "package:flutter/material.dart";
import "../theme/ensom_colors.dart";

class StateBadge extends StatelessWidget {
  final String state; // green | yellow | red — 서버 호환 상태명

  const StateBadge({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (state) {
      "green" => (EnsomColors.limeInk, "양호"),
      "yellow" => (EnsomColors.caution, "주의"),
      "red" => (EnsomColors.caution, "복귀 필요"),
      _ => throw ArgumentError("알 수 없는 state 값: $state"),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 8, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
