import "package:flutter_riverpod/flutter_riverpod.dart";
import "../models/environment_data.dart";
import "../repository/providers.dart";

/// 홈 화면 날씨/대기질 위젯용 FutureProvider.
/// 에러 시 UI가 조용히 숨기도록(degraded behavior) autoDispose로 운영한다.
final environmentProvider =
    FutureProvider.autoDispose<EnvironmentData>((ref) async {
  final repo = ref.watch(ensomRepositoryProvider);
  return repo.getEnvironment();
});
