import "package:flutter_secure_storage/flutter_secure_storage.dart";

/// M0 "Secure Storage 세션 관리" 항목.
/// accessToken/refreshToken을 평문 저장하지 않고 Keychain(iOS)/
/// EncryptedSharedPreferences(Android)에 저장한다.
///
/// 가정: pubspec.yaml에 flutter_secure_storage가 없다면 추가 필요.
///   dependencies:
///     flutter_secure_storage: ^9.0.0
class SecureStorageService {
  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _kAccessToken = "access_token";
  static const _kRefreshToken = "refresh_token";
  static const _kUserId = "user_id";

  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    required String userId,
  }) async {
    await Future.wait([
      _storage.write(key: _kAccessToken, value: accessToken),
      _storage.write(key: _kRefreshToken, value: refreshToken),
      _storage.write(key: _kUserId, value: userId),
    ]);
  }

  Future<String?> get accessToken => _storage.read(key: _kAccessToken);
  Future<String?> get refreshToken => _storage.read(key: _kRefreshToken);
  Future<String?> get userId => _storage.read(key: _kUserId);

  Future<bool> get hasSession async => (await accessToken) != null;

  /// 로그아웃 시 전체 소거. TRD §14.3 "로그아웃 시 로컬 민감 데이터 제거"
  /// 원칙에 따라 세션뿐 아니라 이 서비스가 관리하는 모든 키를 지운다.
  /// 준비 항목·장소 캐시 등 다른 민감 캐시(Hive)는 이 서비스 책임이
  /// 아니므로, 로그아웃 흐름에서 별도로 같이 호출해야 한다.
  Future<void> clearSession() async {
    await Future.wait([
      _storage.delete(key: _kAccessToken),
      _storage.delete(key: _kRefreshToken),
      _storage.delete(key: _kUserId),
    ]);
  }

  /// access token 갱신 시 refresh는 유지하고 access만 교체.
  Future<void> updateAccessToken(String accessToken) async {
    await _storage.write(key: _kAccessToken, value: accessToken);
  }
}