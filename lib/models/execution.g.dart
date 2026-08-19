// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'execution.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EventExecution _$EventExecutionFromJson(Map<String, dynamic> json) =>
    _EventExecution(
      actualPrepStartedAt: json['actualPrepStartedAt'] == null
          ? null
          : DateTime.parse(json['actualPrepStartedAt'] as String),
      actualDepartedAt: json['actualDepartedAt'] == null
          ? null
          : DateTime.parse(json['actualDepartedAt'] as String),
      actualArrivedAt: json['actualArrivedAt'] == null
          ? null
          : DateTime.parse(json['actualArrivedAt'] as String),
      arrivalResult:
          $enumDecodeNullable(_$ArrivalResultEnumMap, json['arrivalResult']) ??
          ArrivalResult.unknown,
      resultSource: json['resultSource'] as String?,
      actualOutdoorMinutes: (json['actualOutdoorMinutes'] as num?)?.toInt(),
      rushLoadScore: (json['rushLoadScore'] as num?)?.toInt(),
    );

Map<String, dynamic> _$EventExecutionToJson(_EventExecution instance) =>
    <String, dynamic>{
      'actualPrepStartedAt': instance.actualPrepStartedAt?.toIso8601String(),
      'actualDepartedAt': instance.actualDepartedAt?.toIso8601String(),
      'actualArrivedAt': instance.actualArrivedAt?.toIso8601String(),
      'arrivalResult': _$ArrivalResultEnumMap[instance.arrivalResult]!,
      'resultSource': instance.resultSource,
      'actualOutdoorMinutes': instance.actualOutdoorMinutes,
      'rushLoadScore': instance.rushLoadScore,
    };

const _$ArrivalResultEnumMap = {
  ArrivalResult.early: 'early',
  ArrivalResult.onTime: 'on_time',
  ArrivalResult.rushed: 'rushed',
  ArrivalResult.late_: 'late',
  ArrivalResult.unknown: 'unknown',
};
