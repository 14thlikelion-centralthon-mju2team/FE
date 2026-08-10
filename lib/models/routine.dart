import 'package:freezed_annotation/freezed_annotation.dart';
import 'action_item.dart';

part 'routine.freezed.dart';
part 'routine.g.dart';

@freezed
abstract class RoutineTask with _$RoutineTask {
  const factory RoutineTask({
    required String id,
    required String routineId,
    required ActionItem action, // 현재 난이도 — adjustments를 통해서만 바뀜
    required int orderNo,
  }) = _RoutineTask;

  factory RoutineTask.fromJson(Map<String, dynamic> json) => _$RoutineTaskFromJson(json);
}

@freezed
abstract class Routine with _$Routine {
  const factory Routine({
    required String id,
    String? placeId, // null = 시간 기반
    required String title,
    required String scheduleType, // "time" | "place"
    String? rrule,
    String? anchorTime,
    required List<RoutineTask> tasks,
  }) = _Routine;

  factory Routine.fromJson(Map<String, dynamic> json) => _$RoutineFromJson(json);
}