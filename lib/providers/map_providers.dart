import "dart:convert";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_riverpod/legacy.dart";
import "package:hive_ce_flutter/hive_ce_flutter.dart";
import "../core/app_config.dart";
import "../models/event.dart";
import "../models/plan.dart";
import "../network/kakao_local_search_service.dart";

final kakaoLocalSearchServiceProvider = Provider<KakaoLocalSearchService>((
  ref,
) {
  return KakaoLocalSearchService(restApiKey: kKakaoRestApiKey);
});

/// 지도 화면에서 만든 "저장 대기" 일정 초안. 목적지·경로가 정해지면
/// EventFormScreen의 지도 프리필 모드로 넘어가기 전에 여기 담아 둔다.
/// 화면 두 개를 오가는 흐름이라 URL 쿼리보다 provider로 넘기는 편이
/// 기존 컨벤션(planControllerProvider 등)과 더 맞는다.
class MapDraftEvent {
  const MapDraftEvent({
    this.originLat,
    this.originLng,
    this.originPlaceId,
    required this.destName,
    required this.destLat,
    required this.destLng,
    required this.selectedRoute,
    required this.anchorMode,
    required this.at,
  });

  final double? originLat;
  final double? originLng;
  final String? originPlaceId;
  final String destName;
  final double destLat;
  final double destLng;
  final RouteOption selectedRoute;
  final EventAnchor anchorMode;
  final DateTime at;

  Map<String, dynamic> toJson() => {
        "originLat": originLat,
        "originLng": originLng,
        "originPlaceId": originPlaceId,
        "destName": destName,
        "destLat": destLat,
        "destLng": destLng,
        "selectedRoute": selectedRoute.toJson(),
        "anchorMode": anchorMode.name,
        "at": at.toIso8601String(),
      };

  factory MapDraftEvent.fromJson(Map<String, dynamic> json) => MapDraftEvent(
        originLat: (json["originLat"] as num?)?.toDouble(),
        originLng: (json["originLng"] as num?)?.toDouble(),
        originPlaceId: json["originPlaceId"] as String?,
        destName: json["destName"] as String,
        destLat: (json["destLat"] as num).toDouble(),
        destLng: (json["destLng"] as num).toDouble(),
        selectedRoute:
            RouteOption.fromJson(json["selectedRoute"] as Map<String, dynamic>),
        anchorMode: EventAnchor.values.firstWhere(
          (e) => e.name == json["anchorMode"],
          orElse: () => EventAnchor.arriveBy,
        ),
        at: DateTime.parse(json["at"] as String),
      );
}

/// Issue #55: cold start 시 데이터 유실 방지.
/// StateProvider는 앱 kill 시 사라지므로, draft를 Hive에 영속화하는
/// Notifier로 교체한다. 지도 → 일정 폼 이동 중 앱이 종료돼도
/// 재시작 시 마지막 선택한 경로 draft를 복원한다.
class MapDraftEventNotifier extends StateNotifier<MapDraftEvent?> {
  MapDraftEventNotifier() : super(null) {
    _restore();
  }

  static const _boxName = "map_draft";
  static const _key = "current";

  Future<void> _restore() async {
    try {
      final box = await Hive.openBox<String>(_boxName);
      final raw = box.get(_key);
      if (raw != null) {
        state = MapDraftEvent.fromJson(
          jsonDecode(raw) as Map<String, dynamic>,
        );
      }
    } catch (_) {
      // 복원 실패해도 앱 흐름은 막지 않는다
    }
  }

  Future<void> set(MapDraftEvent? draft) async {
    state = draft;
    try {
      final box = await Hive.openBox<String>(_boxName);
      if (draft == null) {
        await box.delete(_key);
      } else {
        await box.put(_key, jsonEncode(draft.toJson()));
      }
    } catch (_) {
      // 영속화 실패해도 in-memory state는 유지된다
    }
  }

  /// 일정 생성 완료 후 draft 소거
  Future<void> clear() => set(null);
}

final mapDraftEventProvider =
    StateNotifierProvider<MapDraftEventNotifier, MapDraftEvent?>(
  (ref) => MapDraftEventNotifier(),
);
