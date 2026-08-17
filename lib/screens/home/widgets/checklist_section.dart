import "package:flutter/material.dart";
import "../../../models/plan.dart";

/// PLAN-05 체크리스트. origin으로 사용자 등록(user) vs 웰니스 제안
/// (wellness)을 구분 표시한다 -- API 명세 §9, 병합 규칙은 서버가 이미
/// 처리해서 내려주므로 여기서는 표시만 한다.
class ChecklistSection extends StatelessWidget {
  const ChecklistSection({
    super.key,
    required this.checklist,
    required this.onToggle,
  });

  final List<ChecklistItem> checklist;
  final void Function(ChecklistItem item, bool completed) onToggle;

  @override
  Widget build(BuildContext context) {
    if (checklist.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text("준비물", style: TextStyle(fontWeight: FontWeight.w600)),
        ),
        for (final item in checklist)
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            value: item.state == ChecklistState.completed,
            onChanged: (v) => onToggle(item, v ?? false),
            title: Row(
              children: [
                Text(item.label),
                if (item.origin == ChecklistOrigin.wellness) ...[
                  const SizedBox(width: 6),
                  Icon(Icons.wb_sunny_outlined,
                      size: 14, color: Colors.orange[700]),
                ],
              ],
            ),
            subtitle: item.reason != null
                ? Text(item.reason!, style: const TextStyle(fontSize: 12))
                : null,
          ),
      ],
    );
  }
}