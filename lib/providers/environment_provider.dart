import "package:flutter_riverpod/flutter_riverpod.dart";
import "../models/environment_data.dart";
import "../repository/providers.dart";

/// 홈 화면 날씨/대기질 위젯용 FutureProvider.
/// 에러 시 UI가 조용히 숨기도록(degraded behavior) autoDispose로 운영한다.
/// BE에 /environment/current 엔드포인트가 아직 없으므로(API v5.0 미포함)
/// 모든 예외를 삼키고 null을 반환한다 — WeatherWidget은 null이면 숨긴다.
final environmentProvider =
    FutureProvider.autoDispose<EnvironmentData?>((ref) async {
  final repo = ref.watch(ensomRepositoryProvider);
  try {
    return await repo.getEnvironment();
  } catch (_) {
    // 404 등 모든 오류 → null → WeatherWidget 비표시
    return null;
  }
});
