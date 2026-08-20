import "package:flutter/material.dart";
import "../../models/event.dart";
import "../../models/plan.dart";
import "../../theme/ensom_colors.dart";
import "ensom_pill_button.dart";
import "ensom_text_field.dart";

/// S-45 간단 저장 시트. 지도에서 가져온 출발지·목적지·시각·선택 경로는
/// 읽기 전용 요약으로만 보여주고(PRD §10.5), 사용자에게는 일정 이름만
/// 받는다. 실제 API(`POST /events`)는 캘린더 소스 다중 선택(개인/업무/
/// 가족)이 아니라 연결된 구글 캘린더 하나(`writeToCalendarSourceId`)뿐이고,
/// 그 id를 얻어올 엔드포인트가 아직 없어 이번 시트에는 캘린더 선택 UI를
/// 넣지 않았다 — 목업(ensom_map.html)과 달라진 부분.
class EnsomQuickSaveSheet {
  static Future<QuickSaveResult?> show(
    BuildContext context, {
    required String destName,
    required EventAnchor anchorMode,
    required DateTime at,
    required RouteOption route,
    String? initialLabel,
  }) {
    return showModalBottomSheet<QuickSaveResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: EnsomColors.canvas,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (context) => _QuickSaveSheetBody(
        destName: destName,
        anchorMode: anchorMode,
        at: at,
        route: route,
        initialLabel: initialLabel,
      ),
    );
  }
}

class QuickSaveResult {
  const QuickSaveResult.save(this.label) : detailedEdit = false;

  const QuickSaveResult.detailedEdit(this.label) : detailedEdit = true;

  final String? label;
  final bool detailedEdit;
}

class _QuickSaveSheetBody extends StatefulWidget {
  const _QuickSaveSheetBody({
    required this.destName,
    required this.anchorMode,
    required this.at,
    required this.route,
    this.initialLabel,
  });

  final String destName;
  final EventAnchor anchorMode;
  final DateTime at;
  final RouteOption route;
  final String? initialLabel;

  @override
  State<_QuickSaveSheetBody> createState() => _QuickSaveSheetBodyState();
}

class _QuickSaveSheetBodyState extends State<_QuickSaveSheetBody> {
  late final _labelController = TextEditingController(text: widget.initialLabel ?? "");

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }

  String _rankLabel(RouteType type) {
    switch (type) {
      case RouteType.fastest:
        return "가장 빠른 경로";
      case RouteType.leastWalk:
        return "도보가 적은 경로";
      case RouteType.leastTransfer:
        return "환승이 적은 경로";
    }
  }

  String get _timeSummary {
    final anchorLabel = widget.anchorMode == EventAnchor.arriveBy ? "도착" : "출발";
    final m = widget.at.month;
    final d = widget.at.day;
    final hh = widget.at.hour.toString().padLeft(2, "0");
    final mm = widget.at.minute.toString().padLeft(2, "0");
    return "$m/$d $hh:$mm $anchorLabel";
  }

  @override
  Widget build(BuildContext context) {
    final label = _labelController.text.trim();

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, MediaQuery.of(context).viewInsets.bottom + MediaQuery.of(context).padding.bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(color: EnsomColors.surfaceNeutral, borderRadius: BorderRadius.circular(999)),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            "일정으로 저장",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: -.2, color: EnsomColors.ink),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: EnsomColors.surface2, borderRadius: BorderRadius.circular(14)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SummaryRow(icon: Icons.place_outlined, text: widget.destName),
                const SizedBox(height: 8),
                _SummaryRow(icon: Icons.schedule, text: _timeSummary),
                const SizedBox(height: 8),
                _SummaryRow(
                  icon: Icons.alt_route,
                  text: "${_rankLabel(widget.route.routeType)} · ${widget.route.totalMinutes}분",
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          EnsomTextField(
            label: "일정 이름",
            controller: _labelController,
            autofocus: true,
            textInputAction: TextInputAction.done,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 18),
          EnsomPillButton(
            label: "저장",
            onPressed: label.isEmpty
                ? null
                : () => Navigator.pop(context, QuickSaveResult.save(label)),
          ),
          const SizedBox(height: 4),
          EnsomPillButton(
            label: "더 고칠 게 있으면 자세히 편집",
            variant: EnsomPillVariant.text,
            onPressed: () => Navigator.pop(
              context,
              QuickSaveResult.detailedEdit(label.isEmpty ? null : label),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: EnsomColors.inkFaint),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: EnsomColors.ink),
          ),
        ),
      ],
    );
  }
}
