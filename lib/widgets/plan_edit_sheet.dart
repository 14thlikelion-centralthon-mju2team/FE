import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "../network/api_client.dart";
import "../providers/home_providers.dart";
import "../theme/ensom_colors.dart";
import "ensom/ensom_date_picker_sheet.dart";
import "ensom/ensom_pill_button.dart";
import "ensom/ensom_time_picker_sheet.dart";

/// PLAN-04 계획 수정 시트.
/// 호출: DTL-01(S-12) 상단 메뉴의 "계획 수정".
/// BE: PATCH /plans/{planId} (docs/API.md §9.5) — 사용자 수정은 새
/// 리비전을 만든다.
///
/// 목업(ensom_detail.html)은 출발지도 함께 고르게 하지만, 실제 API로
/// 보낼 originPlaceId를 채울 등록 장소 목록 조회(`GET /places`)가
/// ApiEnsomRepository에서 아직 UnimplementedError로 막혀 있어(별도
/// 스코프, feature/geofence-place-management) 이번 시트는 준비 시작
/// 시각만 다룬다.
class PlanEditSheet extends ConsumerStatefulWidget {
  const PlanEditSheet({
    super.key,
    required this.eventId,
    required this.initialPrepStartAt,
  });

  final String eventId;
  final DateTime initialPrepStartAt;

  @override
  ConsumerState<PlanEditSheet> createState() => _PlanEditSheetState();
}

class _PlanEditSheetState extends ConsumerState<PlanEditSheet> {
  late DateTime _prepStartAt = widget.initialPrepStartAt;
  bool _saving = false;

  Future<void> _pickTime() async {
    final date = await EnsomDatePickerSheet.show(context, initial: _prepStartAt);
    if (date == null || !mounted) return;

    final time = await EnsomTimePickerSheet.show(
      context,
      initial: TimeOfDay.fromDateTime(_prepStartAt),
    );
    if (time == null) return;

    setState(() {
      _prepStartAt = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await ref
          .read(planControllerProvider(widget.eventId).notifier)
          .updatePlan(prepStartAt: _prepStartAt);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("계획을 수정했어요.")),
      );
      Navigator.pop(context, true);
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      setState(() => _saving = false);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("수정하지 못했어요. 다시 시도해주세요.")),
      );
      setState(() => _saving = false);
    }
  }

  String get _timeLabel {
    final m = _prepStartAt.month;
    final d = _prepStartAt.day;
    final hh = _prepStartAt.hour.toString().padLeft(2, "0");
    final mm = _prepStartAt.minute.toString().padLeft(2, "0");
    return "$m/$d $hh:$mm";
  }

  @override
  Widget build(BuildContext context) {
    final changed = _prepStartAt != widget.initialPrepStartAt;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, MediaQuery.of(context).padding.bottom + 20),
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
            "계획 수정",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: -.2, color: EnsomColors.ink),
          ),
          const SizedBox(height: 6),
          const Text(
            "저장하면 이후 계획이 다시 계산돼요.",
            style: TextStyle(fontSize: 11.5, color: EnsomColors.inkMuted),
          ),
          const SizedBox(height: 16),
          const Text(
            "준비 시작 시각",
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: EnsomColors.inkMuted),
          ),
          const SizedBox(height: 6),
          Material(
            color: EnsomColors.surface2,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: _saving ? null : _pickTime,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                child: Row(
                  children: [
                    const Icon(Icons.schedule, size: 16, color: EnsomColors.inkFaint),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _timeLabel,
                        style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: EnsomColors.ink),
                      ),
                    ),
                    const Icon(Icons.chevron_right, size: 17, color: EnsomColors.inkFaint),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          EnsomPillButton(
            label: _saving ? "저장 중..." : "저장",
            onPressed: (changed && !_saving) ? _save : null,
          ),
        ],
      ),
    );
  }
}
