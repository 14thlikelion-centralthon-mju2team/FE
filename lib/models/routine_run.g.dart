// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routine_run.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RoutineRun _$RoutineRunFromJson(Map<String, dynamic> json) => _RoutineRun(
  id: json['id'] as String,
  routineId: json['routineId'] as String,
  runDate: DateTime.parse(json['runDate'] as String),
  status: json['status'] as String,
  startedAt: json['startedAt'] == null
      ? null
      : DateTime.parse(json['startedAt'] as String),
  finishedAt: json['finishedAt'] == null
      ? null
      : DateTime.parse(json['finishedAt'] as String),
);

Map<String, dynamic> _$RoutineRunToJson(_RoutineRun instance) =>
    <String, dynamic>{
      'id': instance.id,
      'routineId': instance.routineId,
      'runDate': instance.runDate.toIso8601String(),
      'status': instance.status,
      'startedAt': instance.startedAt?.toIso8601String(),
      'finishedAt': instance.finishedAt?.toIso8601String(),
    };
