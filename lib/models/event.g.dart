// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Event _$EventFromJson(Map<String, dynamic> json) => _Event(
  eventId: json['eventId'] as String,
  title: json['title'] as String,
  displayLabel: json['displayLabel'] as String?,
  startsAt: DateTime.parse(json['startsAt'] as String),
  endsAt: DateTime.parse(json['endsAt'] as String),
  placeNeed: $enumDecode(_$PlaceNeedEnumMap, json['placeNeed']),
  destinationName: json['destinationName'] as String?,
  destinationLat: (json['destinationLat'] as num?)?.toDouble(),
  destinationLng: (json['destinationLng'] as num?)?.toDouble(),
  anchor:
      $enumDecodeNullable(_$EventAnchorEnumMap, json['anchor']) ??
      EventAnchor.arriveBy,
  sourceType:
      $enumDecodeNullable(_$EventSourceTypeEnumMap, json['sourceType']) ??
      EventSourceType.internal,
  status: json['status'] as String?,
  autoManageExcluded: json['autoManageExcluded'] as bool?,
);

Map<String, dynamic> _$EventToJson(_Event instance) => <String, dynamic>{
  'eventId': instance.eventId,
  'title': instance.title,
  'displayLabel': instance.displayLabel,
  'startsAt': instance.startsAt.toIso8601String(),
  'endsAt': instance.endsAt.toIso8601String(),
  'placeNeed': _$PlaceNeedEnumMap[instance.placeNeed]!,
  'destinationName': instance.destinationName,
  'destinationLat': instance.destinationLat,
  'destinationLng': instance.destinationLng,
  'anchor': _$EventAnchorEnumMap[instance.anchor]!,
  'sourceType': _$EventSourceTypeEnumMap[instance.sourceType]!,
  'status': instance.status,
  'autoManageExcluded': instance.autoManageExcluded,
};

const _$PlaceNeedEnumMap = {
  PlaceNeed.requiredResolved: 'required_resolved',
  PlaceNeed.requiredMissing: 'required_missing',
  PlaceNeed.notRequired: 'not_required',
  PlaceNeed.undecided: 'undecided',
};

const _$EventAnchorEnumMap = {
  EventAnchor.arriveBy: 'arrive_by',
  EventAnchor.departAt: 'depart_at',
};

const _$EventSourceTypeEnumMap = {
  EventSourceType.internal: 'internal',
  EventSourceType.external: 'external',
  EventSourceType.mapSearch: 'map_search',
};

_EventClassificationReview _$EventClassificationReviewFromJson(
  Map<String, dynamic> json,
) => _EventClassificationReview(
  questionType: json['questionType'] as String,
  userAnswer: json['userAnswer'] as String,
);

Map<String, dynamic> _$EventClassificationReviewToJson(
  _EventClassificationReview instance,
) => <String, dynamic>{
  'questionType': instance.questionType,
  'userAnswer': instance.userAnswer,
};
