import "dart:async";

import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_riverpod/legacy.dart";
import "../core/auth_service.dart";
import "../core/fcm_service.dart";
import "../core/secure_storage_service.dart";
import "../network/api_client.dart";
import "map_providers.dart";

/// 앱 전역 싱글턴 — 앱 라이프사이클 동안 유지
final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return ApiClient(
    baseUrl: "https://api.ensom.app/v1",
    secureStorage: secureStorage,
  );
});

final authServiceProvider = Provider<AuthService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthService(apiClient: apiClient);
});

/// 인증 상태 — 앱 전체에서 로그인 여부, 온보딩 완료 여부를 추적한다.
/// 라우터 리다이렉트의 판단 기준.
enum AuthStatus {
  unknown, // 초기 상태 (세션 확인 중)
  sessionCheckFailed, // 기존 세션 검증 중 네트워크 오류
  unauthenticated, // 세션 없음
  emailVerificationRequired, // 로그인됨 but 이메일 미인증
  consentRequired, // 로그인됨 but 약관 미동의
  onboarding, // 신규 사용자 온보딩 진행 중
  authenticated, // 정상 로그인 완료
}

class AuthState {
  const AuthState({
    required this.status,
    this.userId,
    this.email,
    this.consentRequired = const [],
    this.onboardingRequired = false,
    this.onboardingStep,
    this.errorMessage,
  });

  final AuthStatus status;
  final String? userId;
  final String? email;
  final List<String> consentRequired;
  final bool onboardingRequired;
  final String? onboardingStep;
  final String? errorMessage;

  static const initial = AuthState(status: AuthStatus.unknown);
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier({
    required this.authService,
    required this.secureStorage,
    required this.apiClient,
    required this.clearMapDraft,
    Future<void> Function(ApiClient apiClient, String installationId)?
    initializeFcm,
    Future<void> Function()? disposeFcm,
  }) : _initializeFcm =
           initializeFcm ??
           ((apiClient, installationId) => FcmService.instance.initialize(
             apiClient: apiClient,
             installationId: installationId,
           )),
       _disposeFcm = disposeFcm ?? FcmService.instance.dispose,
       super(AuthState.initial) {
    _sessionCheckCompletion = _checkExistingSession();
  }

  final AuthService authService;
  final SecureStorageService secureStorage;
  final ApiClient apiClient;
  final Future<void> Function() clearMapDraft;
  final Future<void> Function(ApiClient apiClient, String installationId)
  _initializeFcm;
  final Future<void> Function() _disposeFcm;
  int? _terminalSourceGeneration;
  Future<void>? _terminalAuthExpiryFuture;
  Future<void> _sessionCheckCompletion = Future<void>.value();

  /// 생성자 또는 retry가 시작한 최신 bootstrap 검사의 실제 완료 Future.
  Future<void> get sessionCheckCompletion => _sessionCheckCompletion;

  /// 앱 시작 시 기존 세션을 서버에서 검증한다.
  Future<void> _checkExistingSession() async {
    final checkGeneration = apiClient.sessionGeneration;
    state = const AuthState(status: AuthStatus.unknown);
    final hasToken = await secureStorage.hasSession;
    if (!apiClient.isCurrentSessionGeneration(checkGeneration)) return;
    if (!hasToken) {
      await clearMapDraft();
      if (apiClient.isCurrentSessionGeneration(checkGeneration)) {
        state = const AuthState(status: AuthStatus.unauthenticated);
      }
      return;
    }

    final bootstrapGeneration = apiClient.sessionGeneration;
    try {
      // refresh가 필요하면 ApiClient가 처리한다. 세션 검사 네트워크 실패와
      // 인증 실패를 구분하기 위해 실제 인증 필요 API를 호출한다.
      await apiClient.get<Map<String, dynamic>>("/me/bootstrap");
      if (!apiClient.isCurrentSessionGeneration(bootstrapGeneration)) return;
      final isOnboardingDone = await secureStorage.onboardingCompleted;
      if (!apiClient.isCurrentSessionGeneration(bootstrapGeneration)) return;
      if (!isOnboardingDone) {
        final step = await secureStorage.onboardingStep;
        if (!apiClient.isCurrentSessionGeneration(bootstrapGeneration)) return;
        state = AuthState(
          status: AuthStatus.onboarding,
          onboardingRequired: true,
          onboardingStep: step,
        );
        _syncFcm();
        return;
      }
      state = const AuthState(status: AuthStatus.authenticated);
      _syncFcm();
    } on ApiException catch (e) {
      if (!apiClient.isCurrentSessionGeneration(bootstrapGeneration) ||
          e.code == "STALE_SESSION") {
        return;
      }
      if (e.isNetworkError || e.retryable) {
        state = const AuthState(
          status: AuthStatus.sessionCheckFailed,
          errorMessage: "네트워크에 연결할 수 없어요. 연결을 확인하고 다시 시도해주세요.",
        );
        return;
      }
      if (e.code == "EMAIL_VERIFICATION_REQUIRED") {
        state = const AuthState(status: AuthStatus.emailVerificationRequired);
        return;
      }
      if (e.isAuthExpired && state.status == AuthStatus.unauthenticated) {
        return;
      }
      await onTerminalAuthExpired(bootstrapGeneration);
    } catch (_) {
      if (!apiClient.isCurrentSessionGeneration(bootstrapGeneration)) return;
      state = const AuthState(
        status: AuthStatus.sessionCheckFailed,
        errorMessage: "세션을 확인하지 못했어요. 잠시 후 다시 시도해주세요.",
      );
    }
  }

  Future<void> retrySessionCheck() {
    final completion = _checkExistingSession();
    _sessionCheckCompletion = completion;
    return completion;
  }

  /// main.dart가 Firebase.initializeApp() + 백그라운드 핸들러 등록까지는
  /// 이미 해 뒀다. 로그인 이후 단계(권한 요청, 토큰 획득, POST
  /// /push-devices 등록)는 apiClient가 있어야 하므로 여기서 이어 붙인다.
  void _syncFcm() {
    final generation = apiClient.sessionGeneration;
    unawaited(() async {
      final installationId = await secureStorage.installationId;
      if (!apiClient.isCurrentSessionGeneration(generation)) return;
      await _initializeFcm(apiClient, installationId);
    }());
  }

  int _beginLoginTransition() {
    final generation = apiClient.beginSessionTransition();
    _terminalSourceGeneration = null;
    _terminalAuthExpiryFuture = null;
    return generation;
  }

  /// 이메일 가입 성공 — BE는 token을 발급하지 않고 인증 메일을 보낸다.
  /// 인증 링크를 연 뒤 사용자가 로그인하면 BE가 access/refresh token을 발급한다.
  Future<SignupResult> signupWithEmail({
    required String email,
    required String password,
  }) async {
    final result = await authService.signupWithEmail(
      email: email,
      password: password,
    );
    state = AuthState(
      status: AuthStatus.emailVerificationRequired,
      userId: result.userId,
      email: result.email,
    );
    return result;
  }

  /// 이메일 로그인 성공
  Future<void> loginWithEmail({
    required String email,
    required String password,
    String? installationId,
  }) async {
    final loginGeneration = _beginLoginTransition();
    try {
      final result = await authService.loginWithEmail(
        email: email,
        password: password,
        expectedGeneration: loginGeneration,
        installationId: installationId,
      );
      _handleLoginResult(
        result,
        expectedGeneration: loginGeneration,
        email: email,
      );
    } catch (_) {
      await _bestEffort(
        () => apiClient.clearSession(expectedGeneration: loginGeneration),
      );
      rethrow;
    }
  }

  /// Google 로그인 성공
  Future<void> loginWithGoogle({
    required String idToken,
    required String installationId,
  }) async {
    final loginGeneration = _beginLoginTransition();
    try {
      final result = await authService.loginWithGoogle(
        idToken: idToken,
        installationId: installationId,
        expectedGeneration: loginGeneration,
      );
      _handleLoginResult(result, expectedGeneration: loginGeneration);
    } catch (_) {
      await _bestEffort(
        () => apiClient.clearSession(expectedGeneration: loginGeneration),
      );
      rethrow;
    }
  }

  /// 약관 동의 완료 후 신규 사용자는 온보딩을 이어가고, 약관 개정에
  /// 동의한 기존 사용자는 정상 로그인 상태로 돌아간다.
  void onConsentCompleted() {
    state = AuthState(
      status: state.onboardingRequired
          ? AuthStatus.onboarding
          : AuthStatus.authenticated,
      userId: state.userId,
      onboardingRequired: state.onboardingRequired,
    );
    _syncFcm();
  }

  void onOnboardingCompleted() {
    secureStorage.setOnboardingCompleted(true);
    state = AuthState(status: AuthStatus.authenticated, userId: state.userId);
  }

  /// 이메일 인증 확인 완료 후 상태 전이
  void onEmailVerified() {
    state = AuthState(status: AuthStatus.authenticated, userId: state.userId);
    _syncFcm();
  }

  /// bootstrap이 403 EMAIL_VERIFICATION_REQUIRED를 받았을 때
  void onEmailVerificationNeeded() {
    state = AuthState(
      status: AuthStatus.emailVerificationRequired,
      userId: state.userId,
      email: state.email,
    );
  }

  /// 실행 중 401 후 refresh token이 거부된 terminal 만료 처리.
  /// 요청 시작 generation이 현재와 일치할 때만 세션을 무효화한다.
  Future<void> onTerminalAuthExpired(int sourceGeneration) {
    if (_terminalSourceGeneration == sourceGeneration &&
        _terminalAuthExpiryFuture != null) {
      return _terminalAuthExpiryFuture!;
    }

    final cleanupGeneration = apiClient.invalidateSessionGeneration(
      sourceGeneration,
    );
    if (cleanupGeneration == null) return Future<void>.value();

    _terminalSourceGeneration = sourceGeneration;
    final future = _expireTerminalSession(cleanupGeneration);
    _terminalAuthExpiryFuture = future;
    unawaited(
      future.whenComplete(() {
        if (identical(_terminalAuthExpiryFuture, future)) {
          _terminalSourceGeneration = null;
          _terminalAuthExpiryFuture = null;
        }
      }),
    );
    return future;
  }

  Future<void> _expireTerminalSession(int cleanupGeneration) async {
    await Future.wait([
      _bestEffort(
        () => apiClient.clearSession(expectedGeneration: cleanupGeneration),
      ),
      _bestEffort(clearMapDraft),
      _bestEffort(_disposeFcm),
    ]);
    if (apiClient.isCurrentSessionGeneration(cleanupGeneration)) {
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  Future<void> _bestEffort(Future<void> Function() cleanup) async {
    try {
      await cleanup();
    } catch (_) {
      // 로컬 cleanup 일부 실패가 terminal 상태 전이를 막지 않는다.
    }
  }

  /// 로그아웃
  Future<void> logout() async {
    final logoutGeneration = apiClient.beginSessionTransition();
    await Future.wait([
      _bestEffort(
        () => authService.logout(expectedGeneration: logoutGeneration),
      ),
      _bestEffort(clearMapDraft),
      _bestEffort(_disposeFcm),
    ]);
    if (apiClient.isCurrentSessionGeneration(logoutGeneration)) {
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  void _handleLoginResult(
    LoginResult result, {
    required int expectedGeneration,
    String? email,
  }) {
    if (!apiClient.isCurrentSessionGeneration(expectedGeneration)) return;
    _terminalAuthExpiryFuture = null;
    if (result.emailVerificationRequired) {
      state = AuthState(
        status: AuthStatus.emailVerificationRequired,
        userId: result.userId,
        email: email,
      );
    } else if (result.consentRequired.isNotEmpty) {
      state = AuthState(
        status: AuthStatus.consentRequired,
        userId: result.userId,
        consentRequired: result.consentRequired,
        onboardingRequired: result.isNew,
      );
    } else if (result.isNew) {
      state = AuthState(
        status: AuthStatus.onboarding,
        userId: result.userId,
        onboardingRequired: true,
      );
      _syncFcm();
    } else {
      state = AuthState(
        status: AuthStatus.authenticated,
        userId: result.userId,
      );
      _syncFcm();
    }
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((
  ref,
) {
  final authService = ref.watch(authServiceProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  final apiClient = ref.watch(apiClientProvider);
  final notifier = AuthNotifier(
    authService: authService,
    secureStorage: secureStorage,
    apiClient: apiClient,
    clearMapDraft: () => ref.read(mapDraftEventProvider.notifier).clear(),
  );
  apiClient.setAuthExpiredHandler(notifier.onTerminalAuthExpired);
  ref.onDispose(() => apiClient.setAuthExpiredHandler(null));
  return notifier;
});
