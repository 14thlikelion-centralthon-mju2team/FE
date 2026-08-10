// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_checkin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DailyCheckin _$DailyCheckinFromJson(Map<String, dynamic> json) =>
    _DailyCheckin(
      logDate: DateTime.parse(json['logDate'] as String),
      availableMinutes: (json['availableMinutes'] as num).toInt(),
      conditionInferred: json['conditionInferred'] as String?,
      conditionFinal: json['conditionFinal'] as String?,
      conditionAccepted: json['conditionAccepted'] as bool?,
      focusArea: json['focusArea'] as String?,
      isRestDay: json['isRestDay'] as bool? ?? false,
    );

Map<String, dynamic> _$DailyCheckinToJson(_DailyCheckin instance) =>
    <String, dynamic>{
      'logDate': instance.logDate.toIso8601String(),
      'availableMinutes': instance.availableMinutes,
      'conditionInferred': instance.conditionInferred,
      'conditionFinal': instance.conditionFinal,
      'conditionAccepted': instance.conditionAccepted,
      'focusArea': instance.focusArea,
      'isRestDay': instance.isRestDay,
    };
