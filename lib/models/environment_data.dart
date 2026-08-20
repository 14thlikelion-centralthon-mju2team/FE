import "package:freezed_annotation/freezed_annotation.dart";

part "environment_data.freezed.dart";
part "environment_data.g.dart";

/// 홈 화면 날씨/환경 위젯용 모델.
/// BE의 GET /environment/current 응답에 대응한다 (AirKorea + KMA 통합).
@freezed
abstract class EnvironmentData with _$EnvironmentData {
  const factory EnvironmentData({
    int? temperature,
    String? sky, // 맑음, 구름많음, 흐림
    String? pm10Grade, // 좋음, 보통, 나쁨, 매우나쁨
    String? pm25Grade, // 좋음, 보통, 나쁨, 매우나쁨
    int? uvIndex,
  }) = _EnvironmentData;

  factory EnvironmentData.fromJson(Map<String, dynamic> json) =>
      _$EnvironmentDataFromJson(json);
}
