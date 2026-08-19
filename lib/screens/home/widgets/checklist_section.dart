import "package:flutter/material.dart";
import "../../../models/plan.dart";
import "../../../theme/ensom_colors.dart";

/// PLAN-05 체크리스트.
///
/// sourceType은 "사용자 vs 웰니스"가 아니라 데이터 원천(rule/eventItem/
/// weather)이다 -- 웰니스 제안과 사용자 등록이 병합되면 항상
/// sourceType='rule'로 남는다(API v5.0 §9.3). 그래서 이전 라운드에
/// 있던 "웰니스 아이콘"은 여기서 뺐다 -- 그 구분은 이제 Plan.wellnessActions
/// 라는 별도 배열의 몫이다.
class ChecklistSection extends StatelessWidget {
  const ChecklistSection({
    super.key,
    required this.checklist,
    required this.onToggle,
  });

  final List<ChecklistItem> checklist;
  final void Function(ChecklistItem item, bool completed) onToggle;

  static const _sensitiveLabel = "개인 준비";

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
                Text(item.isSensitive ? _sensitiveLabel : item.itemName),
                if (item.actionType == PrepActionType.timedRoutine &&
                    item.appliedMinutes > 0) ...[
                  const SizedBox(width: 6),
                  Text(
                    "+${item.appliedMinutes}분",
                    style: const TextStyle(
                      fontSize: 12,
                      color: EnsomColors.inkMuted,
                    ),
                  ),
                ],
                if (item.isSensitive) ...[
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.lock_outline,
                    size: 14,
                    color: EnsomColors.inkMuted,
                  ),
                ],
              ],
            ),
            subtitle: (!item.isSensitive && item.reason != null)
                ? Text(item.reason!, style: const TextStyle(fontSize: 12))
                : null,
          ),
      ],
    );
  }
}
