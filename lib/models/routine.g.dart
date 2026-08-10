// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routine.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RoutineTask _$RoutineTaskFromJson(Map<String, dynamic> json) => _RoutineTask(
  id: json['id'] as String,
  routineId: json['routineId'] as String,
  action: ActionItem.fromJson(json['action'] as Map<String, dynamic>),
  orderNo: (json['orderNo'] as num).toInt(),
);

Map<String, dynamic> _$RoutineTaskToJson(_RoutineTask instance) =>
    <String, dynamic>{
      'id': instance.id,
      'routineId': instance.routineId,
      'action': instance.action,
      'orderNo': instance.orderNo,
    };

_Routine _$RoutineFromJson(Map<String, dynamic> json) => _Routine(
  id: json['id'] as String,
  placeId: json['placeId'] as String?,
  title: json['title'] as String,
  scheduleType: json['scheduleType'] as String,
  rrule: json['rrule'] as String?,
  anchorTime: json['anchorTime'] as String?,
  tasks: (json['tasks'] as List<dynamic>)
      .map((e) => RoutineTask.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$RoutineToJson(_Routine instance) => <String, dynamic>{
  'id': instance.id,
  'placeId': instance.placeId,
  'title': instance.title,
  'scheduleType': instance.scheduleType,
  'rrule': instance.rrule,
  'anchorTime': instance.anchorTime,
  'tasks': instance.tasks,
};
