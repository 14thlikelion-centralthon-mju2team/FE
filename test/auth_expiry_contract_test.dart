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

    test("cleanup failures do not mask terminal transition", () async {
      final harness = await _createHarness(
        MockClient((request) async => http.Response("{}", 401)),
        failSessionCleanup: true,
        failDraftCleanup: true,
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
      expect(harness.fcmDisposeCount, 1);
    });

    test("concurrent terminal responses run cleanup only once", () async {
      final harness = await _createHarness(
        MockClient((request) async => http.Response("{}", 401)),
      );
      addTearDown(harness.dispose);

      final results = await Future.wait(
        [
          harness.apiClient.get<Map<String, dynamic>>("/protected/a"),
          harness.apiClient.get<Map<String, dynamic>>("/protected/b"),
        ].map((request) async {
          try {
            await request;
            return "success";
          } on ApiException catch (error) {
            return error.code;
          }
        }),
      );

      expect(results, everyElement(anyOf("UNAUTHORIZED", "STALE_SESSION")));
      expect(harness.storage.clearSessionCount, 1);
      expect(harness.draftClearCount, 1);
      expect(harness.fcmDisposeCount, 1);
      expect(harness.notifier.state.status, AuthStatus.unauthenticated);
    });
  });

  group("session generation boundaries", () {
    test("public login 401 preserves the server auth error", () async {
      var refreshCalls = 0;
      var expiryCalls = 0;
      final storage = _MemorySecureStorage();
      final client = ApiClient(
        baseUrl: "https://api.ensom.test/v1",
        secureStorage: storage,
        onAuthExpired: (_) async => expiryCalls++,
        httpClient: MockClient((request) async {
          if (request.url.path.endsWith("/auth/refresh")) refreshCalls++;
          expect(request.headers.containsKey("Authorization"), isFalse);
          return http.Response(
            '{"error":{"code":"AUTH_INVALID_CREDENTIALS","message":"invalid","retryable":false}}',
            401,
          );
        }),
      );

      await expectLater(
        client.postPublic<Map<String, dynamic>>(
          "/auth/email/login",
          body: {"email": "user@example.com", "password": "wrong"},
        ),
        throwsA(
          isA<ApiException>()
              .having((error) => error.code, "code", "AUTH_INVALID_CREDENTIALS")
              .having((error) => error.statusCode, "statusCode", 401),
        ),
      );
      expect(refreshCalls, 0);
      expect(expiryCalls, 0);
    });

    test(
      "a delayed request from user A cannot refresh or clear user B",
      () async {
        final storage = _MemorySecureStorage()
          ..accessTokenValue = "access-a"
          ..refreshTokenValue = "refresh-a"
          ..userIdValue = "user-a";
        final responseGate = Completer<http.Response>();
        final requestStarted = Completer<void>();
        var refreshCalls = 0;
        var expiryCalls = 0;
        final client = ApiClient(
          baseUrl: "https://api.ensom.test/v1",
          secureStorage: storage,
          onAuthExpired: (_) async => expiryCalls++,
          httpClient: MockClient((request) async {
            if (request.url.path.endsWith("/auth/refresh")) {
              refreshCalls++;
              return http.Response("{}", 401);
            }
            requestStarted.complete();
            return responseGate.future;
          }),
        );

        final staleRequest = client.post<Map<String, dynamic>>(
          "/protected",
          body: {"owner": "user-a"},
        );
        await requestStarted.future;

        client.beginSessionTransition();
        await client.saveSession(
          accessToken: "access-b",
          refreshToken: "refresh-b",
          userId: "user-b",
        );
        responseGate.complete(http.Response("{}", 401));

        await expectLater(
          staleRequest,
          throwsA(
            isA<ApiException>().having(
              (error) => error.code,
              "code",
              "STALE_SESSION",
            ),
          ),
        );
        expect(refreshCalls, 0);
        expect(expiryCalls, 0);
        expect(storage.accessTokenValue, "access-b");
        expect(storage.refreshTokenValue, "refresh-b");
        expect(storage.userIdValue, "user-b");
      },
    );

    test(
      "terminal expiry disposes FCM and relogin initializes it again",
      () async {
        final storage = _MemorySecureStorage();
        final apiClient = ApiClient(
          baseUrl: "https://api.ensom.test/v1",
          secureStorage: storage,
          httpClient: MockClient((request) async => http.Response("{}", 200)),
        );
        final initialDraftClear = Completer<void>();
        var initializeCount = 0;
        var disposeCount = 0;
        final notifier = AuthNotifier(
          authService: _AuthenticatedAuthService(apiClient: apiClient),
          secureStorage: storage,
          apiClient: apiClient,
          clearMapDraft: () async {
            if (!initialDraftClear.isCompleted) initialDraftClear.complete();
          },
          initializeFcm: (_, _) async => initializeCount++,
          disposeFcm: () async => disposeCount++,
        );
        addTearDown(notifier.dispose);
        await initialDraftClear.future;

        storage
          ..accessTokenValue = "access-a"
          ..refreshTokenValue = "refresh-a"
          ..userIdValue = "user-a";
        await notifier.loginWithEmail(
          email: "a@example.com",
          password: "password",
        );
        await Future<void>.delayed(Duration.zero);
        expect(initializeCount, 1);

        final expiredGeneration = apiClient.sessionGeneration;
        await notifier.onTerminalAuthExpired(expiredGeneration);
        expect(disposeCount, 1);
        expect(notifier.state.status, AuthStatus.unauthenticated);

        storage
          ..accessTokenValue = "access-b"
          ..refreshTokenValue = "refresh-b"
          ..userIdValue = "user-b";
        await notifier.loginWithEmail(
          email: "b@example.com",
          password: "password",
        );
        await Future<void>.delayed(Duration.zero);
        expect(initializeCount, 2);
        expect(notifier.state.status, AuthStatus.authenticated);
      },
    );
  });
}

Future<_Harness> _createHarness(
  MockClient httpClient, {
  bool failSessionCleanup = false,
  bool failDraftCleanup = false,
}) async {
  final storage = _MemorySecureStorage();
  final apiClient = ApiClient(
    baseUrl: "https://api.ensom.test/v1",
    secureStorage: storage,
    httpClient: httpClient,
  );
  final authService = _ConsentAuthService(apiClient: apiClient);
  final initialDraftClear = Completer<void>();
  var draftClearCount = 0;
  var shouldFailDraftCleanup = false;
  var fcmDisposeCount = 0;
  final notifier = AuthNotifier(
    authService: authService,
    secureStorage: storage,
    apiClient: apiClient,
    clearMapDraft: () async {
      draftClearCount++;
      if (!initialDraftClear.isCompleted) initialDraftClear.complete();
      if (shouldFailDraftCleanup) throw StateError("draft cleanup failed");
    },
    disposeFcm: () async {
      fcmDisposeCount++;
    },
  );

  // 생성 시 세션 없음 검사를 끝낸 뒤 실행 중 로그인 상태를 만든다.
  await initialDraftClear.future;
  await Future<void>.delayed(Duration.zero);
  draftClearCount = 0;
  shouldFailDraftCleanup = failDraftCleanup;
  storage
    ..accessTokenValue = "access-token"
    ..refreshTokenValue = "refresh-token"
    ..userIdValue = "user-1"
    ..failClearSession = failSessionCleanup;
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
    getFcmDisposeCount: () => fcmDisposeCount,
  );
}

class _Harness {
  _Harness({
    required this.apiClient,
    required this.notifier,
    required this.storage,
    required int Function() getDraftClearCount,
    required int Function() getFcmDisposeCount,
  }) : _getDraftClearCount = getDraftClearCount,
       _getFcmDisposeCount = getFcmDisposeCount;

  final ApiClient apiClient;
  final AuthNotifier notifier;
  final _MemorySecureStorage storage;
  final int Function() _getDraftClearCount;
  final int Function() _getFcmDisposeCount;

  int get draftClearCount => _getDraftClearCount();
  int get fcmDisposeCount => _getFcmDisposeCount();

  void dispose() {
    apiClient.setAuthExpiredHandler(null);
    notifier.dispose();
  }
}

class _AuthenticatedAuthService extends AuthService {
  _AuthenticatedAuthService({required super.apiClient});

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
      consentRequired: [],
    );
  }
}

class _ConsentAuthService extends AuthService {
  _ConsentAuthService({required super.apiClient});

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
  String? userIdValue;
  int clearSessionCount = 0;
  bool failClearSession = false;

  @override
  Future<String?> get accessToken async => accessTokenValue;

  @override
  Future<String?> get refreshToken async => refreshTokenValue;

  @override
  Future<String?> get userId async => userIdValue;

  @override
  Future<String> get installationId async => "installation-1";

  @override
  Future<bool> get hasSession async => accessTokenValue != null;

  @override
  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    required String userId,
  }) async {
    accessTokenValue = accessToken;
    refreshTokenValue = refreshToken;
    userIdValue = userId;
  }

  @override
  Future<void> clearSession() async {
    clearSessionCount++;
    if (failClearSession) throw StateError("session cleanup failed");
    accessTokenValue = null;
    refreshTokenValue = null;
    userIdValue = null;
  }

  @override
  Future<void> updateAccessToken(String accessToken) async {
    accessTokenValue = accessToken;
  }
}
