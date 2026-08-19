import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "../../models/event.dart";
import "../../providers/map_providers.dart";
import "../../repository/providers.dart";

/// CAL-05, MAP-04. 지도에서 목적지·경로를 고른 뒤 이 화면에서 일정명을
/// 입력하고 캘린더에 저장한다 (PRD §10.3 "지도에서 캘린더로 저장" 5~6단계).
class EventCreateFromMapScreen extends ConsumerStatefulWidget {
  const EventCreateFromMapScreen({super.key});

  @override
  ConsumerState<EventCreateFromMapScreen> createState() => _EventCreateFromMapScreenState();
}

class _EventCreateFromMapScreenState extends ConsumerState<EventCreateFromMapScreen> {
  final _labelController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }

  Future<void> _save(MapDraftEvent draft) async {
    final label = _labelController.text.trim();
    if (label.isEmpty) return;

    setState(() => _saving = true);
    try {
      final repo = ref.read(ensomRepositoryProvider);
      final endsAt = draft.at.add(const Duration(hours: 1));
      final event = Event(
        eventId: "",
        displayLabel: label,
        displayName: label,
        startsAt: draft.anchorMode == EventAnchor.departAt ? draft.at : draft.at.subtract(const Duration(hours: 1)),
        endsAt: draft.anchorMode == EventAnchor.arriveBy ? draft.at : endsAt,
        locationState: LocationState.requiredResolved,
        destinationName: draft.destName,
        destinationLat: draft.destLat,
        destinationLng: draft.destLng,
        anchor: draft.anchorMode,
        sourceType: EventSourceType.mapSearch,
      );

      await repo.createEvent(
        event,
        originPlaceId: draft.originPlaceId,
        selectedRouteOptionId: draft.selectedRoute.routeOptionId,
      );

      ref.read(mapDraftEventProvider.notifier).state = null;
      if (!mounted) return;
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
    final draft = ref.watch(mapDraftEventProvider);

    if (draft == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("일정 저장")),
        body: const Center(child: Text("선택한 경로 정보를 찾을 수 없어요.")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("캘린더에 저장")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(draft.destName, style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(
                    "${draft.selectedRoute.totalMinutes}분 · 도보 ${draft.selectedRoute.walkMinutes}분 · 환승 ${draft.selectedRoute.transferCount}회",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    draft.anchorMode == EventAnchor.arriveBy
                        ? "도착 ${draft.at.month}/${draft.at.day} ${draft.at.hour.toString().padLeft(2, '0')}:${draft.at.minute.toString().padLeft(2, '0')}"
                        : "출발 ${draft.at.month}/${draft.at.day} ${draft.at.hour.toString().padLeft(2, '0')}:${draft.at.minute.toString().padLeft(2, '0')}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _labelController,
            decoration: const InputDecoration(labelText: "일정명"),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _saving ? null : () => _save(draft),
            child: _saving ? const Text("저장 중...") : const Text("캘린더에 저장"),
          ),
        ],
      ),
    );
  }
}
