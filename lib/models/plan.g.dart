// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TraceItem _$TraceItemFromJson(Map<String, dynamic> json) => _TraceItem(
  label: json['label'] as String,
  minutes: (json['minutes'] as num).toInt(),
  source: json['source'] as String,
  adjusted: json['adjusted'] as bool,
  reason: json['reason'] as String?,
);

Map<String, dynamic> _$TraceItemToJson(_TraceItem instance) =>
    <String, dynamic>{
      'label': instance.label,
      'minutes': instance.minutes,
      'source': instance.source,
      'adjusted': instance.adjusted,
      'reason': instance.reason,
    };

_ChecklistItem _$ChecklistItemFromJson(Map<String, dynamic> json) =>
    _ChecklistItem(
      label: json['label'] as String,
      origin: $enumDecode(_$ChecklistOriginEnumMap, json['origin']),
      kind: json['kind'] as String,
      state: $enumDecode(_$ChecklistStateEnumMap, json['state']),
      reason: json['reason'] as String?,
      private: json['private'] as bool? ?? false,
    );

Map<String, dynamic> _$ChecklistItemToJson(_ChecklistItem instance) =>
    <String, dynamic>{
      'label': instance.label,
      'origin': _$ChecklistOriginEnumMap[instance.origin]!,
      'kind': instance.kind,
      'state': _$ChecklistStateEnumMap[instance.state]!,
      'reason': instance.reason,
      'private': instance.private,
    };

const _$ChecklistOriginEnumMap = {
  ChecklistOrigin.user: 'user',
  ChecklistOrigin.wellness: 'wellness',
};

const _$ChecklistStateEnumMap = {
  ChecklistState.pending: 'pending',
  ChecklistState.completed: 'completed',
};

_WellnessSummary _$WellnessSummaryFromJson(Map<String, dynamic> json) =>
    _WellnessSummary(
      wis: (json['wis'] as num).toInt(),
      wisVer: json['wisVer'] as String,
      actionsShown: (json['actionsShown'] as num).toInt(),
      eventArmed: json['eventArmed'] as bool,
    );

Map<String, dynamic> _$WellnessSummaryToJson(_WellnessSummary instance) =>
    <String, dynamic>{
      'wis': instance.wis,
      'wisVer': instance.wisVer,
      'actionsShown': instance.actionsShown,
      'eventArmed': instance.eventArmed,
    };

_Plan _$PlanFromJson(Map<String, dynamic> json) => _Plan(
  planId: json['planId'] as String,
  revisionNo: (json['revisionNo'] as num).toInt(),
  engineVer: json['engineVer'] as String,
  state: json['state'] as String,
  feasible: json['feasible'] as bool,
  prepStartAt: DateTime.parse(json['prepStartAt'] as String),
  departAt: DateTime.parse(json['departAt'] as String),
  etaAt: DateTime.parse(json['etaAt'] as String),
  trace: (json['trace'] as List<dynamic>)
      .map((e) => TraceItem.fromJson(e as Map<String, dynamic>))
      .toList(),
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
  'revisionNo': instance.revisionNo,
  'engineVer': instance.engineVer,
  'state': instance.state,
  'feasible': instance.feasible,
  'prepStartAt': instance.prepStartAt.toIso8601String(),
  'departAt': instance.departAt.toIso8601String(),
  'etaAt': instance.etaAt.toIso8601String(),
  'trace': instance.trace,
  'checklist': instance.checklist,
  'wellness': instance.wellness,
  'degraded': instance.degraded,
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
