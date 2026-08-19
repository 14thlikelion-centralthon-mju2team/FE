import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "../../models/event.dart";
import "../../network/kakao_local_search_service.dart";
import "../../providers/map_providers.dart";
import "../../repository/providers.dart";
import "../../theme/ensom_colors.dart";
import "../search/place_search_screen.dart";

/// S-10 일정 생성 폼.
/// 캘린더의 빈 폼과 S-08R에서 넘어온 지도 프리필을 하나의 화면으로 처리한다.
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

  @override
  void initState() {
    super.initState();
    if (!widget.fromMap) return;

    _mapDraft = ref.read(mapDraftEventProvider);
    final draft = _mapDraft;
    if (draft == null) return;

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
    final date = await showDatePicker(
      context: context,
      initialDate: _startsAt,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_startsAt),
    );
    if (time == null) return;

    setState(() {
      _startsAt = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<bool> _confirmClassificationIfNeeded() async {
    if (_locationState != LocationState.undecided) return true;

    final answer = await showModalBottomSheet<LocationState>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "이 일정에 장소가 필요한가요?",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              const Text(
                "한 번 답하면 같은 일정에 다시 묻지 않아요.",
                style: TextStyle(color: EnsomColors.inkMuted),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () =>
                    Navigator.pop(sheetContext, LocationState.requiredMissing),
                child: const Text("네, 장소가 있어요"),
              ),
              OutlinedButton(
                onPressed: () =>
                    Navigator.pop(sheetContext, LocationState.notRequired),
                child: const Text("아니요, 온라인·재택이에요"),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.pop(sheetContext, LocationState.undecided),
                child: const Text("잘 모르겠어요"),
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
    if (_locationState == LocationState.requiredMissing &&
        _destinationName == null) {
      await _pickDestination();
      if (_destinationName == null) return;
    }

    setState(() => _saving = true);
    try {
      final draft = _mapDraft;
      final endsAt = draft?.anchorMode == EventAnchor.arriveBy
          ? draft!.at
          : _startsAt.add(const Duration(hours: 1));
      final event = Event(
        eventId: "",
        displayLabel: label,
        displayName: label,
        startsAt: _startsAt,
        endsAt: endsAt,
        locationState:
            _locationState == LocationState.requiredMissing &&
                _destinationName != null
            ? LocationState.requiredResolved
            : _locationState,
        destinationName: _destinationName,
        destinationLat: _destinationLat,
        destinationLng: _destinationLng,
        anchor: draft?.anchorMode ?? EventAnchor.arriveBy,
        sourceType: draft == null
            ? EventSourceType.internal
            : EventSourceType.mapSearch,
      );

      final created = await ref
          .read(ensomRepositoryProvider)
          .createEvent(
            event,
            originPlaceId: draft?.originPlaceId,
            selectedRouteOptionId: draft?.selectedRoute.routeOptionId,
          );

      if (draft != null) {
        ref.read(mapDraftEventProvider.notifier).state = null;
      }
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("일정을 저장했어요."),
          duration: Duration(seconds: 2),
        ),
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              draft.destName,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              "${draft.selectedRoute.totalMinutes}분 · 도보 ${draft.selectedRoute.walkMinutes}분 · 환승 ${draft.selectedRoute.transferCount}회",
              style: const TextStyle(color: EnsomColors.inkMuted),
            ),
            const SizedBox(height: 4),
            Text(
              draft.anchorMode == EventAnchor.arriveBy
                  ? "도착 ${_formatDateTime(draft.at)}"
                  : "출발 ${_formatDateTime(draft.at)}",
              style: const TextStyle(color: EnsomColors.inkMuted),
            ),
            const SizedBox(height: 8),
            const Text(
              "지도에서 선택한 장소·시각·경로가 적용됐어요.",
              style: TextStyle(fontSize: 12, color: EnsomColors.limeInk),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime value) {
    return "${value.month}/${value.day} ${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final draft = _mapDraft;
    if (widget.fromMap && draft == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("일정 만들기")),
        body: const Center(child: Text("선택한 경로 정보를 찾을 수 없어요.")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("일정 만들기")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (draft != null) ...[
            _buildMapPrefill(draft),
            const SizedBox(height: 16),
          ],
          TextField(
            controller: _labelController,
            decoration: const InputDecoration(labelText: "일정명"),
            onChanged: (_) => setState(() {}),
          ),
          if (draft == null) ...[
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text("시각"),
              subtitle: Text(_formatDateTime(_startsAt)),
              trailing: const Icon(Icons.edit_calendar),
              onTap: _pickTime,
            ),
            const SizedBox(height: 8),
            SegmentedButton<LocationState>(
              segments: const [
                ButtonSegment(
                  value: LocationState.requiredMissing,
                  label: Text("장소 필요"),
                ),
                ButtonSegment(
                  value: LocationState.notRequired,
                  label: Text("장소 불필요"),
                ),
                ButtonSegment(
                  value: LocationState.undecided,
                  label: Text("미정"),
                ),
              ],
              selected: {_locationState},
              onSelectionChanged: (selection) {
                setState(() {
                  _locationState = selection.first;
                  if (_locationState != LocationState.requiredMissing) {
                    _destinationName = null;
                    _destinationLat = null;
                    _destinationLng = null;
                  }
                });
              },
            ),
            if (_locationState == LocationState.requiredMissing) ...[
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.place_outlined),
                title: Text(_destinationName ?? "목적지 검색"),
                subtitle: _destinationName == null
                    ? const Text("탭해서 장소를 선택하세요")
                    : null,
                trailing: const Icon(Icons.search),
                onTap: _pickDestination,
              ),
            ],
          ],
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _saving || _labelController.text.trim().isEmpty
                ? null
                : _save,
            child: Text(_saving ? "저장 중..." : "저장"),
          ),
        ],
      ),
    );
  }
}
