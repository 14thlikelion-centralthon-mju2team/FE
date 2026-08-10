import 'package:flutter/material.dart';

class StateBadge extends StatelessWidget {
  final String state; // "green" | "yellow" | "red" | null(데이터 부족)

  const StateBadge({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (state) {
      'green' => (const Color(0xFF3F6F6B), '양호'),
      'yellow' => (const Color(0xFFE3B96C), '주의'),
      'red' => (const Color(0xFFA8586B), '복귀 필요'), // State Rose
      _ => (Colors.grey, '기록이 더 필요해요'),
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
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}