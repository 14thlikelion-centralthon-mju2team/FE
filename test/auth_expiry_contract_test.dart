import "dart:async";
import "dart:io";

import "package:ensom/core/auth_service.dart";
import "package:ensom/core/secure_storage_service.dart";
import "package:ensom/network/api_client.dart";
import "package:ensom/providers/auth_providers.dart";
import "package:flutter_test/flutter_test.dart";
import "package:http/http.dart" as http;
import "package:http/testing.dart";

void main() {
  group("terminal auth expiry propagation", () {
    test(
      "refresh rejection clears session and draft, then unauthenticates",
      () async {
        final harness = await _createHarness(
          MockClient((request) async {
            if (request.url.path.endsWith("/auth/refresh")) {
              return http.Response("{}", 401);
            }
            return http.Response("{}", 401);
          }),
        );
        addTearDown(harness.dispose);

        await expectLater(
          harness.apiClient.get<Map<String, dynamic>>("/protected"),
          throwsA(
            isA<ApiException>()
                .having((error) => error.isAuthExpired, "isAuthExpired", isTrue)
                .having((error) => error.retryable, "retryable", isFalse),
          ),
        );

        expect(harness.notifier.state.status, AuthStatus.unauthenticated);
        expect(harness.storage.clearSessionCount, 1);
        expect(harness.draftClearCount, 1);
      },
    );

    test("401 after successful refresh is also terminal", () async {
      final harness = await _createHarness(
        MockClient((request) async {
          if (request.url.path.endsWith("/auth/refresh")) {
            return http.Response(
              '{"data":{"accessToken":"renewed-access-token"}}',
              200,
            );
          }
          return http.Response("{}", 401);
        }),
      );
      addTearDown(harness.dispose);

      await expectLater(
        harness.apiClient.get<Map<String, dynamic>>("/protected"),
        throwsA(
          isA<ApiException>().having(
            (error) => error.isAuthExpired,
            "isAuthExpired",
            isTrue,
          ),
        ),
      );

      expect(harness.notifier.state.status, AuthStatus.unauthenticated);
      expect(harness.storage.clearSessionCount, 1);
      expect(harness.draftClearCount, 1);
    });

    test("refresh network failure keeps auth state and draft", () async {
      final harness = await _createHarness(
        MockClient((request) async {
          if (request.url.path.endsWith("/auth/refresh")) {
            throw const SocketException("offline");
          }
          return http.Response("{}", 401);
        }),
      );
      addTearDown(harness.dispose);

      await expectLater(
        harness.apiClient.get<Map<String, dynamic>>("/protected"),
        throwsA(
          isA<ApiException>()
              .having((error) => error.isNetworkError, "isNetworkError", isTrue)
              .having((error) => error.retryable, "retryable", isTrue),
        ),
      );

      expect(harness.notifier.state.status, AuthStatus.consentRequired);
      expect(harness.storage.clearSessionCount, 0);
      expect(harness.draftClearCount, 0);
    });
  });
}

Future<_Harness> _createHarness(MockClient httpClient) async {
  final storage = _MemorySecureStorage();
  final apiClient = ApiClient(
    baseUrl: "https://api.ensom.test/v1",
    secureStorage: storage,
    httpClient: httpClient,
  );
  final authService = _ConsentAuthService(
    apiClient: apiClient,
    secureStorage: storage,
  );
  final initialDraftClear = Completer<void>();
  var draftClearCount = 0;
  final notifier = AuthNotifier(
    authService: authService,
    secureStorage: storage,
    apiClient: apiClient,
    clearMapDraft: () async {
      draftClearCount++;
      if (!initialDraftClear.isCompleted) initialDraftClear.complete();
    },
    disposeFcm: () {},
  );

  // 생성 시 세션 없음 검사를 끝낸 뒤 실행 중 로그인 상태를 만든다.
  await initialDraftClear.future;
  await Future<void>.delayed(Duration.zero);
  draftClearCount = 0;
  storage
    ..accessTokenValue = "access-token"
    ..refreshTokenValue = "refresh-token";
  await notifier.loginWithEmail(
    email: "user@example.com",
    password: "password",
  );
  apiClient.setAuthExpiredHandler(notifier.onTerminalAuthExpired);

  return _Harness(
    apiClient: apiClient,
    notifier: notifier,
    storage: storage,
    getDraftClearCount: () => draftClearCount,
  );
}

class _Harness {
  _Harness({
    required this.apiClient,
    required this.notifier,
    required this.storage,
    required int Function() getDraftClearCount,
  }) : _getDraftClearCount = getDraftClearCount;

  final ApiClient apiClient;
  final AuthNotifier notifier;
  final _MemorySecureStorage storage;
  final int Function() _getDraftClearCount;

  int get draftClearCount => _getDraftClearCount();

  void dispose() {
    apiClient.setAuthExpiredHandler(null);
    notifier.dispose();
  }
}

class _ConsentAuthService extends AuthService {
  _ConsentAuthService({required super.apiClient, required super.secureStorage});

  @override
  Future<LoginResult> loginWithEmail({
    required String email,
    required String password,
    String? installationId,
  }) async {
    return const LoginResult(
      userId: "user-1",
      nickname: "tester",
      timezone: "Asia/Seoul",
      isNew: false,
      emailVerificationRequired: false,
      consentRequired: ["terms"],
    );
  }
}

class _MemorySecureStorage extends SecureStorageService {
  String? accessTokenValue;
  String? refreshTokenValue;
  int clearSessionCount = 0;

  @override
  Future<String?> get accessToken async => accessTokenValue;

  @override
  Future<String?> get refreshToken async => refreshTokenValue;

  @override
  Future<bool> get hasSession async => accessTokenValue != null;

  @override
  Future<void> clearSession() async {
    clearSessionCount++;
    accessTokenValue = null;
    refreshTokenValue = null;
  }

  @override
  Future<void> updateAccessToken(String accessToken) async {
    accessTokenValue = accessToken;
  }
}
