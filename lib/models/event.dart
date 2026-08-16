import 'package:freezed_annotation/freezed_annotation.dart';

part 'event.freezed.dart';
part 'event.g.dart';

/// 사용자 지정 장소 필요 여부. 자동 분류(CAL-04)보다 항상 우선한다.
/// API 명세서 §8 참고.
enum PlaceNeed {
  @JsonValue('required_resolved')
  requiredResolved,
  @JsonValue('required_missing')
  requiredMissing,
  @JsonValue('not_required')
  notRequired,
  @JsonValue('undecided')
  undecided,
}

/// 계획 계산의 역산 방향을 결정하는 값.
/// - arriveBy: 도착 시각 기준 역산 (기본값)
/// - departAt: 출발 시각 기준 정방향 계산 (지도 검색 결과를 캘린더에 저장한 경우)
enum EventAnchor {
  @JsonValue('arrive_by')
  arriveBy,
  @JsonValue('depart_at')
  departAt,
}

enum EventSourceType {
  @JsonValue('internal')
  internal,
  @JsonValue('external')
  external,
  @JsonValue('map_search')
  mapSearch,
}

@freezed
abstract class Event with _$Event {
  const factory Event({
    required String eventId,
    required String title,
    required DateTime startsAt,
    required DateTime endsAt,
    required PlaceNeed placeNeed,
    String? destinationName,
    double? destinationLat,
    double? destinationLng,
    @Default(EventAnchor.arriveBy) EventAnchor anchor,
    @Default(EventSourceType.internal) EventSourceType sourceType,
    String? status,
    bool? autoManageExcluded,
  }) = _Event;

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
}

/// POST /events/{id}/review 요청 바디.
/// 분류 신뢰도가 낮을 때(classify_conf < 0.70)만 사용자에게 노출한다.
@freezed
abstract class EventClassificationReview with _$EventClassificationReview {
  const factory EventClassificationReview({
    required String questionType, // e.g. "is_online"
    required String userAnswer,
  }) = _EventClassificationReview;

  factory EventClassificationReview.fromJson(Map<String, dynamic> json) =>
      _$EventClassificationReviewFromJson(json);
}
