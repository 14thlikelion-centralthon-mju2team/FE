import 'package:freezed_annotation/freezed_annotation.dart';

part 'routine_run.freezed.dart';
part 'routine_run.g.dart';

@freezed
abstract class RoutineRun with _$RoutineRun {
  const factory RoutineRun({
    required String id,
    required String routineId,
    required DateTime runDate,
    required String status, // scheduled|in_progress|done|skipped
    DateTime? startedAt,
    DateTime? finishedAt,
  }) = _RoutineRun;

  factory RoutineRun.fromJson(Map<String, dynamic> json) => _$RoutineRunFromJson(json);
}