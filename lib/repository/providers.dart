import "package:flutter_riverpod/flutter_riverpod.dart";
import "ensom_repository.dart";
import "api_ensom_repository.dart";
import "../providers/auth_providers.dart";

/// 실제 API 연동 리포지토리.
/// auth_providers.dart의 apiClientProvider를 의존해서
/// 동일한 ApiClient(동일한 SecureStorage 세션)를 공유한다.
final ensomRepositoryProvider = Provider<EnsomRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ApiEnsomRepository(apiClient);
});
