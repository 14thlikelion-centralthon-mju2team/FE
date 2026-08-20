import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "../../models/event.dart";
import "../../network/kakao_local_search_service.dart";
import "../../providers/map_providers.dart";
import "../../repository/providers.dart";
import "../../theme/ensom_colors.dart";
import "../../widgets/ensom/ensom_chip.dart";
import "../../widgets/ensom/ensom_date_picker_sheet.dart";
import "../../widgets/ensom/ensom_pill_button.dart";
import "../../widgets/ensom/ensom_text_field.dart";
import "../../widgets/ensom/ensom_time_picker_sheet.dart";
import "../../widgets/ensom/ensom_top_bar.dart";
import "../search/place_search_screen.dart";

/// S-10 일정 생성 폼.
/// 캘린더의 빈 폼과 S-08R에서 넘어온 지도 프리필을 하나의 화면으로 처리한다.
///
/// ensom_onboarding_flow.html STEP 5("첫 일정을 만들어 볼까요?")의
/// 필드/값행(vrow)/칩 시각 언어를 반영한다. 전용 목업 파일은 없어서
/// 온보딩 흐름 안의 같은 폼 패턴을 재사용했다.
class EventFormScreen extends ConsumerStatefulWidget {
  const EventFormScreen({super.key, this.fromMap = false});

  final bool fromMap;

  @override
  ConsumerState<EventFormScreen> createState() => _EventFormScreenState();
}

class _EventFormScreenState extends ConsumerState<EventFormScreen> {
  final _labelController = TextEditingController();
  DateTime _startsAt = DateTime.now().add(const Duration(hours: 1));
  LocationState _locationState = LocationState.undecided;
  String? _destinationName;
  double? _destinationLat;
  double? _destinationLng;
  MapDraftEvent? _mapDraft;
  bool _saving = false;

  void _applyMapDraft(MapDraftEvent draft) {
    if (identical(_mapDraft, draft)) return;
    _mapDraft = draft;
    _startsAt = draft.anchorMode == EventAnchor.departAt
        ? draft.at
        : draft.at.subtract(const Duration(hours: 1));
    _locationState = LocationState.requiredResolved;
    _destinationName = draft.destName;
    _destinationLat = draft.destLat;
    _destinationLng = draft.destLng;
  }

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }

  Future<void> _pickDestination() async {
    final result = await Navigator.push<KakaoSearchResult>(
      context,
      MaterialPageRoute(builder: (_) => const PlaceSearchScreen()),
    );
    if (result != null && mounted) {
      setState(() {
        _destinationName = result.name;
        _destinationLat = result.lat;
        _destinationLng = result.lng;
      });
    }
  }

  Future<void> _pickTime() async {
    final date = await EnsomDatePickerSheet.show(context, initial: _startsAt);
    if (date == null || !mounted) return;

    final time = await EnsomTimePickerSheet.show(
      context,
      initial: TimeOfDay.fromDateTime(_startsAt),
    );
    if (time == null) return;

    setState(() {
      _startsAt = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  Future<bool> _confirmClassificationIfNeeded() async {
    if (_locationState != LocationState.undecided) return true;

    final answer = await showModalBottomSheet<LocationState>(
      context: context,
      backgroundColor: EnsomColors.canvas,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "이 일정에 장소가 필요한가요?",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, letterSpacing: -.3, color: EnsomColors.ink),
              ),
              const SizedBox(height: 7),
              const Text(
                "한 번 답하면 같은 일정에 다시 묻지 않아요.",
                style: TextStyle(fontSize: 12.5, color: EnsomColors.inkMuted),
              ),
              const SizedBox(height: 20),
              EnsomPillButton(
                label: "네, 장소가 있어요",
                onPressed: () => Navigator.pop(sheetContext, LocationState.requiredMissing),
              ),
              const SizedBox(height: 8),
              EnsomPillButton(
                label: "아니요, 온라인·재택이에요",
                variant: EnsomPillVariant.secondary,
                onPressed: () => Navigator.pop(sheetContext, LocationState.notRequired),
              ),
              EnsomPillButton(
                label: "잘 모르겠어요",
                variant: EnsomPillVariant.text,
                onPressed: () => Navigator.pop(sheetContext, LocationState.undecided),
              ),
            ],
          ),
        ),
      ),
    );

    if (answer == null) return false;
    setState(() => _locationState = answer);

    if (answer == LocationState.requiredMissing) {
      await _pickDestination();
      return _destinationName != null;
    }

    // `잘 모르겠어요`는 undecided를 그대로 전송해 미해결 상태를 보존한다.
    return true;
  }

  Future<void> _save() async {
    final label = _labelController.text.trim();
    if (label.isEmpty || _saving) return;

    if (!await _confirmClassificationIfNeeded()) return;
    if (_locationState == LocationState.requiredMissing && _destinationName == null) {
      await _pickDestination();
      if (_destinationName == null) return;
    }

    final draft = _mapDraft;
    if (draft != null && draft.isExpiredAt(DateTime.now())) {
      await ref.read(mapDraftEventProvider.notifier).clear();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("선택한 경로가 만료됐어요. 경로를 다시 검색해주세요.")),
      );
      context.go(
        Uri(
          path: "/map",
          queryParameters: {
            "destName": draft.destName,
            "destLat": draft.destLat.toString(),
            "destLng": draft.destLng.toString(),
          },
        ).toString(),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      final endsAt = draft?.anchorMode == EventAnchor.arriveBy ? draft!.at : _startsAt.add(const Duration(hours: 1));
      final event = Event(
        eventId: "",
        displayLabel: label,
        displayName: label,
        startsAt: _startsAt,
        endsAt: endsAt,
        locationState: _locationState == LocationState.requiredMissing && _destinationName != null
            ? LocationState.requiredResolved
            : _locationState,
        destinationName: _destinationName,
        destinationLat: _destinationLat,
        destinationLng: _destinationLng,
        anchor: draft?.anchorMode ?? EventAnchor.arriveBy,
        sourceType: draft == null ? EventSourceType.internal : EventSourceType.mapSearch,
      );

      final created = await ref.read(ensomRepositoryProvider).createEvent(
            event,
            originPlaceId: draft?.originPlaceId,
            selectedRouteOptionId: draft?.selectedRoute.routeOptionId,
          );

      if (draft != null) {
        await ref.read(mapDraftEventProvider.notifier).clear();
      }
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("일정을 저장했어요."), duration: Duration(seconds: 2)),
      );
      context.pushReplacement("/events/${created.eventId}");
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("일정을 저장하지 못했어요. 다시 시도해주세요.")),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Widget _buildMapPrefill(MapDraftEvent draft) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: EnsomColors.lime, borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            draft.destName,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: -.3, color: EnsomColors.ink),
          ),
          const SizedBox(height: 5),
          Text(
            "${draft.selectedRoute.totalMinutes}분 · 도보 ${draft.selectedRoute.walkMinutes}분 · 환승 ${draft.selectedRoute.transferCount}회",
            style: TextStyle(fontSize: 12, color: EnsomColors.ink.withValues(alpha: .72)),
          ),
          const SizedBox(height: 3),
          Text(
            draft.anchorMode == EventAnchor.arriveBy
                ? "도착 ${_formatDateTime(draft.at)}"
                : "출발 ${_formatDateTime(draft.at)}",
            style: TextStyle(fontSize: 12, color: EnsomColors.ink.withValues(alpha: .72)),
          ),
          const SizedBox(height: 9),
          Text(
            "지도에서 선택한 장소·시각·경로가 적용됐어요.",
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: EnsomColors.limeInk),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime value) {
    return "${value.month}/${value.day} ${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    if (widget.fromMap) {
      final draftState = ref.watch(mapDraftEventProvider);
      if (draftState.isLoading) {
        return const _LoadingScaffold();
      }
      if (draftState.hasValue && draftState.value != null) {
        _applyMapDraft(draftState.value!);
      }
    }

    final draft = _mapDraft;
    if (widget.fromMap && draft != null && draft.isExpiredAt(DateTime.now())) {
      return Scaffold(
        backgroundColor: EnsomColors.canvas,
        appBar: const EnsomTopBar(title: "일정 만들기"),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(26),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "선택한 경로가 만료됐어요.",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, letterSpacing: -.3, color: EnsomColors.ink),
                ),
                const SizedBox(height: 8),
                Text(
                  "${draft.destName} 경로를 다시 검색해주세요.",
                  style: const TextStyle(fontSize: 12.5, color: EnsomColors.inkMuted),
                ),
                const SizedBox(height: 20),
                EnsomPillButton(
                  label: "경로 다시 검색",
                  expand: false,
                  onPressed: () async {
                    await ref.read(mapDraftEventProvider.notifier).clear();
                    if (!context.mounted) return;
                    context.go(
                      Uri(
                        path: "/map",
                        queryParameters: {
                          "destName": draft.destName,
                          "destLat": draft.destLat.toString(),
                          "destLng": draft.destLng.toString(),
                        },
                      ).toString(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }
    if (widget.fromMap && draft == null) {
      return const Scaffold(
        backgroundColor: EnsomColors.canvas,
        appBar: EnsomTopBar(title: "일정 만들기"),
        body: Center(
          child: Text("선택한 경로 정보를 찾을 수 없어요.", style: TextStyle(color: EnsomColors.inkMuted)),
        ),
      );
    }

    final canSave = !_saving && _labelController.text.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: EnsomColors.canvas,
      appBar: const EnsomTopBar(title: "일정 만들기"),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 16),
                children: [
                  if (draft != null) ...[
                    _buildMapPrefill(draft),
                    const SizedBox(height: 18),
                  ],
                  EnsomTextField(
                    label: "일정 이름",
                    controller: _labelController,
                    onChanged: (_) => setState(() {}),
                  ),
                  if (draft == null) ...[
                    const SizedBox(height: 16),
                    const Text(
                      "시작 시각",
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: EnsomColors.inkMuted),
                    ),
                    const SizedBox(height: 6),
                    _ValueRow(value: _formatDateTime(_startsAt), onTap: _pickTime),
                    const SizedBox(height: 16),
                    const Text(
                      "장소",
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: EnsomColors.inkMuted),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 7,
                      runSpacing: 8,
                      children: [
                        EnsomChip(
                          label: "장소 필요",
                          selected: _locationState == LocationState.requiredMissing,
                          onTap: () => setState(() {
                            _locationState = LocationState.requiredMissing;
                          }),
                        ),
                        EnsomChip(
                          label: "장소 불필요",
                          selected: _locationState == LocationState.notRequired,
                          onTap: () => setState(() {
                            _locationState = LocationState.notRequired;
                            _destinationName = null;
                            _destinationLat = null;
                            _destinationLng = null;
                          }),
                        ),
                        EnsomChip(
                          label: "미정",
                          selected: _locationState == LocationState.undecided,
                          onTap: () => setState(() {
                            _locationState = LocationState.undecided;
                            _destinationName = null;
                            _destinationLat = null;
                            _destinationLng = null;
                          }),
                        ),
                      ],
                    ),
                    if (_locationState == LocationState.requiredMissing) ...[
                      const SizedBox(height: 10),
                      _ValueRow(
                        value: _destinationName ?? "목적지 검색",
                        hint: _destinationName == null,
                        leading: Icons.place_outlined,
                        trailing: Icons.search,
                        onTap: _pickDestination,
                      ),
                    ],
                  ],
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
              decoration: const BoxDecoration(
                color: EnsomColors.surface1,
                border: Border(top: BorderSide(color: EnsomColors.hairline)),
              ),
              child: EnsomPillButton(
                label: _saving ? "저장 중..." : "저장",
                onPressed: canSave ? _save : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingScaffold extends StatelessWidget {
  const _LoadingScaffold();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: EnsomColors.canvas,
      appBar: EnsomTopBar(title: "일정 만들기"),
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

/// 목업 `.vrow` — hairline 테두리(1.4px), radius 12의 값 표시 행.
class _ValueRow extends StatelessWidget {
  const _ValueRow({
    required this.value,
    required this.onTap,
    this.hint = false,
    this.leading,
    this.trailing = Icons.chevron_right,
  });

  final String value;
  final bool hint;
  final VoidCallback onTap;
  final IconData? leading;
  final IconData trailing;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 13),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: EnsomColors.hairline, width: 1.4),
        ),
        child: Row(
          children: [
            if (leading != null) ...[
              Icon(leading, size: 16, color: EnsomColors.inkFaint),
              const SizedBox(width: 9),
            ],
            Expanded(
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: hint ? FontWeight.w500 : FontWeight.w600,
                  color: hint ? EnsomColors.inkFaint : EnsomColors.ink,
                ),
              ),
            ),
            Icon(trailing, size: 16, color: EnsomColors.inkFaint),
          ],
        ),
      ),
    );
  }
}
