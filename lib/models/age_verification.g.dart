// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'age_verification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AgeVerificationRequest _$AgeVerificationRequestFromJson(
  Map<String, dynamic> json,
) => _AgeVerificationRequest(
  birthDate: DateTime.parse(json['birthDate'] as String),
);

Map<String, dynamic> _$AgeVerificationRequestToJson(
  _AgeVerificationRequest instance,
) => <String, dynamic>{'birthDate': instance.birthDate.toIso8601String()};

_AgeVerificationResult _$AgeVerificationResultFromJson(
  Map<String, dynamic> json,
) => _AgeVerificationResult(
  eligible: json['eligible'] as bool,
  ageConfirmedAt: json['ageConfirmedAt'] == null
      ? null
      : DateTime.parse(json['ageConfirmedAt'] as String),
);

Map<String, dynamic> _$AgeVerificationResultToJson(
  _AgeVerificationResult instance,
) => <String, dynamic>{
  'eligible': instance.eligible,
  'ageConfirmedAt': instance.ageConfirmedAt?.toIso8601String(),
};
