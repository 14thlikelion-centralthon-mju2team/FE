import "package:flutter_riverpod/flutter_riverpod.dart";
import "ensom_repository.dart";
import "api_ensom_repository.dart";
import "../network/api_client.dart";
import "../core/secure_storage_service.dart";

/// 실제 API 연동 리포지토리.
/// SecureStorageService → ApiClient → ApiEnsomRepository 체인.
final _secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

final _apiClientProvider = Provider<ApiClient>((ref) {
  final secureStorage = ref.watch(_secureStorageProvider);
  return ApiClient(
    baseUrl: "https://api.ensom.app/v1",
    secureStorage: secureStorage,
  );
});

final ensomRepositoryProvider = Provider<EnsomRepository>((ref) {
  final apiClient = ref.watch(_apiClientProvider);
  return ApiEnsomRepository(apiClient);
});
