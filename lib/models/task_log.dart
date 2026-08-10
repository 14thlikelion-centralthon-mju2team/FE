import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_log.freezed.dart';
part 'task_log.g.dart';

@freezed
abstract class TaskLog with _$TaskLog {
  const factory TaskLog({
    required String id,
    required String routineRunId,
    required String routineTaskId,
    required String status, // done|skipped|partial|unknown
    DateTime? completedAt,
    int? durationSeconds,
    String? memo,
  }) = _TaskLog;

  factory TaskLog.fromJson(Map<String, dynamic> json) => _$TaskLogFromJson(json);
}