// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TaskLog _$TaskLogFromJson(Map<String, dynamic> json) => _TaskLog(
  id: json['id'] as String,
  routineRunId: json['routineRunId'] as String,
  routineTaskId: json['routineTaskId'] as String,
  status: json['status'] as String,
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
  durationSeconds: (json['durationSeconds'] as num?)?.toInt(),
  memo: json['memo'] as String?,
);

Map<String, dynamic> _$TaskLogToJson(_TaskLog instance) => <String, dynamic>{
  'id': instance.id,
  'routineRunId': instance.routineRunId,
  'routineTaskId': instance.routineTaskId,
  'status': instance.status,
  'completedAt': instance.completedAt?.toIso8601String(),
  'durationSeconds': instance.durationSeconds,
  'memo': instance.memo,
};
