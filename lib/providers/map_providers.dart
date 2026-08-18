import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_riverpod/legacy.dart";
import "../core/app_config.dart";
import "../models/event.dart";
import "../models/plan.dart";
import "../network/kakao_local_search_service.dart";

final kakaoLocalSearchServiceProvider = Provider<KakaoLocalSearchService>((ref) {
  return KakaoLocalSearchService(restApiKey: kKakaoRestApiKey);
});

/// 지도 화면에서 만든 "저장 대기" 일정 초안. 목적지·경로가 정해지면
/// event_create_from_map_screen.dart로 넘어가기 전에 여기 담아 둔다.
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
}

final mapDraftEventProvider = StateProvider<MapDraftEvent?>((ref) => null);
