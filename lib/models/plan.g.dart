// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlanReason _$PlanReasonFromJson(Map<String, dynamic> json) => _PlanReason(
  label: json['label'] as String,
  minutes: (json['minutes'] as num).toInt(),
  source: json['source'] as String,
  adjusted: json['adjusted'] as bool,
  reason: json['reason'] as String?,
);

Map<String, dynamic> _$PlanReasonToJson(_PlanReason instance) =>
    <String, dynamic>{
      'label': instance.label,
      'minutes': instance.minutes,
      'source': instance.source,
      'adjusted': instance.adjusted,
      'reason': instance.reason,
    };

_PlanBreakdown _$PlanBreakdownFromJson(Map<String, dynamic> json) =>
    _PlanBreakdown(
      prepMinutes: (json['prepMinutes'] as num).toInt(),
      extraPrepMinutes: (json['extraPrepMinutes'] as num).toInt(),
      personalRoutineMinutes: (json['personalRoutineMinutes'] as num).toInt(),
      travelMinutes: (json['travelMinutes'] as num).toInt(),
      trafficBufferMinutes: (json['trafficBufferMinutes'] as num).toInt(),
    );

Map<String, dynamic> _$PlanBreakdownToJson(_PlanBreakdown instance) =>
    <String, dynamic>{
      'prepMinutes': instance.prepMinutes,
      'extraPrepMinutes': instance.extraPrepMinutes,
      'personalRoutineMinutes': instance.personalRoutineMinutes,
      'travelMinutes': instance.travelMinutes,
      'trafficBufferMinutes': instance.trafficBufferMinutes,
    };

_ChecklistItem _$ChecklistItemFromJson(Map<String, dynamic> json) =>
    _ChecklistItem(
      itemId: json['itemId'] as String,
      itemName: json['itemName'] as String,
      sourceType: $enumDecode(_$ChecklistSourceTypeEnumMap, json['sourceType']),
      actionType: json['actionType'] as String,
      completionStatus: $enumDecode(
        _$ChecklistCompletionStatusEnumMap,
        json['completionStatus'],
      ),
      reason: json['reason'] as String?,
      private: json['private'] as bool? ?? false,
    );

Map<String, dynamic> _$ChecklistItemToJson(_ChecklistItem instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'itemName': instance.itemName,
      'sourceType': _$ChecklistSourceTypeEnumMap[instance.sourceType]!,
      'actionType': instance.actionType,
      'completionStatus':
          _$ChecklistCompletionStatusEnumMap[instance.completionStatus]!,
      'reason': instance.reason,
      'private': instance.private,
    };

const _$ChecklistSourceTypeEnumMap = {
  ChecklistSourceType.user: 'user',
  ChecklistSourceType.wellness: 'wellness',
};

const _$ChecklistCompletionStatusEnumMap = {
  ChecklistCompletionStatus.pending: 'pending',
  ChecklistCompletionStatus.completed: 'completed',
};

_WellnessSummary _$WellnessSummaryFromJson(Map<String, dynamic> json) =>
    _WellnessSummary(
      wisScore: (json['wisScore'] as num).toInt(),
      weightVersion: json['weightVersion'] as String,
      actionsShown: (json['actionsShown'] as num).toInt(),
      eventArmed: json['eventArmed'] as bool,
    );

Map<String, dynamic> _$WellnessSummaryToJson(_WellnessSummary instance) =>
    <String, dynamic>{
      'wisScore': instance.wisScore,
      'weightVersion': instance.weightVersion,
      'actionsShown': instance.actionsShown,
      'eventArmed': instance.eventArmed,
    };

_Plan _$PlanFromJson(Map<String, dynamic> json) => _Plan(
  planId: json['planId'] as String,
  eventId: json['eventId'] as String,
  revisionNo: (json['revisionNo'] as num).toInt(),
  calcVersion: json['calcVersion'] as String,
  planStatus: $enumDecode(_$PlanStatusEnumMap, json['planStatus']),
  eventStatus: $enumDecode(_$EventLifecycleStatusEnumMap, json['eventStatus']),
  feasible: json['feasible'] as bool,
  prepStartAt: DateTime.parse(json['prepStartAt'] as String),
  recommendedDepartAt: DateTime.parse(json['recommendedDepartAt'] as String),
  targetArriveAt: DateTime.parse(json['targetArriveAt'] as String),
  reasons: (json['reasons'] as List<dynamic>)
      .map((e) => PlanReason.fromJson(e as Map<String, dynamic>))
      .toList(),
  breakdown: PlanBreakdown.fromJson(json['breakdown'] as Map<String, dynamic>),
  checklist: (json['checklist'] as List<dynamic>)
      .map((e) => ChecklistItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  wellness: json['wellness'] == null
      ? null
      : WellnessSummary.fromJson(json['wellness'] as Map<String, dynamic>),
  degraded:
      (json['degraded'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$PlanToJson(_Plan instance) => <String, dynamic>{
  'planId': instance.planId,
  'eventId': instance.eventId,
  'revisionNo': instance.revisionNo,
  'calcVersion': instance.calcVersion,
  'planStatus': _$PlanStatusEnumMap[instance.planStatus]!,
  'eventStatus': _$EventLifecycleStatusEnumMap[instance.eventStatus]!,
  'feasible': instance.feasible,
  'prepStartAt': instance.prepStartAt.toIso8601String(),
  'recommendedDepartAt': instance.recommendedDepartAt.toIso8601String(),
  'targetArriveAt': instance.targetArriveAt.toIso8601String(),
  'reasons': instance.reasons,
  'breakdown': instance.breakdown,
  'checklist': instance.checklist,
  'wellness': instance.wellness,
  'degraded': instance.degraded,
};

const _$PlanStatusEnumMap = {
  PlanStatus.planned: 'planned',
  PlanStatus.notified: 'notified',
  PlanStatus.preparing: 'preparing',
  PlanStatus.enroute: 'enroute',
  PlanStatus.arrived: 'arrived',
  PlanStatus.unresolved: 'unresolved',
  PlanStatus.closed: 'closed',
  PlanStatus.skipped: 'skipped',
  PlanStatus.cancelled: 'cancelled',
};

const _$EventLifecycleStatusEnumMap = {
  EventLifecycleStatus.planned: 'planned',
  EventLifecycleStatus.needsReview: 'needs_review',
  EventLifecycleStatus.confirmed: 'confirmed',
  EventLifecycleStatus.skipped: 'skipped',
  EventLifecycleStatus.ended: 'ended',
};

_RouteOption _$RouteOptionFromJson(Map<String, dynamic> json) => _RouteOption(
  routeId: json['routeId'] as String,
  rank: $enumDecode(_$RouteRankEnumMap, json['rank']),
  totalSec: (json['totalSec'] as num).toInt(),
  walkSec: (json['walkSec'] as num).toInt(),
  transfers: (json['transfers'] as num).toInt(),
  outdoorSec: (json['outdoorSec'] as num).toInt(),
);

Map<String, dynamic> _$RouteOptionToJson(_RouteOption instance) =>
    <String, dynamic>{
      'routeId': instance.routeId,
      'rank': _$RouteRankEnumMap[instance.rank]!,
      'totalSec': instance.totalSec,
      'walkSec': instance.walkSec,
      'transfers': instance.transfers,
      'outdoorSec': instance.outdoorSec,
    };

const _$RouteRankEnumMap = {
  RouteRank.fastest: 'fastest',
  RouteRank.leastWalk: 'least_walk',
  RouteRank.leastTransfer: 'least_transfer',
};
