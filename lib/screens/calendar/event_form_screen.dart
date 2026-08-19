import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "../../models/event.dart";
import "../../network/kakao_local_search_service.dart";
import "../../repository/providers.dart";
import "../search/place_search_screen.dart";

/// CAL-01. 내부 일정(sourceType=internal) 생성 폼 — 캘린더 탭 FAB에서 진입.
/// 지도 검색 결과 저장 흐름(CAL-05)은 event_create_from_map_screen.dart가 담당한다.
class EventFormScreen extends ConsumerStatefulWidget {
  const EventFormScreen({super.key});

  @override
  ConsumerState<EventFormScreen> createState() => _EventFormScreenState();
}

class _EventFormScreenState extends ConsumerState<EventFormScreen> {
  final _labelController = TextEditingController();
  DateTime _startsAt = DateTime.now().add(const Duration(hours: 1));
  LocationState _locationState = LocationState.notRequired;
  String? _destinationName;
  double? _destinationLat;
  double? _destinationLng;
  bool _saving = false;

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
    if (date == null) return;
    if (!mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_startsAt),
    );
    if (time == null) return;
    setState(() {
      _startsAt = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  Future<void> _save() async {
    final label = _labelController.text.trim();
    if (label.isEmpty) return;

    setState(() => _saving = true);
    try {
      final event = Event(
        eventId: "",
        displayLabel: label,
        displayName: label,
        startsAt: _startsAt,
        endsAt: _startsAt.add(const Duration(hours: 1)),
        locationState: _locationState == LocationState.requiredMissing && _destinationName != null
            ? LocationState.requiredResolved
            : _locationState,
        destinationName: _destinationName,
        destinationLat: _destinationLat,
        destinationLng: _destinationLng,
        anchor: EventAnchor.arriveBy,
        sourceType: EventSourceType.internal,
      );
      await ref.read(ensomRepositoryProvider).createEvent(event);
      if (!mounted) return;
      // 저장 성공 → 일정 상세(DTL-01)로 이동
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("일정을 저장했어요."), duration: Duration(seconds: 2)),
      );
      context.go("/home");
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("일정을 저장하지 못했어요. 다시 시도해주세요.")),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("일정 만들기")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _labelController,
            decoration: const InputDecoration(labelText: "일정명"),
          ),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text("시각"),
            subtitle: Text(
              "${_startsAt.month}/${_startsAt.day} ${_startsAt.hour.toString().padLeft(2, '0')}:${_startsAt.minute.toString().padLeft(2, '0')}",
            ),
            trailing: const Icon(Icons.edit_calendar),
            onTap: _pickTime,
          ),
          const SizedBox(height: 8),
          // CAL-03: 장소 필요 여부는 사용자 지정이 항상 자동 분류보다 우선한다.
          SegmentedButton<LocationState>(
            segments: const [
              ButtonSegment(value: LocationState.notRequired, label: Text("장소 불필요")),
              ButtonSegment(value: LocationState.requiredMissing, label: Text("장소 필요")),
            ],
            selected: {_locationState},
            onSelectionChanged: (s) => setState(() => _locationState = s.first),
          ),
          if (_locationState == LocationState.requiredMissing) ...[
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.place_outlined),
              title: Text(_destinationName ?? "목적지 검색"),
              subtitle: _destinationName != null
                  ? null
                  : const Text("탭해서 장소를 선택하세요"),
              trailing: const Icon(Icons.search),
              onTap: _pickDestination,
            ),
          ],
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: _saving ? const Text("저장 중...") : const Text("저장"),
          ),
        ],
      ),
    );
  }
}
