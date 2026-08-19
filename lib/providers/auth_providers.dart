import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_riverpod/legacy.dart";
import "../core/auth_service.dart";
import "../core/fcm_service.dart";
import "../core/secure_storage_service.dart";
import "../network/api_client.dart";

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
  final secureStorage = ref.watch(secureStorageProvider);
  return AuthService(apiClient: apiClient, secureStorage: secureStorage);
});

/// 인증 상태 — 앱 전체에서 로그인 여부, 온보딩 완료 여부를 추적한다.
/// 라우터 리다이렉트의 판단 기준.
enum AuthStatus {
  unknown, // 초기 상태 (세션 확인 중)
  unauthenticated, // 세션 없음
  emailVerificationRequired, // 로그인됨 but 이메일 미인증
  consentRequired, // 로그인됨 but 약관 미동의
  authenticated, // 정상 로그인 완료
}

class AuthState {
  const AuthState({
    required this.status,
    this.userId,
    this.email,
    this.consentRequired = const [],
  });

  final AuthStatus status;
  final String? userId;
  final String? email;
  final List<String> consentRequired;

  static const initial = AuthState(status: AuthStatus.unknown);
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier({
    required this.authService,
    required this.secureStorage,
    required this.apiClient,
  }) : super(AuthState.initial) {
    _checkExistingSession();
  }

  final AuthService authService;
  final SecureStorageService secureStorage;
  final ApiClient apiClient;

  /// 앱 시작 시 기존 세션 확인
  Future<void> _checkExistingSession() async {
    final hasToken = await secureStorage.hasSession;
    if (hasToken) {
      // 토큰은 있지만 유효한지는 bootstrap에서 확인됨.
      // 여기서는 일단 authenticated로 세팅하고 bootstrap이 403을 주면
      // 라우터가 적절히 처리한다.
      state = const AuthState(status: AuthStatus.authenticated);
      _syncFcm();
    } else {
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  /// main.dart가 Firebase.initializeApp() + 백그라운드 핸들러 등록까지는
  /// 이미 해 뒀다. 로그인 이후 단계(권한 요청, 토큰 획득, POST
  /// /push-devices 등록)는 apiClient가 있어야 하므로 여기서 이어 붙인다.
  void _syncFcm() {
    secureStorage.installationId.then((installationId) {
      FcmService.instance.initialize(
        apiClient: apiClient,
        installationId: installationId,
      );
    });
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
    final result = await authService.loginWithEmail(
      email: email,
      password: password,
      installationId: installationId,
    );
    _handleLoginResult(result, email: email);
  }

  /// Google 로그인 성공
  Future<void> loginWithGoogle({
    required String idToken,
    required String installationId,
  }) async {
    final result = await authService.loginWithGoogle(
      idToken: idToken,
      installationId: installationId,
    );
    _handleLoginResult(result);
  }

  /// 약관 동의 완료 후 상태 전이
  void onConsentCompleted() {
    state = AuthState(
      status: AuthStatus.authenticated,
      userId: state.userId,
    );
    _syncFcm();
  }

  /// 이메일 인증 확인 완료 후 상태 전이
  void onEmailVerified() {
    state = AuthState(
      status: AuthStatus.authenticated,
      userId: state.userId,
    );
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

  /// 로그아웃
  Future<void> logout() async {
    await authService.logout();
    FcmService.instance.dispose();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  void _handleLoginResult(LoginResult result, {String? email}) {
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
      );
    } else {
      state = AuthState(
        status: AuthStatus.authenticated,
        userId: result.userId,
      );
      _syncFcm();
    }
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  final apiClient = ref.watch(apiClientProvider);
  return AuthNotifier(
    authService: authService,
    secureStorage: secureStorage,
    apiClient: apiClient,
  );
});
