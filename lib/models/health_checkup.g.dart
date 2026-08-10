// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_checkup.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HealthCheckup _$HealthCheckupFromJson(Map<String, dynamic> json) =>
    _HealthCheckup(
      measuredOn: DateTime.parse(json['measuredOn'] as String),
      data: json['data'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$HealthCheckupToJson(_HealthCheckup instance) =>
    <String, dynamic>{
      'measuredOn': instance.measuredOn.toIso8601String(),
      'data': instance.data,
    };
