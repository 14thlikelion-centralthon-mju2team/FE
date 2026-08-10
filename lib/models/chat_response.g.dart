// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatResponse _$ChatResponseFromJson(Map<String, dynamic> json) =>
    _ChatResponse(
      responseType: json['responseType'] as String,
      message: json['message'] as String,
      proposedActionId: json['proposedActionId'] as String?,
      beforeActionId: json['beforeActionId'] as String?,
    );

Map<String, dynamic> _$ChatResponseToJson(_ChatResponse instance) =>
    <String, dynamic>{
      'responseType': instance.responseType,
      'message': instance.message,
      'proposedActionId': instance.proposedActionId,
      'beforeActionId': instance.beforeActionId,
    };
