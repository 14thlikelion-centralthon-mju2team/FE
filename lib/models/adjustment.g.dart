// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adjustment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Adjustment _$AdjustmentFromJson(Map<String, dynamic> json) => _Adjustment(
  routineTaskId: json['routineTaskId'] as String,
  beforeActionId: json['beforeActionId'] as String,
  afterActionId: json['afterActionId'] as String,
  triggerType: json['triggerType'] as String,
  reason: json['reason'] as String,
);

Map<String, dynamic> _$AdjustmentToJson(_Adjustment instance) =>
    <String, dynamic>{
      'routineTaskId': instance.routineTaskId,
      'beforeActionId': instance.beforeActionId,
      'afterActionId': instance.afterActionId,
      'triggerType': instance.triggerType,
      'reason': instance.reason,
    };
