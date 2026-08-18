import "package:freezed_annotation/freezed_annotation.dart";

part "wellness_pref.freezed.dart";
part "wellness_pref.g.dart";

/// PRD §14.7 "재알림 주기는 서비스가 정하지 않고 사용자가 직접 설정한다".
/// GET/PATCH /me/wellness-prefs.
///
/// API 명세 §4.2 wellnessTopic: uv | pm | temp | rain | hydration
@freezed
abstract class WellnessPref with _$WellnessPref {
  const factory WellnessPref({
    /// API 명세 §4.2 필드명: "wellnessTopic"
    /// Dart에서는 topic으로 사용하되 JSON 직렬화 시 wellnessTopic으로 매핑.
    @JsonKey(name: "wellnessTopic") required String topic,
    required bool isEnabled,
    /// null 허용 — API 응답에서 설정하지 않은 항목은 null로 내려올 수 있음.
    @JsonKey(name: "remindIntervalMinutes") int? remindIntervalMinutes,
    @Default(1) int dailyEventCap,
  }) = _WellnessPref;

  factory WellnessPref.fromJson(Map<String, dynamic> json) =>
      _$WellnessPrefFromJson(json);
}
