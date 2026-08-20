import "package:google_sign_in/google_sign_in.dart";
import "app_config.dart";

/// 구글 로그인 중앙 헬퍼.
///
/// - 로그인용(idToken 반환)과 캘린더 연동용(serverAuthCode 반환)을 분리.
/// - 로그인에는 email 스코프만 요청해 동의 화면을 최소화한다.
/// - 캘린더 연동 시에만 calendar.readonly 스코프를 추가로 요청한다.
/// - 항상 finally에서 signOut()을 호출해 다음 시도에서 계정 선택기가 노출되도록 한다.
/// - kGoogleServerClientId가 비어 있으면 예외를 던진다.
class GoogleAuthHelper {
  GoogleAuthHelper._();
  static final instance = GoogleAuthHelper._();

  /// 로그인 전용 — email 스코프만 요청.
  final _loginSignIn = GoogleSignIn(
    serverClientId:
        kGoogleServerClientId.isEmpty ? null : kGoogleServerClientId,
    scopes: const ["email"],
  );

  /// 캘린더 연동 전용 — email + calendar.readonly 스코프 요청.
  final _calendarSignIn = GoogleSignIn(
    serverClientId:
        kGoogleServerClientId.isEmpty ? null : kGoogleServerClientId,
    scopes: const [
      "email",
      "https://www.googleapis.com/auth/calendar.readonly",
    ],
  );

  /// 웹 전용 로그인 버튼(google_web_button.dart)이 구독한다.
  /// GoogleSignIn().signIn()은 웹에서 deprecated고, 클릭→팝업 사이에
  /// 우리 쪽 비동기 단계(_ensureInitialized 등)가 끼어들어 브라우저의
  /// user-activation을 잃어버려 팝업이 막힌다 — 그 실패가 Dart
  /// try-catch로 못 잡는 raw JS 에러로 샌다. renderButton()이 만드는
  /// 구글 자체 버튼은 클릭→팝업 사이에 우리 코드가 끼지 않아 이 문제가
  /// 없다. 그 대신 결과는 signIn()의 반환값이 아니라 이 스트림으로 온다.
  Stream<GoogleSignInAccount?> get onLoginUserChanged =>
      _loginSignIn.onCurrentUserChanged;

  /// 로그인용 — idToken을 반환한다.
  /// 사용자가 취소하면 null, 인증 실패 시 예외.
  Future<String?> signInForLogin() async {
    _ensureClientId();
    try {
      final account = await _loginSignIn.signIn();
      if (account == null) return null;

      final auth = await account.authentication;
      final idToken = auth.idToken;
      if (idToken == null) {
        throw StateError("Google 인증에서 idToken을 가져오지 못했습니다.");
      }
      return idToken;
    } finally {
      await _loginSignIn.signOut();
    }
  }

  /// 캘린더 연동용 — serverAuthCode를 반환한다.
  /// 사용자가 취소하면 null, 인증 실패 시 예외.
  Future<String?> signInForCalendar() async {
    _ensureClientId();
    try {
      final account = await _calendarSignIn.signIn();
      if (account == null) return null;

      final authCode = account.serverAuthCode;
      if (authCode == null || authCode.isEmpty) {
        throw StateError("Google serverAuthCode가 비어 있습니다.");
      }
      return authCode;
    } finally {
      await _calendarSignIn.signOut();
    }
  }

  void _ensureClientId() {
    if (kGoogleServerClientId.isEmpty) {
      throw StateError("GOOGLE_SERVER_CLIENT_ID가 설정되지 않았습니다.");
    }
  }
}
