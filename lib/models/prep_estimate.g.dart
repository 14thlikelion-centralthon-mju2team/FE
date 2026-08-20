// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prep_estimate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PrepEstimate _$PrepEstimateFromJson(Map<String, dynamic> json) =>
    _PrepEstimate(
      scopeType: json['scopeType'] as String,
      scopeValue: json['scopeValue'] as String?,
      estimatedMinutes: (json['estimatedMinutes'] as num).toInt(),
      sampleCount: (json['sampleCount'] as num).toInt(),
      lastReason: json['adjustmentReason'] as String?,
    );

Map<String, dynamic> _$PrepEstimateToJson(_PrepEstimate instance) =>
    <String, dynamic>{
      'scopeType': instance.scopeType,
      'scopeValue': instance.scopeValue,
      'estimatedMinutes': instance.estimatedMinutes,
      'sampleCount': instance.sampleCount,
      'adjustmentReason': instance.lastReason,
    };
