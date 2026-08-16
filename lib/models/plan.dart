import 'package:freezed_annotation/freezed_annotation.dart';

part 'plan.freezed.dart';
part 'plan.g.dart';

/// 계획 계산 한 단계의 근거. 서버가 정렬해주지 않으므로 화면 순서는
/// 클라이언트가 결정한다 (API 명세 §9, PRD §31 미결 — 웰니스 카드 우선순위).
@freezed
abstract class TraceItem with _$TraceItem {
  const factory TraceItem({
    required String label,
    required int minutes,
    required String source, // model | prepItem | provider | wellness 등
    required bool adjusted,
    String? reason,
  }) = _TraceItem;

  factory TraceItem.fromJson(Map<String, dynamic> json) =>
      _$TraceItemFromJson(json);
}

enum ChecklistOrigin {
  @JsonValue('user')
  user,
  @JsonValue('wellness')
  wellness,
}

enum ChecklistState {
  @JsonValue('pending')
  pending,
  @JsonValue('completed')
  completed,
}

/// 사용자 등록 준비 항목과 웰니스 제안 행동이 병합된 결과.
/// 같은 대상(예: 둘 다 "선크림")은 서버가 1개로 합쳐서 내려준다 (API 명세 §9).
@freezed
abstract class ChecklistItem with _$ChecklistItem {
  const factory ChecklistItem({
    required String label,
    required ChecklistOrigin origin,
    required String kind, // carry | consume | purchase | routine
    required ChecklistState state,
    String? reason,
    @Default(false) bool private, // true면 잠금화면·푸시에서 lockAlias로 치환
  }) = _ChecklistItem;

  factory ChecklistItem.fromJson(Map<String, dynamic> json) =>
      _$ChecklistItemFromJson(json);
}

@freezed
abstract class WellnessSummary with _$WellnessSummary {
  const factory WellnessSummary({
    required int wis,
    required String wisVer,
    required int actionsShown,
    required bool eventArmed,
  }) = _WellnessSummary;

  factory WellnessSummary.fromJson(Map<String, dynamic> json) =>
      _$WellnessSummaryFromJson(json);
}

/// GET /plans/{id} 응답 전체.
@freezed
abstract class Plan with _$Plan {
  const factory Plan({
    required String planId,
    required int revisionNo,
    required String engineVer,
    required String state, // PLANNED|NOTIFIED|PREPARING|ENROUTE|ARRIVED|UNRESOLVED|CLOSED|SKIPPED|CANCELLED
    required bool feasible,
    required DateTime prepStartAt,
    required DateTime departAt,
    required DateTime etaAt,
    required List<TraceItem> trace,
    required List<ChecklistItem> checklist,
    WellnessSummary? wellness,
    @Default([]) List<String> degraded,
  }) = _Plan;

  factory Plan.fromJson(Map<String, dynamic> json) => _$PlanFromJson(json);
}

/// 경로 후보 3종 고정 (MAP-01~04). 인터랙티브 레이어·자체 경로 점수는
/// 명시적 비목표이므로 이 모델에 관련 필드를 추가하지 않는다.
enum RouteRank {
  @JsonValue('fastest')
  fastest,
  @JsonValue('least_walk')
  leastWalk,
  @JsonValue('least_transfer')
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
    required int outdoorSec, // 웰니스 엔진 WIS의 O 입력값
  }) = _RouteOption;

  factory RouteOption.fromJson(Map<String, dynamic> json) =>
      _$RouteOptionFromJson(json);
}
