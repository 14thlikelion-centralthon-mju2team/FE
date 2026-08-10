// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DailyState _$DailyStateFromJson(Map<String, dynamic> json) => _DailyState(
  runDate: DateTime.parse(json['runDate'] as String),
  doneCount: (json['doneCount'] as num).toInt(),
  expectedCount: (json['expectedCount'] as num).toInt(),
  completionRate: (json['completionRate'] as num).toDouble(),
  signal: json['signal'] as String,
);

Map<String, dynamic> _$DailyStateToJson(_DailyState instance) =>
    <String, dynamic>{
      'runDate': instance.runDate.toIso8601String(),
      'doneCount': instance.doneCount,
      'expectedCount': instance.expectedCount,
      'completionRate': instance.completionRate,
      'signal': instance.signal,
    };
