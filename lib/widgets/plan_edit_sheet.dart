import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "../models/place.dart";
import "../network/api_client.dart";
import "../providers/home_providers.dart";
import "../repository/providers.dart";
import "../theme/ensom_colors.dart";
import "ensom/ensom_date_picker_sheet.dart";
import "ensom/ensom_pill_button.dart";
import "ensom/ensom_time_picker_sheet.dart";

/// PLAN-04 계획 수정 시트.
/// BE는 GET /places로 등록 장소를 제공하고 PATCH /plans/{planId}의
/// originPlaceId, prepStartAt을 모두 지원한다. 저장 성공 응답은 새 plan
/// revision이며 PlanController가 화면 상태를 교체한다.
final _planEditPlacesProvider = FutureProvider.autoDispose<List<Place>>((
  ref,
) async {
  final repository = ref.watch(ensomRepositoryProvider);
  return repository.fetchPlaces();
});

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
  String? _originPlaceId;
  bool _saving = false;

  Future<void> _pickTime() async {
    final date = await EnsomDatePickerSheet.show(
      context,
      initial: _prepStartAt,
    );
    if (date == null || !mounted) return;

    final time = await EnsomTimePickerSheet.show(
      context,
      initial: TimeOfDay.fromDateTime(_prepStartAt),
    );
    if (time == null) return;

    setState(() {
      _prepStartAt = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await ref
          .read(planControllerProvider(widget.eventId).notifier)
          .updatePlan(prepStartAt: _prepStartAt, originPlaceId: _originPlaceId);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("계획을 수정했어요.")));
      Navigator.pop(context, true);
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
      setState(() => _saving = false);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("수정하지 못했어요. 다시 시도해주세요.")));
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
    final placesAsync = ref.watch(_planEditPlacesProvider);
    final changed =
        _prepStartAt != widget.initialPrepStartAt || _originPlaceId != null;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        10,
        20,
        MediaQuery.of(context).padding.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: EnsomColors.surfaceNeutral,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            "계획 수정",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: -.2,
              color: EnsomColors.ink,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "저장하면 이후 계획이 다시 계산돼요.",
            style: TextStyle(fontSize: 11.5, color: EnsomColors.inkMuted),
          ),
          const SizedBox(height: 16),
          const Text(
            "출발지",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: EnsomColors.inkMuted,
            ),
          ),
          const SizedBox(height: 6),
          _buildOriginPicker(placesAsync),
          const SizedBox(height: 16),
          const Text(
            "준비 시작 시각",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: EnsomColors.inkMuted,
            ),
          ),
          const SizedBox(height: 6),
          Material(
            color: EnsomColors.surface2,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: _saving ? null : _pickTime,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 13,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.schedule,
                      size: 16,
                      color: EnsomColors.inkFaint,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _timeLabel,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: EnsomColors.ink,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      size: 17,
                      color: EnsomColors.inkFaint,
                    ),
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

  Widget _buildOriginPicker(AsyncValue<List<Place>> placesAsync) {
    return placesAsync.when(
      loading: () => const _OriginPickerMessage(
        child: Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 8),
            Text("등록 장소를 불러오는 중..."),
          ],
        ),
      ),
      error: (_, _) => const _OriginPickerMessage(
        child: Text("등록 장소를 불러오지 못했어요. 출발지 변경 없이 저장할 수 있어요."),
      ),
      data: (places) {
        if (places.isEmpty) {
          return const _OriginPickerMessage(
            child: Text("등록한 장소가 없어요. 장소 관리에서 먼저 등록해주세요."),
          );
        }
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: EnsomColors.surface2,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _originPlaceId,
              isExpanded: true,
              hint: const Text("등록한 장소 선택"),
              items: [
                for (final place in places)
                  DropdownMenuItem(
                    value: place.placeId,
                    child: Text(
                      "${place.placeName}${place.isPrimary ? ' · 기본 장소' : ''}",
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
              onChanged: _saving
                  ? null
                  : (placeId) => setState(() => _originPlaceId = placeId),
            ),
          ),
        );
      },
    );
  }
}

class _OriginPickerMessage extends StatelessWidget {
  const _OriginPickerMessage({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: EnsomColors.surface2,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DefaultTextStyle(
        style: const TextStyle(fontSize: 12, color: EnsomColors.inkMuted),
        child: child,
      ),
    );
  }
}
