import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_checkin.freezed.dart';
part 'daily_checkin.g.dart';

@freezed
abstract class DailyCheckin with _$DailyCheckin {
  const factory DailyCheckin({
    required DateTime logDate,
    required int availableMinutes,
    String? conditionInferred,  // good|normal|tired — 서버가 먼저 추론
    String? conditionFinal,     // 사용자가 정정했으면 값 존재
    bool? conditionAccepted,    // 추론을 그대로 받아들였는지
    String? focusArea,          // sleep|hydration|move|focus|meal
    @Default(false) bool isRestDay,
  }) = _DailyCheckin;

  factory DailyCheckin.fromJson(Map<String, dynamic> json) => _$DailyCheckinFromJson(json);

  // 버튼 3개(10분이하/20분/30분이상) → 실제 전송값 매핑, 백엔드와 대표값 합의 필요
  static int minutesFromBucket(String bucket) => switch (bucket) {
        '10분 이하' => 10,
        '20분' => 20,
        '30분 이상' => 30,
        _ => 10,
      };
}