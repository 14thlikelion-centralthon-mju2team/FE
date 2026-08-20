import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "../models/place.dart";
import "../models/plan.dart";
import "../network/api_client.dart";
import "../repository/providers.dart";
import "../theme/ensom_colors.dart";

/// PLAN-04 계획 직접 수정 시트 (API v5.0 §9.5 PATCH /plans/{planId}).
/// 호출: DTL-01 상세 화면 [계획 수정] 메뉴.
///
/// 사용자 직접 수정은 **새 리비전을 만든다**(planStatus active 1건 유지,
/// revisionNo 증가). 이 시트가 다루는 두 손잡이:
///   - prepStartAt : 준비 시작 시각을 사용자가 앞/뒤로 조정
///   - originPlaceId : 출발지 장소 변경 (경로·이동시간 재계산 동반)
///
/// 절대 원칙 5(TRD) — 사용자가 지정한 값이 자동 판단을 이긴다. 이 화면의
/// 입력은 서버 개인화 추정을 덮어쓰는 것이 아니라 이번 계획 리비전에만
/// 적용된다.
///
/// 사용법:
/// ```dart
/// final changed = await showModalBottomSheet<bool>(
///   context: context,
///   isScrollControlled: true,
///   builder: (_) => PlanEditSheet(plan: plan),
/// );
/// if (changed == true) reload();
/// ```
class PlanEditSheet extends ConsumerStatefulWidget {
  const PlanEditSheet({super.key, required this.plan});

  final Plan plan;

  @override
  ConsumerState<PlanEditSheet> createState() => _PlanEditSheetState();
}

class _PlanEditSheetState extends ConsumerState<PlanEditSheet> {
  late DateTime _prepStartAt;
  String? _selectedPlaceId;

  List<Place>? _places;
  bool _placesLoading = true;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _prepStartAt = widget.plan.prepStartAt.toLocal();
    _loadPlaces();
  }

  Future<void> _loadPlaces() async {
    try {
      final repo = ref.read(ensomRepositoryProvider);
      final places = await repo.fetchPlaces();
      if (mounted) {
        setState(() {
          _places = places;
          _placesLoading = false;
        });
      }
    } catch (_) {
      // 장소를 못 불러와도 준비 시작 시각 수정은 가능해야 한다.
      if (mounted) {
        setState(() {
          _places = const [];
          _placesLoading = false;
        });
      }
    }
  }

  bool get _dirty {
    final prepChanged =
        !_prepStartAt.isAtSameMomentAs(widget.plan.prepStartAt.toLocal());
    final placeChanged = _selectedPlaceId != null;
    return prepChanged || placeChanged;
  }

  Future<void> _pickPrepTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _prepStartAt,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_prepStartAt),
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
    if (!_dirty || _saving) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final repo = ref.read(ensomRepositoryProvider);
      final prepChanged =
          !_prepStartAt.isAtSameMomentAs(widget.plan.prepStartAt.toLocal());
      await repo.updatePlan(
        widget.plan.planId,
        prepStartAt: prepChanged ? _prepStartAt : null,
        originPlaceId: _selectedPlaceId,
      );
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("계획을 수정했어요.")));
        Navigator.pop(context, true);
      }
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = e.message;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = "계획을 수정하지 못했어요.";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 12, 24, 24 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: EnsomColors.hairline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text("계획 수정", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          const Text(
            "수정하면 새 계획으로 다시 계산돼요.",
            style: TextStyle(color: EnsomColors.inkMuted, fontSize: 13),
          ),
          const SizedBox(height: 20),

          // 준비 시작 시각
          Text(
            "준비 시작 시각",
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.schedule),
              title: Text(_formatDateTime(_prepStartAt)),
              trailing: TextButton(
                onPressed: _saving ? null : _pickPrepTime,
                child: const Text("변경"),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 출발지
          Text("출발지", style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          _buildPlaces(),

          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(
              _error!,
              style: const TextStyle(color: EnsomColors.caution),
            ),
          ],
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: (_dirty && !_saving) ? _save : null,
              child: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text("저장"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaces() {
    if (_placesLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    final places = _places ?? const [];
    if (places.isEmpty) {
      return const Text(
        "등록된 장소가 없어요.",
        style: TextStyle(color: EnsomColors.inkMuted),
      );
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: places.map((p) {
        final selected = _selectedPlaceId == p.placeId;
        return ChoiceChip(
          label: Text(p.placeName),
          selected: selected,
          onSelected: _saving
              ? null
              : (_) => setState(
                  () => _selectedPlaceId = selected ? null : p.placeId,
                ),
        );
      }).toList(),
    );
  }

  String _formatDateTime(DateTime dt) {
    final local = dt.toLocal();
    final now = DateTime.now();
    final h = local.hour.toString().padLeft(2, "0");
    final m = local.minute.toString().padLeft(2, "0");
    if (local.year == now.year &&
        local.month == now.month &&
        local.day == now.day) {
      return "오늘 $h:$m";
    }
    return "${local.month}/${local.day} $h:$m";
  }
}
