import "package:freezed_annotation/freezed_annotation.dart";

part "plan.freezed.dart";
part "plan.g.dart";

/// 오케스트레이터 상태 기계(TRD §8.1)의 값. eventStatus(아래)와 서로 다른
/// 생명주기이므로 절대 하나로 합치지 않는다 -- API 명세 §9 원칙.
enum PlanStatus {
  @JsonValue("planned")
  planned,
  @JsonValue("notified")
  notified,
  @JsonValue("preparing")
  preparing,
  @JsonValue("enroute")
  enroute,
  @JsonValue("arrived")
  arrived,
  @JsonValue("unresolved")
  unresolved,
  @JsonValue("closed")
  closed,
  @JsonValue("skipped")
  skipped,
  @JsonValue("cancelled")
  cancelled,
}

/// 일정(이벤트) 자체의 생명주기. ERD event.status와 대응.
enum EventLifecycleStatus {
  @JsonValue("planned")
  planned,
  @JsonValue("needs_review")
  needsReview,
  @JsonValue("confirmed")
  confirmed,
  @JsonValue("skipped")
  skipped,
  @JsonValue("ended")
  ended,
}

/// 계산 근거 한 줄. 서버가 정렬하지 않으므로 화면 순서는 클라이언트가
/// 결정한다 (API 명세 §9).
@freezed
abstract class PlanReason with _$PlanReason {
  const factory PlanReason({
    required String label,
    required int minutes,
    required String source,
    required bool adjusted,
    String? reason,
  }) = _PlanReason;

  factory PlanReason.fromJson(Map<String, dynamic> json) =>
      _$PlanReasonFromJson(json);
}

/// 시간 분해값. reasons(사람이 읽는 근거 문장)와 별개로, 정확한 분 단위
/// 구성 요소를 구조화해서 담는다 -- TRD plan_revision 컬럼과 대응.
@freezed
abstract class PlanBreakdown with _$PlanBreakdown {
  const factory PlanBreakdown({
    required int prepMinutes,
    required int extraPrepMinutes,
    required int personalRoutineMinutes,
    required int travelMinutes,
    required int trafficBufferMinutes,
  }) = _PlanBreakdown;

  factory PlanBreakdown.fromJson(Map<String, dynamic> json) =>
      _$PlanBreakdownFromJson(json);
}

enum ChecklistSourceType {
  @JsonValue("user")
  user,
  @JsonValue("wellness")
  wellness,
}

enum ChecklistCompletionStatus {
  @JsonValue("pending")
  pending,
  @JsonValue("completed")
  completed,
}

/// 준비물 체크리스트 항목. itemId가 없으면 서버에 완료 상태를 반영할
/// 방법이 없어 리뷰에서 지적됨 -- 반드시 포함.
@freezed
abstract class ChecklistItem with _$ChecklistItem {
  const factory ChecklistItem({
    required String itemId,
    required String itemName,
    required ChecklistSourceType sourceType,
    required String actionType, // carry | consume | purchase | routine
    required ChecklistCompletionStatus completionStatus,
    String? reason,
    @Default(false) bool private,
  }) = _ChecklistItem;

  factory ChecklistItem.fromJson(Map<String, dynamic> json) =>
      _$ChecklistItemFromJson(json);
}

@freezed
abstract class WellnessSummary with _$WellnessSummary {
  const factory WellnessSummary({
    required int wisScore,
    required String weightVersion,
    required int actionsShown,
    required bool eventArmed,
  }) = _WellnessSummary;

  factory WellnessSummary.fromJson(Map<String, dynamic> json) =>
      _$WellnessSummaryFromJson(json);
}

/// GET /plans/{id} 응답 전체. 필드명은 TRD §12.2 계약 그대로 따른다 --
/// 이전 버전(engineVer/state/departAt/etaAt/trace/wis/wisVer)은 실제
/// 서버 응답을 파싱하지 못하는 상태였다.
@freezed
abstract class Plan with _$Plan {
  const factory Plan({
    required String planId,
    required String eventId,
    required int revisionNo,
    required String calcVersion,
    required PlanStatus planStatus,
    required EventLifecycleStatus eventStatus,
    required bool feasible,
    required DateTime prepStartAt,
    required DateTime recommendedDepartAt,
    required DateTime targetArriveAt,
    required List<PlanReason> reasons,
    required PlanBreakdown breakdown,
    required List<ChecklistItem> checklist,
    WellnessSummary? wellness,
    @Default([]) List<String> degraded,
  }) = _Plan;

  factory Plan.fromJson(Map<String, dynamic> json) => _$PlanFromJson(json);
}

enum RouteRank {
  @JsonValue("fastest")
  fastest,
  @JsonValue("least_walk")
  leastWalk,
  @JsonValue("least_transfer")
  leastTransfer,
}

@freezed
abstract class RouteOption with _$RouteOption {
  const factory RouteOption({
    required String routeId,
    required RouteRank rank,
    required int totalSec,
    required int walkSec,
    required int transfers,
    required int outdoorSec,
  }) = _RouteOption;

  factory RouteOption.fromJson(Map<String, dynamic> json) =>
      _$RouteOptionFromJson(json);
}