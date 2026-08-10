// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserEvent _$UserEventFromJson(Map<String, dynamic> json) => _UserEvent(
  title: json['title'] as String?,
  startsAt: DateTime.parse(json['startsAt'] as String),
  endsAt: DateTime.parse(json['endsAt'] as String),
  placeText: json['placeText'] as String?,
);

Map<String, dynamic> _$UserEventToJson(_UserEvent instance) =>
    <String, dynamic>{
      'title': instance.title,
      'startsAt': instance.startsAt.toIso8601String(),
      'endsAt': instance.endsAt.toIso8601String(),
      'placeText': instance.placeText,
    };
