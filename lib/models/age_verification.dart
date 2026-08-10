import 'package:freezed_annotation/freezed_annotation.dart';

part 'age_verification.freezed.dart';
part 'age_verification.g.dart';

// 요청 — birthDate는 이 요청 안에서만 쓰이고 클라이언트 상태에 남기지 않는다
@freezed
abstract class AgeVerificationRequest with _$AgeVerificationRequest {
  const factory AgeVerificationRequest({
    required DateTime birthDate,
  }) = _AgeVerificationRequest;

  factory AgeVerificationRequest.fromJson(Map<String, dynamic> json) =>
      _$AgeVerificationRequestFromJson(json);
}

@freezed
abstract class AgeVerificationResult with _$AgeVerificationResult {
  const factory AgeVerificationResult({
    required bool eligible, // 만 14세 이상이면 true
    DateTime? ageConfirmedAt, // 서버가 찍어준 확인 시각 (성공 시에만)
  }) = _AgeVerificationResult;

  factory AgeVerificationResult.fromJson(Map<String, dynamic> json) =>
      _$AgeVerificationResultFromJson(json);
}