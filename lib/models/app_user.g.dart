// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppUser _$AppUserFromJson(Map<String, dynamic> json) => _AppUser(
  id: json['id'] as String,
  provider: json['provider'] as String,
  email: json['email'] as String,
  nickname: json['nickname'] as String,
  timezone: json['timezone'] as String,
  ageConfirmedAt: json['ageConfirmedAt'] == null
      ? null
      : DateTime.parse(json['ageConfirmedAt'] as String),
);

Map<String, dynamic> _$AppUserToJson(_AppUser instance) => <String, dynamic>{
  'id': instance.id,
  'provider': instance.provider,
  'email': instance.email,
  'nickname': instance.nickname,
  'timezone': instance.timezone,
  'ageConfirmedAt': instance.ageConfirmedAt?.toIso8601String(),
};
