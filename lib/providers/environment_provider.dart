import "package:flutter_riverpod/flutter_riverpod.dart";
import "../models/environment_data.dart";

/// 홈 화면 날씨/대기질 위젯용 FutureProvider.
/// 운영 BE 0f76b40에는 /environment/current 계약이 없으므로 호출하지 않고
/// null을 반환한다. WeatherWidget은 null일 때 비노출되며, BE 계약이
/// 확정될 때 이 provider에서만 API 연결을 재개한다.
final environmentProvider = FutureProvider.autoDispose<EnvironmentData?>(
  (ref) async => null,
);
