// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatResponse _$ChatResponseFromJson(Map<String, dynamic> json) =>
    _ChatResponse(
      intent: json['intent'] as String,
      targetTaskId: json['targetTaskId'] as String?,
      proposedActionId: json['proposedActionId'] as String?,
      reason: json['reason'] as String,
    );

Map<String, dynamic> _$ChatResponseToJson(_ChatResponse instance) =>
    <String, dynamic>{
      'intent': instance.intent,
      'targetTaskId': instance.targetTaskId,
      'proposedActionId': instance.proposedActionId,
      'reason': instance.reason,
    };
