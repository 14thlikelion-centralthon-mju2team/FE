import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:geolocator/geolocator.dart";
import "package:go_router/go_router.dart";
import "package:kakao_map_sdk/kakao_map_sdk.dart";
import "../../models/event.dart";
import "../../models/plan.dart";
import "../../network/kakao_local_search_service.dart";
import "../../providers/map_providers.dart";
import "../../repository/providers.dart";

/// MAP-01~04, CAL-05. 기본 지도 화면 -- 현재 위치 표시, 목적지 검색,
/// 경로 후보 조회, 캘린더 저장(일정 생성)까지가 이 화면의 범위다
/// (PRD §21.2 "지도는 기본 경로 기능만" -- 환경 레이어 등은 넣지 않는다).
class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  KakaoMapController? _controller;
  bool _locating = false;
  String? _error;

  // 위치 권한 거부/실패 시 기본 위치 (서울시청). 지도 자체는 여전히
  // 정상 동작해야 한다 (PRD §23.2 "일부 실패해도 앱 중단 없음").
  static const _fallbackPosition = LatLng(37.5665, 126.9780);

  Position? _currentPosition;
  String? _destName;
  double? _destLat;
  double? _destLng;
  bool _searching = false;
  bool _routing = false;

  Future<void> _moveToCurrentLocation() async {
    setState(() {
      _locating = true;
      _error = null;
    });
    try {
      final position = await Geolocator.getCurrentPosition();
      _currentPosition = position;
      final location = LatLng(position.latitude, position.longitude);
      await _controller?.moveCamera(
        CameraUpdate.newCenterPosition(location),
        animation: const CameraAnimation(500),
      );
    } catch (e) {
      setState(() => _error = "현재 위치를 가져오지 못했어요. 위치 권한을 확인해주세요.");
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  Future<void> _onMapTapped(LatLng position) async {
    final search = ref.read(kakaoLocalSearchServiceProvider);
    if (search.isAvailable) return; // 검색 가능하면 탭-선택은 보조 수단일 뿐
    setState(() {
      _destName = "선택한 위치";
      _destLat = position.latitude;
      _destLng = position.longitude;
    });
  }

  Future<void> _openSearchSheet() async {
    final search = ref.read(kakaoLocalSearchServiceProvider);
    if (!search.isAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("검색을 쓸 수 없어요. 지도를 눌러 목적지를 선택해주세요.")),
      );
      return;
    }

    final controller = TextEditingController();
    List<KakaoSearchResult> results = const [];

    final selected = await showModalBottomSheet<KakaoSearchResult>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            Future<void> runSearch(String query) async {
              setSheetState(() => _searching = true);
              final found = await search.search(query);
              results = found;
              setSheetState(() => _searching = false);
            }

            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: "목적지를 검색하세요",
                      prefixIcon: Icon(Icons.search),
                    ),
                    onSubmitted: runSearch,
                  ),
                  const SizedBox(height: 12),
                  if (_searching) const CircularProgressIndicator(),
                  if (!_searching)
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: results.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final r = results[index];
                          return ListTile(
                            title: Text(r.name),
                            subtitle: Text(r.addressName),
                            onTap: () => Navigator.of(sheetContext).pop(r),
                          );
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );

    if (selected == null) return;
    setState(() {
      _destName = selected.name;
      _destLat = selected.lat;
      _destLng = selected.lng;
    });
    await _controller?.moveCamera(
      CameraUpdate.newCenterPosition(LatLng(selected.lat, selected.lng)),
      animation: const CameraAnimation(500),
    );
  }

  Future<void> _searchRoutes() async {
    if (_destLat == null || _destLng == null || _destName == null) return;

    var origin = _currentPosition;
    if (origin == null) {
      try {
        origin = await Geolocator.getCurrentPosition();
      } catch (_) {
        // origin은 null로 유지 -- 아래에서 안내하고 중단한다.
      }
    }
    if (origin == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("출발 위치를 확인하지 못했어요. 위치 권한을 확인해주세요.")),
      );
      return;
    }

    final anchor = await _pickAnchor();
    if (anchor == null) return;

    setState(() => _routing = true);
    try {
      final repo = ref.read(ensomRepositoryProvider);
      final routes = await repo.fetchRouteSearch(
        originLat: origin.latitude,
        originLng: origin.longitude,
        destLat: _destLat!,
        destLng: _destLng!,
        destName: _destName!,
        anchorMode: anchor.$1,
        at: anchor.$2,
      );
      if (!mounted) return;

      // 빈 결과 처리 — BE에 /routes/search가 없거나 경로를 찾지 못한 경우
      if (routes.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("경로 검색을 사용할 수 없어요. 서버 준비 후 다시 시도해주세요.")),
        );
        return;
      }

      final selectedRoute = await _showRouteSheet(routes);
      if (selectedRoute == null) return;

      ref.read(mapDraftEventProvider.notifier).state = MapDraftEvent(
        originLat: origin.latitude,
        originLng: origin.longitude,
        destName: _destName!,
        destLat: _destLat!,
        destLng: _destLng!,
        selectedRoute: selectedRoute,
        anchorMode: anchor.$1,
        at: anchor.$2,
      );
      if (!mounted) return;
      context.push("/events/create-from-map");
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("경로를 찾지 못했어요. 다시 시도해주세요.")),
      );
    } finally {
      if (mounted) setState(() => _routing = false);
    }
  }

  Future<(EventAnchor, DateTime)?> _pickAnchor() async {
    var anchorMode = EventAnchor.arriveBy;
    var at = DateTime.now().add(const Duration(hours: 1));

    return showModalBottomSheet<(EventAnchor, DateTime)>(
      context: context,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SegmentedButton<EventAnchor>(
                    segments: const [
                      ButtonSegment(value: EventAnchor.arriveBy, label: Text("도착 시각 기준")),
                      ButtonSegment(value: EventAnchor.departAt, label: Text("출발 시각 기준")),
                    ],
                    selected: {anchorMode},
                    onSelectionChanged: (s) => setSheetState(() => anchorMode = s.first),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    title: const Text("시각"),
                    subtitle: Text(
                      "${at.month}/${at.day} ${at.hour.toString().padLeft(2, '0')}:${at.minute.toString().padLeft(2, '0')}",
                    ),
                    trailing: const Icon(Icons.edit_calendar),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: sheetContext,
                        initialDate: at,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date == null) return;
                      if (!sheetContext.mounted) return;
                      final time = await showTimePicker(
                        context: sheetContext,
                        initialTime: TimeOfDay.fromDateTime(at),
                      );
                      if (time == null) return;
                      setSheetState(() {
                        at = DateTime(date.year, date.month, date.day, time.hour, time.minute);
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => Navigator.of(sheetContext).pop((anchorMode, at)),
                    child: const Text("경로 검색"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
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

  Future<RouteOption?> _showRouteSheet(List<RouteOption> routes) {
    return showModalBottomSheet<RouteOption>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => SafeArea(
        child: ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.all(16),
          itemCount: routes.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final route = routes[index];
            return Card(
              child: ListTile(
                title: Text(_rankLabel(route.routeType)),
                subtitle: Text(
                  "${route.totalMinutes}분 · 도보 ${route.walkMinutes}분 · 환승 ${route.transferCount}회",
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(sheetContext).pop(route),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final search = ref.watch(kakaoLocalSearchServiceProvider);
    final destSelected = _destLat != null && _destLng != null;

    return Scaffold(
      body: Stack(
        children: [
          KakaoMap(
            option: const KakaoMapOption(
              position: _fallbackPosition,
              zoomLevel: 16,
              mapType: MapType.normal,
            ),
            onMapReady: (controller) {
              _controller = controller;
              _moveToCurrentLocation();
            },
            onMapClick: (point, position) => _onMapTapped(position),
          ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: _openSearchSheet,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _destName ?? (search.isAvailable ? "목적지를 검색하세요" : "지도를 눌러 목적지를 선택해주세요"),
                          style: TextStyle(color: _destName != null ? Colors.black : Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_error != null)
            Positioned(
              top: 76,
              left: 16,
              right: 16,
              child: Material(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    _error!,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
              ),
            ),
          if (destSelected)
            Positioned(
              left: 16,
              right: 16,
              bottom: 24,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(_destName!, overflow: TextOverflow.ellipsis),
                      ),
                      FilledButton(
                        onPressed: _routing ? null : _searchRoutes,
                        child: _routing
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text("경로 검색"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Positioned(
            right: 16,
            bottom: destSelected ? 96 : 24,
            child: FloatingActionButton(
              onPressed: _locating ? null : _moveToCurrentLocation,
              child: _locating
                  ? const SizedBox(
                      width: 20, height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }
}
