import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geofencing_api/geofencing_api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../local/place_cache_entry.dart';
import '../../models/place.dart';
import '../../repository/providers.dart';
import '../../widgets/vium_button.dart';
import '../../widgets/vium_card.dart';

const _labelOptions = ['집', '회사', '헬스장', '직접 입력'];

class PlaceRegistrationScreen extends ConsumerStatefulWidget {
  const PlaceRegistrationScreen({super.key});

  @override
  ConsumerState<PlaceRegistrationScreen> createState() => _PlaceRegistrationScreenState();
}

class _PlaceRegistrationScreenState extends ConsumerState<PlaceRegistrationScreen> {
  String selectedLabel = _labelOptions.first;
  final customLabelController = TextEditingController();
  double radiusM = 300; // 스키마 기본값
  double? lat;
  double? lng;
  bool locating = false;
  bool saving = false;

  Box<PlaceCacheEntry> get _placeBox => Hive.box<PlaceCacheEntry>('place_cache');

  Future<void> _useCurrentLocation() async {
    setState(() => locating = true);
    try {
      final position = await Geolocator.getCurrentPosition();
      if (!mounted) return;
      setState(() {
        lat = position.latitude;
        lng = position.longitude;
      });
    } finally {
      if (mounted) setState(() => locating = false);
    }
  }

  Future<void> _register() async {
    if (lat == null || lng == null) return;
    final label = selectedLabel == '직접 입력' ? customLabelController.text.trim() : selectedLabel;
    if (label.isEmpty) return;

    setState(() => saving = true);

    final repo = ref.read(viumRepositoryProvider);
    final placeId = const Uuid().v4();
    final place = Place(
      id: placeId,
      label: label,
      lat: lat!,
      lng: lng!,
      radiusM: radiusM.round(),
    );

    // 1. 서버에 등록 (mock)
    await repo.registerPlace(place);
    if (!mounted) return;

    // 2. 로컬 캐시에 저장
    await _placeBox.put(
      placeId,
      PlaceCacheEntry(
        userId: 'current-user', // 실제 로그인 붙으면 provider에서 가져오도록 교체
        placeId: placeId,
        label: label,
        lat: lat!,
        lng: lng!,
        radiusM: radiusM.round(),
      ),
    );

    // 3. 지오펜스 등록
    Geofencing.instance.addRegion(
      GeofenceRegion.circular(
        id: placeId,
        data: {'label': label},
        center: LatLng(lat!, lng!),
        radius: radiusM,
      ),
    );

    if (!mounted) return;
    setState(() {
      saving = false;
      lat = null;
      lng = null;
      customLabelController.clear();
    });
  }

  Future<void> _remove(PlaceCacheEntry entry) async {
    final repo = ref.read(viumRepositoryProvider);
    await repo.deletePlace(entry.placeId);
    await _placeBox.delete(entry.placeId);
    Geofencing.instance.removeRegionById(entry.placeId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('등록 장소 관리')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          ViumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('새 장소 등록', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                DropdownButton<String>(
                  value: selectedLabel,
                  items: _labelOptions
                      .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                      .toList(),
                  onChanged: (v) => setState(() => selectedLabel = v!),
                ),
                if (selectedLabel == '직접 입력')
                  TextField(
                    controller: customLabelController,
                    decoration: const InputDecoration(labelText: '장소 이름'),
                  ),
                const SizedBox(height: 12),
                Text('반경: ${radiusM.round()}m'),
                Slider(
                  value: radiusM,
                  min: 100,
                  max: 2000, // DB 제약(100~2000)과 일치
                  divisions: 19,
                  label: '${radiusM.round()}m',
                  onChanged: (v) => setState(() => radiusM = v),
                ),
                const SizedBox(height: 12),
                if (lat != null && lng != null)
                  Text('선택된 위치: ${lat!.toStringAsFixed(4)}, ${lng!.toStringAsFixed(4)}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ViumButton(
                  label: locating ? '위치 확인 중...' : '현재 위치 사용',
                  isPrimary: false,
                  onPressed: locating ? null : _useCurrentLocation,
                ),
                const SizedBox(height: 8),
                ViumButton(
                  label: saving ? '등록 중...' : '등록하기',
                  onPressed: (lat == null || saving) ? null : _register,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('등록된 장소', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          ValueListenableBuilder<Box<PlaceCacheEntry>>(
            valueListenable: _placeBox.listenable(),
            builder: (context, box, _) {
              final entries = box.values.toList();
              if (entries.isEmpty) {
                return const Text('아직 등록된 장소가 없어요', style: TextStyle(color: Colors.grey));
              }
              return Column(
                children: entries
                    .map((e) => ListTile(
                          title: Text(e.label),
                          subtitle: Text('반경 ${e.radiusM}m'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => _remove(e),
                          ),
                        ))
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}