import "package:flutter/material.dart";
import "../../../models/plan.dart";
import "../../../theme/ensom_colors.dart";

/// WELL-03. Plan.wellnessActions는 checklist와 별도 배열이다
/// (API v5.0 §9.2). 완료(completed)/해제(dismissed) 두 상태만 있고
/// "미루기"는 여기 없다 -- 그건 실제 푸시 알림 응답
/// (WellnessResponseAction, POST /notifications/{id}/respond) 쪽 개념이라
/// 계획 화면의 이 카드와는 다른 흐름이다.
class WellnessActionsSection extends StatelessWidget {
  const WellnessActionsSection({
    super.key,
    required this.actions,
    required this.onResolve,
  });

  final List<WellnessAction> actions;
  final void Function(
    WellnessAction action,
    WellnessActionCompletionStatus status,
  )
  onResolve;

  @override
  Widget build(BuildContext context) {
    if (actions.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("웰니스 행동", style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        for (final action in actions)
          _WellnessActionRow(action: action, onResolve: onResolve),
      ],
    );
  }
}

class _WellnessActionRow extends StatelessWidget {
  const _WellnessActionRow({required this.action, required this.onResolve});

  final WellnessAction action;
  final void Function(
    WellnessAction action,
    WellnessActionCompletionStatus status,
  )
  onResolve;

  @override
  Widget build(BuildContext context) {
    final resolved =
        action.completionStatus != WellnessActionCompletionStatus.proposed;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.wb_sunny_outlined,
            size: 16,
            color: resolved ? EnsomColors.inkMuted : EnsomColors.caution,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  action.actionLabel,
                  style: TextStyle(
                    decoration:
                        action.completionStatus ==
                            WellnessActionCompletionStatus.completed
                        ? TextDecoration.lineThrough
                        : null,
                    color: resolved ? EnsomColors.inkMuted : null,
                  ),
                ),
                if (action.reasonSnapshot != null && !resolved)
                  Text(
                    action.reasonSnapshot!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: EnsomColors.inkMuted,
                    ),
                  ),
              ],
            ),
          ),
          if (!resolved) ...[
            TextButton(
              onPressed: () =>
                  onResolve(action, WellnessActionCompletionStatus.completed),
              child: const Text("완료"),
            ),
            TextButton(
              onPressed: () =>
                  onResolve(action, WellnessActionCompletionStatus.dismissed),
              child: const Text("넘어갈게요"),
            ),
          ],
        ],
      ),
    );
  }
}
