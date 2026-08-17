import 'package:freezed_annotation/freezed_annotation.dart';

part 'action_log.freezed.dart';
part 'action_log.g.dart';

enum ActionType {
  @JsonValue('prep_started')
  prepStarted,
  @JsonValue('preparing')
  preparing,
  @JsonValue('departed')
  departed,
  @JsonValue('arrived')
  arrived,
  @JsonValue('snoozed')
  snoozed,
  @JsonValue('skipped')
  skipped,
  @JsonValue('plan_edited')
  planEdited,
  @JsonValue('checklist_done')
  checklistDone,
  @JsonValue('wellness_done')
  wellnessDone,
  @JsonValue('wellness_later')
  wellnessLater,
  @JsonValue('wellness_stop')
  wellnessStop,
}

enum ActionSource {
  @JsonValue('manual')
  manual,
  @JsonValue('notification_action')
  notificationAction,
  @JsonValue('geofence')
  geofence,
}

/// POST /plans/{id}/actions 요청 바디.
/// clientEventId는 오프라인 큐에 넣는 시점에 한 번만 생성해서 저장해야 한다.
/// 재전송마다 새로 발급하면 서버의 (user_id, client_event_id) UNIQUE
/// 멱등성 보장이 무력화된다 (TR-03).
@freezed
abstract class ActionLogEntry with _$ActionLogEntry {
  const factory ActionLogEntry({
    required String clientEventId,
    required ActionType type,
    required DateTime deviceTs,
    required ActionSource source,
    double? confidence, // source: geofence일 때만 사용. 좌표는 절대 포함하지 않는다.
  }) = _ActionLogEntry;

  factory ActionLogEntry.fromJson(Map<String, dynamic> json) =>
      _$ActionLogEntryFromJson(json);
}

/// POST /plans/{id}/actions 응답.
@freezed
abstract class ActionLogResponse with _$ActionLogResponse {
  const factory ActionLogResponse({
    required bool accepted,
    required bool duplicated, // true면 재전송이 흡수된 것 — 오류 아님
    required Map<String, dynamic> plan, // 갱신된 계획 (Plan.fromJson으로 재파싱)
  }) = _ActionLogResponse;

  factory ActionLogResponse.fromJson(Map<String, dynamic> json) =>
      _$ActionLogResponseFromJson(json);
}
