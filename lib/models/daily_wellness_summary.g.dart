// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_wellness_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DailyWellnessSummary _$DailyWellnessSummaryFromJson(
  Map<String, dynamic> json,
) => _DailyWellnessSummary(
  summaryDate: json['summaryDate'] as String,
  eventCount: (json['eventCount'] as num).toInt(),
  totalOutdoorMinutes: (json['totalOutdoorMinutes'] as num).toInt(),
  dwlBand: $enumDecode(_$DwlBandEnumMap, json['dwlBand']),
  cardScenario: json['cardScenario'] as String,
  message: json['message'] as String,
  isViewed: json['isViewed'] as bool? ?? false,
  dwlScore: (json['dwlScore'] as num?)?.toInt(),
);

Map<String, dynamic> _$DailyWellnessSummaryToJson(
  _DailyWellnessSummary instance,
) => <String, dynamic>{
  'summaryDate': instance.summaryDate,
  'eventCount': instance.eventCount,
  'totalOutdoorMinutes': instance.totalOutdoorMinutes,
  'dwlBand': _$DwlBandEnumMap[instance.dwlBand]!,
  'cardScenario': instance.cardScenario,
  'message': instance.message,
  'isViewed': instance.isViewed,
  'dwlScore': instance.dwlScore,
};

const _$DwlBandEnumMap = {
  DwlBand.low: 'low',
  DwlBand.mid: 'mid',
  DwlBand.high: 'high',
};
