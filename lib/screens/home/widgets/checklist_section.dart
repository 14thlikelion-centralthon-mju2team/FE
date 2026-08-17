import "package:flutter/material.dart";
import "../../../models/plan.dart";

/// PLAN-05 체크리스트.
///
/// 리뷰 High-2 반영: private == true인 항목은 실제 라벨/사유를 화면에
/// 그대로 그리지 않는다. TR-10의 "표시 경계"는 잠금화면뿐 아니라 이
/// 목록 자체에도 적용해야 한다 -- 앱을 잠금 해제한 채로 옆에서 보는
/// 사람에게도 노출되면 안 되기 때문. 서버가 보내는 label/reason 원문은
/// UI에서 절대 조건 없이 렌더링하지 않는다.
class ChecklistSection extends StatelessWidget {
  const ChecklistSection({
    super.key,
    required this.checklist,
    required this.onToggle,
  });

  final List<ChecklistItem> checklist;
  final void Function(ChecklistItem item, bool completed) onToggle;

  static const _privateLabel = "개인 준비";

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
            value: item.completionStatus == ChecklistCompletionStatus.completed,
            onChanged: (v) => onToggle(item, v ?? false),
            title: Row(
              children: [
                Text(item.private ? _privateLabel : item.itemName),
                if (item.sourceType == ChecklistSourceType.wellness) ...[
                  const SizedBox(width: 6),
                  Icon(Icons.wb_sunny_outlined,
                      size: 14, color: Colors.orange[700]),
                ],
                if (item.private) ...[
                  const SizedBox(width: 6),
                  const Icon(Icons.lock_outline, size: 14, color: Colors.grey),
                ],
              ],
            ),
            // private 항목은 reason(근거 문구)도 감춘다 -- 근거 문구
            // 자체에 민감 정보가 섞여 있을 수 있음(예: "복용 시간이 가까워짐").
            subtitle: (!item.private && item.reason != null)
                ? Text(item.reason!, style: const TextStyle(fontSize: 12))
                : null,
          ),
      ],
    );
  }
}