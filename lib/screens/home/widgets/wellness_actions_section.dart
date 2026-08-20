import "package:flutter/material.dart";
import "../../../models/plan.dart";
import "../../../theme/ensom_colors.dart";

/// WELL-03. Plan.wellnessActions는 checklist와 별도 배열이다
/// (API v5.0 §9.2). 완료(completed)/해제(dismissed) 두 상태만 있고
/// "미루기"는 여기 없다 -- 그건 실제 푸시 알림 응답
/// (과거 notification response API) 쪽 개념이라
/// 계획 화면의 이 카드와는 다른 흐름이다.
///
/// ensom_detail.html `.wrow` 패턴 — 체크박스 + 항목명 + 라임 "이유 태그"
/// (자외선 높음 · 야외 12분 같은 근거). 해결되면 태그도 함께 회색으로
/// 죽는다. WIS 점수는 어디에도 표시하지 않는다(PRD §8.7).
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
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            "환경 웰니스",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: -.2,
              color: EnsomColors.ink,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: EnsomColors.surface1,
            borderRadius: BorderRadius.circular(19),
            border: Border.all(color: EnsomColors.hairline),
          ),
          child: Column(
            children: [
              for (var i = 0; i < actions.length; i++)
                _WellnessActionRow(
                  action: actions[i],
                  isLast: i == actions.length - 1,
                  onResolve: onResolve,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WellnessActionRow extends StatelessWidget {
  const _WellnessActionRow({
    required this.action,
    required this.isLast,
    required this.onResolve,
  });

  final WellnessAction action;
  final bool isLast;
  final void Function(
    WellnessAction action,
    WellnessActionCompletionStatus status,
  )
  onResolve;

  @override
  Widget build(BuildContext context) {
    final resolved =
        action.completionStatus != WellnessActionCompletionStatus.proposed;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: EnsomColors.hairline)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              width: 21,
              height: 21,
              decoration: BoxDecoration(
                color: resolved ? EnsomColors.cta : Colors.white,
                borderRadius: BorderRadius.circular(7),
                border: Border.all(
                  color: resolved ? EnsomColors.cta : EnsomColors.hairline,
                  width: 1.8,
                ),
              ),
              child: resolved
                  ? const Icon(Icons.check, size: 13, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  action.actionLabel,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                    color: resolved ? EnsomColors.inkFaint : EnsomColors.ink,
                    decoration:
                        action.completionStatus ==
                            WellnessActionCompletionStatus.completed
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                if (action.reasonSnapshot != null) ...[
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: resolved
                          ? EnsomColors.surface2
                          : EnsomColors.limeSoft,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      action.reasonSnapshot!,
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: resolved
                            ? EnsomColors.inkFaint
                            : EnsomColors.limeInk,
                      ),
                    ),
                  ),
                ],
                if (!resolved) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _MiniAction(
                        label: "완료",
                        onTap: () => onResolve(
                          action,
                          WellnessActionCompletionStatus.completed,
                        ),
                      ),
                      const SizedBox(width: 14),
                      _MiniAction(
                        label: "넘어갈게요",
                        muted: true,
                        onTap: () => onResolve(
                          action,
                          WellnessActionCompletionStatus.dismissed,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniAction extends StatelessWidget {
  const _MiniAction({
    required this.label,
    required this.onTap,
    this.muted = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          color: muted ? EnsomColors.inkFaint : EnsomColors.ink,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
