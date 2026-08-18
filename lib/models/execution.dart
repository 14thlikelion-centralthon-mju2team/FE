import "package:freezed_annotation/freezed_annotation.dart";

part "execution.freezed.dart";
part "execution.g.dart";

/// API v5.0 §14.1 GET /events/{eventId}/execution 응답.
enum ArrivalResult {
  @JsonValue("early")
  early,
  @JsonValue("on_time")
  onTime,
  @JsonValue("rushed")
  rushed,
  @JsonValue("late")
  late_,
  @JsonValue("unknown")
  unknown,
}

@freezed
abstract class EventExecution with _$EventExecution {
  const factory EventExecution({
    DateTime? actualPrepStartedAt,
    DateTime? actualDepartedAt,
    DateTime? actualArrivedAt,
    @Default(ArrivalResult.unknown) ArrivalResult arrivalResult,
    String? resultSource, // user|geo
    int? actualOutdoorMinutes,
    // rushLoadScore는 운영 지표 전용이라 클라이언트가 표시하지 않는다
    // (PRD 절대 원칙 3) — 모델에는 실어 오되 화면에 노출하지 않는다.
    int? rushLoadScore,
  }) = _EventExecution;

  factory EventExecution.fromJson(Map<String, dynamic> json) =>
      _$EventExecutionFromJson(json);
}

/// API v5.0 §14.2 POST /events/{eventId}/feedback 요청 바디.
enum PrepTimingAssessment {
  @JsonValue("too_early")
  tooEarly,
  @JsonValue("appropriate")
  appropriate,
  @JsonValue("too_late")
  tooLate,
}

enum RushAssessment {
  @JsonValue("not_rushed")
  notRushed,
  @JsonValue("slightly_rushed")
  slightlyRushed,
  @JsonValue("very_rushed")
  veryRushed,
}
