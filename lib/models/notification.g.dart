// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppNotification _$AppNotificationFromJson(Map<String, dynamic> json) =>
    _AppNotification(
      notificationId: json['notificationId'] as String,
      notificationClass: $enumDecode(
        _$NotificationClassEnumMap,
        json['notificationClass'],
      ),
      slot: json['slot'] as String,
      sentAt: DateTime.parse(json['sentAt'] as String),
      message: json['message'] as String,
      reaction: json['reaction'] as String?,
    );

Map<String, dynamic> _$AppNotificationToJson(
  _AppNotification instance,
) => <String, dynamic>{
  'notificationId': instance.notificationId,
  'notificationClass': _$NotificationClassEnumMap[instance.notificationClass]!,
  'slot': instance.slot,
  'sentAt': instance.sentAt.toIso8601String(),
  'message': instance.message,
  'reaction': instance.reaction,
};

const _$NotificationClassEnumMap = {
  NotificationClass.time: 'time',
  NotificationClass.wellness: 'wellness',
};
