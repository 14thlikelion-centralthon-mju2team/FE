// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlanReason _$PlanReasonFromJson(Map<String, dynamic> json) => _PlanReason(
  field: json['field'] as String,
  source: json['source'] as String,
  adjusted: json['adjusted'] as bool,
  text: json['text'] as String,
  sampleCount: (json['sampleCount'] as num?)?.toInt(),
);

Map<String, dynamic> _$PlanReasonToJson(_PlanReason instance) =>
    <String, dynamic>{
      'field': instance.field,
      'source': instance.source,
      'adjusted': instance.adjusted,
      'text': instance.text,
      'sampleCount': instance.sampleCount,
    };

_PlanBreakdown _$PlanBreakdownFromJson(Map<String, dynamic> json) =>
    _PlanBreakdown(
      estimatedPrepMinutes: (json['estimatedPrepMinutes'] as num).toInt(),
      extraPrepMinutes: (json['extraPrepMinutes'] as num).toInt(),
      personalRoutineMinutes: (json['personalRoutineMinutes'] as num).toInt(),
      travelMinutes: (json['travelMinutes'] as num).toInt(),
      trafficBufferMinutes: (json['trafficBufferMinutes'] as num).toInt(),
      arrivalBufferMinutes: (json['arrivalBufferMinutes'] as num).toInt(),
    );

Map<String, dynamic> _$PlanBreakdownToJson(_PlanBreakdown instance) =>
    <String, dynamic>{
      'estimatedPrepMinutes': instance.estimatedPrepMinutes,
      'extraPrepMinutes': instance.extraPrepMinutes,
      'personalRoutineMinutes': instance.personalRoutineMinutes,
      'travelMinutes': instance.travelMinutes,
      'trafficBufferMinutes': instance.trafficBufferMinutes,
      'arrivalBufferMinutes': instance.arrivalBufferMinutes,
    };

_ChecklistItem _$ChecklistItemFromJson(Map<String, dynamic> json) =>
    _ChecklistItem(
      planPrepItemId: json['planPrepItemId'] as String,
      itemName: json['itemName'] as String,
      actionType: $enumDecode(_$PrepActionTypeEnumMap, json['actionType']),
      sourceType: $enumDecode(_$ChecklistSourceTypeEnumMap, json['sourceType']),
      completionStatus: $enumDecode(
        _$ChecklistCompletionStatusEnumMap,
        json['completionStatus'],
      ),
      isSensitive: json['isSensitive'] as bool? ?? false,
      appliedMinutes: (json['appliedMinutes'] as num?)?.toInt() ?? 0,
      reason: json['reason'] as String?,
    );

Map<String, dynamic> _$ChecklistItemToJson(_ChecklistItem instance) =>
    <String, dynamic>{
      'planPrepItemId': instance.planPrepItemId,
      'itemName': instance.itemName,
      'actionType': _$PrepActionTypeEnumMap[instance.actionType]!,
      'sourceType': _$ChecklistSourceTypeEnumMap[instance.sourceType]!,
      'completionStatus':
          _$ChecklistCompletionStatusEnumMap[instance.completionStatus]!,
      'isSensitive': instance.isSensitive,
      'appliedMinutes': instance.appliedMinutes,
      'reason': instance.reason,
    };

const _$PrepActionTypeEnumMap = {
  PrepActionType.carry: 'carry',
  PrepActionType.consume: 'consume',
  PrepActionType.purchase: 'purchase',
  PrepActionType.timedRoutine: 'timed_routine',
};

const _$ChecklistSourceTypeEnumMap = {
  ChecklistSourceType.rule: 'rule',
  ChecklistSourceType.eventItem: 'event_item',
  ChecklistSourceType.weather: 'weather',
};

const _$ChecklistCompletionStatusEnumMap = {
  ChecklistCompletionStatus.pending: 'pending',
  ChecklistCompletionStatus.completed: 'completed',
};

_WellnessAction _$WellnessActionFromJson(Map<String, dynamic> json) =>
    _WellnessAction(
      wellnessActionId: json['wellnessActionId'] as String,
      wellnessTopic: json['wellnessTopic'] as String,
      actionCode: json['actionCode'] as String,
      actionLabel: json['actionLabel'] as String,
      displayRank: (json['displayRank'] as num).toInt(),
      reasonSnapshot: json['reasonSnapshot'] as String?,
      completionStatus: $enumDecode(
        _$WellnessActionCompletionStatusEnumMap,
        json['completionStatus'],
      ),
    );

Map<String, dynamic> _$WellnessActionToJson(_WellnessAction instance) =>
    <String, dynamic>{
      'wellnessActionId': instance.wellnessActionId,
      'wellnessTopic': instance.wellnessTopic,
      'actionCode': instance.actionCode,
      'actionLabel': instance.actionLabel,
      'displayRank': instance.displayRank,
      'reasonSnapshot': instance.reasonSnapshot,
      'completionStatus':
          _$WellnessActionCompletionStatusEnumMap[instance.completionStatus]!,
    };

const _$WellnessActionCompletionStatusEnumMap = {
  WellnessActionCompletionStatus.proposed: 'proposed',
  WellnessActionCompletionStatus.completed: 'completed',
  WellnessActionCompletionStatus.dismissed: 'dismissed',
};

_WellnessSummary _$WellnessSummaryFromJson(Map<String, dynamic> json) =>
    _WellnessSummary(
      wisScore: (json['wisScore'] as num).toInt(),
      wisBand: $enumDecode(_$WisBandEnumMap, json['wisBand']),
      weightVersion: json['weightVersion'] as String,
      eventArmed: json['eventArmed'] as bool,
    );

Map<String, dynamic> _$WellnessSummaryToJson(_WellnessSummary instance) =>
    <String, dynamic>{
      'wisScore': instance.wisScore,
      'wisBand': _$WisBandEnumMap[instance.wisBand]!,
      'weightVersion': instance.weightVersion,
      'eventArmed': instance.eventArmed,
    };

const _$WisBandEnumMap = {
  WisBand.low: 'low',
  WisBand.mid: 'mid',
  WisBand.high: 'high',
};

_PlanContext _$PlanContextFromJson(Map<String, dynamic> json) => _PlanContext(
  uvIndex: (json['uvIndex'] as num?)?.toInt(),
  pm10: (json['pm10'] as num?)?.toInt(),
  pm25: (json['pm25'] as num?)?.toInt(),
  feelsLike: (json['feelsLike'] as num?)?.toDouble(),
  precipitationProb: (json['precipitationProb'] as num?)?.toInt(),
  estimatedOutdoorMinutes: (json['estimatedOutdoorMinutes'] as num).toInt(),
  weatherProvider: json['weatherProvider'] as String?,
  airProvider: json['airProvider'] as String?,
  observedAt: json['observedAt'] == null
      ? null
      : DateTime.parse(json['observedAt'] as String),
);

Map<String, dynamic> _$PlanContextToJson(_PlanContext instance) =>
    <String, dynamic>{
      'uvIndex': instance.uvIndex,
      'pm10': instance.pm10,
      'pm25': instance.pm25,
      'feelsLike': instance.feelsLike,
      'precipitationProb': instance.precipitationProb,
      'estimatedOutdoorMinutes': instance.estimatedOutdoorMinutes,
      'weatherProvider': instance.weatherProvider,
      'airProvider': instance.airProvider,
      'observedAt': instance.observedAt?.toIso8601String(),
    };

_Plan _$PlanFromJson(Map<String, dynamic> json) => _Plan(
  planId: json['planId'] as String,
  eventId: json['eventId'] as String,
  revisionNo: (json['revisionNo'] as num).toInt(),
  calcVersion: json['calcVersion'] as String,
  planStatus: $enumDecode(_$PlanStatusEnumMap, json['planStatus']),
  eventStatus: $enumDecode(_$EventLifecycleStatusEnumMap, json['eventStatus']),
  feasible: json['feasible'] as bool,
  predictionConfidence: json['predictionConfidence'] as String?,
  prepStartAt: DateTime.parse(json['prepStartAt'] as String),
  recommendedDepartAt: DateTime.parse(json['recommendedDepartAt'] as String),
  targetArriveAt: DateTime.parse(json['targetArriveAt'] as String),
  breakdown: PlanBreakdown.fromJson(json['breakdown'] as Map<String, dynamic>),
  reasons: (json['reasons'] as List<dynamic>)
      .map((e) => PlanReason.fromJson(e as Map<String, dynamic>))
      .toList(),
  checklist: (json['checklist'] as List<dynamic>)
      .map((e) => ChecklistItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  wellnessActions:
      (json['wellnessActions'] as List<dynamic>?)
          ?.map((e) => WellnessAction.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  wellness: json['wellness'] == null
      ? null
      : WellnessSummary.fromJson(json['wellness'] as Map<String, dynamic>),
  context: json['context'] == null
      ? null
      : PlanContext.fromJson(json['context'] as Map<String, dynamic>),
  selectedRouteOptionId: json['selectedRouteOptionId'] as String?,
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
  'predictionConfidence': instance.predictionConfidence,
  'prepStartAt': instance.prepStartAt.toIso8601String(),
  'recommendedDepartAt': instance.recommendedDepartAt.toIso8601String(),
  'targetArriveAt': instance.targetArriveAt.toIso8601String(),
  'breakdown': instance.breakdown,
  'reasons': instance.reasons,
  'checklist': instance.checklist,
  'wellnessActions': instance.wellnessActions,
  'wellness': instance.wellness,
  'context': instance.context,
  'selectedRouteOptionId': instance.selectedRouteOptionId,
  'degraded': instance.degraded,
};

const _$PlanStatusEnumMap = {
  PlanStatus.active: 'active',
  PlanStatus.superseded: 'superseded',
};

const _$EventLifecycleStatusEnumMap = {
  EventLifecycleStatus.planned: 'planned',
  EventLifecycleStatus.notified: 'notified',
  EventLifecycleStatus.preparing: 'preparing',
  EventLifecycleStatus.enroute: 'enroute',
  EventLifecycleStatus.arrived: 'arrived',
  EventLifecycleStatus.closed: 'closed',
  EventLifecycleStatus.skipped: 'skipped',
  EventLifecycleStatus.cancelled: 'cancelled',
  EventLifecycleStatus.unresolved: 'unresolved',
};

_RouteOption _$RouteOptionFromJson(Map<String, dynamic> json) => _RouteOption(
  routeOptionId: json['routeOptionId'] as String,
  routeRank: (json['routeRank'] as num).toInt(),
  routeType: $enumDecode(_$RouteTypeEnumMap, json['routeType']),
  totalMinutes: (json['totalMinutes'] as num).toInt(),
  walkMinutes: (json['walkMinutes'] as num).toInt(),
  transferCount: (json['transferCount'] as num).toInt(),
  departAt: json['departAt'] == null
      ? null
      : DateTime.parse(json['departAt'] as String),
  arriveAt: json['arriveAt'] == null
      ? null
      : DateTime.parse(json['arriveAt'] as String),
);

Map<String, dynamic> _$RouteOptionToJson(_RouteOption instance) =>
    <String, dynamic>{
      'routeOptionId': instance.routeOptionId,
      'routeRank': instance.routeRank,
      'routeType': _$RouteTypeEnumMap[instance.routeType]!,
      'totalMinutes': instance.totalMinutes,
      'walkMinutes': instance.walkMinutes,
      'transferCount': instance.transferCount,
      'departAt': instance.departAt?.toIso8601String(),
      'arriveAt': instance.arriveAt?.toIso8601String(),
    };

const _$RouteTypeEnumMap = {
  RouteType.fastest: 'fastest',
  RouteType.leastWalk: 'least_walk',
  RouteType.leastTransfer: 'least_transfer',
};
