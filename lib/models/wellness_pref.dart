import "package:freezed_annotation/freezed_annotation.dart";

part "wellness_pref.freezed.dart";
part "wellness_pref.g.dart";

/// PRD §14.7 "재알림 주기는 서비스가 정하지 않고 사용자가 직접 설정한다".
/// GET/PATCH /me/wellness-prefs.
///
/// API 명세 §4.2 wellnessTopic: uv | pm | temp | rain | hydration
/// (이전 버전의 heat/precipitation은 폐기됨 — API v5.0 정합성 수정)
@freezed
abstract class WellnessPref with _$WellnessPref {
  const factory WellnessPref({
    /// API 명세 §4.2: "uv" | "pm" | "temp" | "rain" | "hydration"
    required String topic,
    required bool isEnabled,
    required int remindIntervalMinutes,
    @Default(1) int dailyEventCap,
  }) = _WellnessPref;

  factory WellnessPref.fromJson(Map<String, dynamic> json) =>
      _$WellnessPrefFromJson(json);
}
