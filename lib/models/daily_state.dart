import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_state.freezed.dart';
part 'daily_state.g.dart';

@freezed
abstract class DailyState with _$DailyState {
  const factory DailyState({
    required DateTime runDate,
    required int doneCount,
    required int expectedCount,
    required double completionRate,
    required String signal, // green | yellow | red — gray 없음
  }) = _DailyState;

  factory DailyState.fromJson(Map<String, dynamic> json) => _$DailyStateFromJson(json);
}