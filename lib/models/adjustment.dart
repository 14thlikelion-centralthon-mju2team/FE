import 'package:freezed_annotation/freezed_annotation.dart';

part 'adjustment.freezed.dart';
part 'adjustment.g.dart';

@freezed
abstract class Adjustment with _$Adjustment {
  const factory Adjustment({
    required String routineTaskId,
    required String beforeActionId,
    required String afterActionId,
    required String triggerType, // red_signal | streak_up | user_manual
    required String reason,      // 사용자에게 그대로 노출되는 문장
  }) = _Adjustment;

  factory Adjustment.fromJson(Map<String, dynamic> json) => _$AdjustmentFromJson(json);
}