// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'environment_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EnvironmentData _$EnvironmentDataFromJson(Map<String, dynamic> json) =>
    _EnvironmentData(
      temperature: (json['temperature'] as num?)?.toInt(),
      sky: json['sky'] as String?,
      pm10Grade: json['pm10Grade'] as String?,
      pm25Grade: json['pm25Grade'] as String?,
      uvIndex: (json['uvIndex'] as num?)?.toInt(),
    );

Map<String, dynamic> _$EnvironmentDataToJson(_EnvironmentData instance) =>
    <String, dynamic>{
      'temperature': instance.temperature,
      'sky': instance.sky,
      'pm10Grade': instance.pm10Grade,
      'pm25Grade': instance.pm25Grade,
      'uvIndex': instance.uvIndex,
    };
