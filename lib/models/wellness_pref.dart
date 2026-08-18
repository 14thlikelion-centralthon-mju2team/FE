import "package:freezed_annotation/freezed_annotation.dart";

part "wellness_pref.freezed.dart";
part "wellness_pref.g.dart";

/// PRD §14.7 "재알림 주기는 서비스가 정하지 않고 사용자가 직접
/// 설정한다". GET/PATCH /me/wellness-prefs.
@freezed
abstract class WellnessPref with _$WellnessPref {
  const factory WellnessPref({
    required String topic, // uv | pm | heat | precipitation | hydration
    required bool isEnabled,
    required int remindIntervalMinutes,
    @Default(1) int dailyEventCap,
  }) = _WellnessPref;

  factory WellnessPref.fromJson(Map<String, dynamic> json) =>
      _$WellnessPrefFromJson(json);
}