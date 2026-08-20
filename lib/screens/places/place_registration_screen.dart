import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:geolocator/geolocator.dart";
import "package:go_router/go_router.dart";
import "package:hive_ce_flutter/hive_ce_flutter.dart";
import "package:uuid/uuid.dart";
import "../../local/place_cache_entry.dart";
import "../../models/place.dart";
import "../../providers/auth_providers.dart";
import "../../repository/providers.dart";
import "../../theme/ensom_colors.dart";
import "../../widgets/ensom/ensom_chip.dart";
import "../../widgets/ensom/ensom_pill_button.dart";

const _labelOptions = ["집", "학교", "회사", "직접 입력"];

/// 라벨 → USER_PLACE.place_type 매핑. 스키마에 school 값이 없어
/// "학교"/"직접 입력"은 other로 잠정 처리한다(Place 모델 주석 참조).
String _placeTypeForLabel(String label) {
  switch (label) {
    case "집":
      return "home";
    case "회사":
      return "work";
    default:
      return "other";
  }
}

class PlaceRegistrationScreen extends ConsumerStatefulWidget {
  const PlaceRegistrationScreen({super.key, this.isOnboarding = false});

  /// 온보딩 흐름에서 호출되면 true — "완료/나중에" 버튼이 표시되고
  /// 완료 시 캘린더 연동 프라이밍으로 이동한다.
  final bool isOnboarding;

  @override
  ConsumerState<PlaceRegistrationScreen> createState() =>
      _PlaceRegistrationScreenState();
}

class _PlaceRegistrationScreenState
    extends ConsumerState<PlaceRegistrationScreen> {
  String selectedLabel = _labelOptions.first;
  final customLabelController = TextEditingController();
  double? lat;
  double? lng;
  bool locating = false;
  bool saving = false;

  @override
  void dispose() {
    customLabelController.dispose();
    super.dispose();
  }

  Box<PlaceCacheEntry> get _placeBox =>
      Hive.box<PlaceCacheEntry>("place_cache");

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _useCurrentLocation() async {
    setState(() => locating = true);
    try {
      final position = await Geolocator.getCurrentPosition();
      if (!mounted) return;
      setState(() {
        lat = position.latitude;
        lng = position.longitude;
      });
    } catch (e) {
      // geofencing_api와 geolocator가 권한을 공유하지 않는 경우(또는
      // 그 자체가 권한이 미수락된 경우) 대비
      _showError("현재 위치를 가져오지 못했어요. 위치 권한을 확인해주세요.");
    } finally {
      if (mounted) setState(() => locating = false);
    }
  }

  Future<void> _register() async {
    if (lat == null || lng == null) return;
    final label = selectedLabel == "직접 입력"
        ? customLabelController.text.trim()
        : selectedLabel;
    if (label.isEmpty) return;

    setState(() => saving = true);

    try {
      final repo = ref.read(ensomRepositoryProvider);
      final placeId = const Uuid().v4();
      final placeType = _placeTypeForLabel(label);
      final place = Place(
        placeId: placeId,
        placeType: placeType,
        placeName: label,
        lat: lat!,
        lng: lng!,
      );

      // 1. 서버에 등록 (mock)
      await repo.registerPlace(place);

      // 2. 로컬 캐시에 저장
      await _placeBox.put(
        placeId,
        PlaceCacheEntry(
          userId: "current-user", // 실제 로그인 붙으면 provider에서 가져오도록 교체
          placeId: placeId,
          placeName: label,
          placeType: placeType,
          lat: lat!,
          lng: lng!,
        ),
      );

      // 지오펜스는 여기서 등록하지 않는다. TR-08("활성 계획 1건·리전
      // 2개")에 따라 GeofenceManager(lib/services/geofence_manager.dart)가
      // 활성 계획의 출발지·목적지에 대해서만 등록하는 유일한 주체다.
      // 여기서 등록한 장소는 "자주 가는 장소" 목록(USER_PLACE)일 뿐이다.

      if (!mounted) return;
      setState(() {
        lat = null;
        lng = null;
        customLabelController.clear();
      });
    } catch (e) {
      _showError("장소 등록에 실패했어요. 다시 시도해주세요.");
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  Future<void> _remove(PlaceCacheEntry entry) async {
    try {
      final repo = ref.read(ensomRepositoryProvider);
      await repo.deletePlace(entry.placeId);
      await _placeBox.delete(entry.placeId);
      if (mounted) setState(() {});
    } catch (e) {
      _showError("장소 삭제에 실패했어요. 다시 시도해주세요.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EnsomColors.canvas,
      appBar: AppBar(
        backgroundColor: EnsomColors.canvas,
        surfaceTintColor: EnsomColors.canvas,
        elevation: 0,
        title: Text(
          widget.isOnboarding ? "주요 장소 설정" : "등록 장소 관리",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: EnsomColors.ink),
        ),
        actions: [
          if (widget.isOnboarding)
            TextButton(
              onPressed: () async {
                await ref
                    .read(secureStorageProvider)
                    .setOnboardingStep("notification");
                if (context.mounted) {
                  context.go("/onboarding/priming/notification");
                }
              },
              child: const Text("완료", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: EnsomColors.surface1,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: EnsomColors.hairline),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "새 장소 등록",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: -.2, color: EnsomColors.ink),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 7,
                  runSpacing: 8,
                  children: [
                    for (final label in _labelOptions)
                      EnsomChip(
                        label: label,
                        selected: selectedLabel == label,
                        onTap: () => setState(() => selectedLabel = label),
                      ),
                  ],
                ),
                if (selectedLabel == "직접 입력") ...[
                  const SizedBox(height: 12),
                  Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    decoration: BoxDecoration(
                      color: EnsomColors.surface1,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: EnsomColors.hairline, width: 1.4),
                    ),
                    child: TextField(
                      controller: customLabelController,
                      style: const TextStyle(fontSize: 13, color: EnsomColors.ink),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "장소 이름",
                        isCollapsed: true,
                        hintStyle: TextStyle(color: EnsomColors.inkFaint),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                if (lat != null && lng != null) ...[
                  Text(
                    "선택된 위치: ${lat!.toStringAsFixed(4)}, ${lng!.toStringAsFixed(4)}",
                    style: const TextStyle(fontSize: 11, color: EnsomColors.inkFaint),
                  ),
                  const SizedBox(height: 10),
                ],
                EnsomPillButton(
                  label: locating ? "위치 확인 중..." : "현재 위치 사용",
                  variant: EnsomPillVariant.secondary,
                  onPressed: locating ? null : _useCurrentLocation,
                ),
                const SizedBox(height: 8),
                EnsomPillButton(
                  label: saving ? "등록 중..." : "등록하기",
                  onPressed: (lat == null || saving) ? null : _register,
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          const Text(
            "등록된 장소",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: -.2, color: EnsomColors.ink),
          ),
          const SizedBox(height: 10),
          ValueListenableBuilder<Box<PlaceCacheEntry>>(
            valueListenable: _placeBox.listenable(),
            builder: (context, box, _) {
              final entries = box.values.toList();
              if (entries.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    "아직 등록된 장소가 없어요.",
                    style: TextStyle(fontSize: 12.5, color: EnsomColors.inkFaint),
                  ),
                );
              }
              return Column(
                children: entries.map((e) => _PlaceRow(entry: e, onDelete: () => _remove(e))).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PlaceRow extends StatelessWidget {
  const _PlaceRow({required this.entry, required this.onDelete});

  final PlaceCacheEntry entry;
  final VoidCallback onDelete;

  String _placeTypeLabel(String placeType) {
    switch (placeType) {
      case "home":
        return "집";
      case "work":
        return "직장";
      default:
        return "기타";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: EnsomColors.surface1,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: EnsomColors.hairline),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(color: EnsomColors.surface2, shape: BoxShape.circle),
            child: const Icon(Icons.place_outlined, size: 16, color: EnsomColors.inkMuted),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.placeName,
                  style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, letterSpacing: -.2, color: EnsomColors.ink),
                ),
                const SizedBox(height: 2),
                Text(
                  _placeTypeLabel(entry.placeType),
                  style: const TextStyle(fontSize: 11, color: EnsomColors.inkFaint),
                ),
              ],
            ),
          ),
          Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: onDelete,
              customBorder: const CircleBorder(),
              child: const SizedBox(
                width: 30,
                height: 30,
                child: Icon(Icons.delete_outline, size: 18, color: EnsomColors.inkFaint),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
