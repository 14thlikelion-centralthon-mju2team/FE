import 'package:freezed_annotation/freezed_annotation.dart';

part 'health_checkup.freezed.dart';
part 'health_checkup.g.dart';

@freezed
abstract class HealthCheckup with _$HealthCheckup {
  const factory HealthCheckup({
    required DateTime measuredOn,
    required Map<String, dynamic> data, // jsonb라 항목이 유동적, 화면에서 키 순회해서 렌더링
  }) = _HealthCheckup;

  factory HealthCheckup.fromJson(Map<String, dynamic> json) => _$HealthCheckupFromJson(json);
}