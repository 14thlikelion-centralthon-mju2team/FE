// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ActionLogEntry _$ActionLogEntryFromJson(Map<String, dynamic> json) =>
    _ActionLogEntry(
      clientEventId: json['clientEventId'] as String,
      type: $enumDecode(_$ActionTypeEnumMap, json['type']),
      deviceTs: DateTime.parse(json['deviceTs'] as String),
      source: $enumDecode(_$ActionSourceEnumMap, json['source']),
      confidence: (json['confidence'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ActionLogEntryToJson(_ActionLogEntry instance) =>
    <String, dynamic>{
      'clientEventId': instance.clientEventId,
      'type': _$ActionTypeEnumMap[instance.type]!,
      'deviceTs': instance.deviceTs.toIso8601String(),
      'source': _$ActionSourceEnumMap[instance.source]!,
      'confidence': instance.confidence,
    };

const _$ActionTypeEnumMap = {
  ActionType.prepStarted: 'prep_started',
  ActionType.preparing: 'preparing',
  ActionType.departed: 'departed',
  ActionType.arrived: 'arrived',
  ActionType.snoozed: 'snoozed',
  ActionType.skipped: 'skipped',
  ActionType.planEdited: 'plan_edited',
  ActionType.checklistDone: 'checklist_done',
  ActionType.wellnessDone: 'wellness_done',
  ActionType.wellnessLater: 'wellness_later',
  ActionType.wellnessStop: 'wellness_stop',
};

const _$ActionSourceEnumMap = {
  ActionSource.manual: 'manual',
  ActionSource.notificationAction: 'notification_action',
  ActionSource.geofence: 'geofence',
};

_ActionLogResponse _$ActionLogResponseFromJson(Map<String, dynamic> json) =>
    _ActionLogResponse(
      accepted: json['accepted'] as bool,
      duplicated: json['duplicated'] as bool,
      plan: json['plan'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$ActionLogResponseToJson(_ActionLogResponse instance) =>
    <String, dynamic>{
      'accepted': instance.accepted,
      'duplicated': instance.duplicated,
      'plan': instance.plan,
    };
