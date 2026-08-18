// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wellness_pref.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WellnessPref _$WellnessPrefFromJson(Map<String, dynamic> json) =>
    _WellnessPref(
      topic: json['wellnessTopic'] as String,
      isEnabled: json['isEnabled'] as bool,
      remindIntervalMinutes: (json['remindIntervalMinutes'] as num?)?.toInt(),
      dailyEventCap: (json['dailyEventCap'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$WellnessPrefToJson(_WellnessPref instance) =>
    <String, dynamic>{
      'wellnessTopic': instance.topic,
      'isEnabled': instance.isEnabled,
      'remindIntervalMinutes': instance.remindIntervalMinutes,
      'dailyEventCap': instance.dailyEventCap,
    };
