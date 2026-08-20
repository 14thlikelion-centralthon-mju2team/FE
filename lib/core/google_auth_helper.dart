import "package:google_sign_in/google_sign_in.dart";
import "app_config.dart";

/// 구글 로그인 중앙 헬퍼.
///
/// - 로그인용(idToken 반환)과 캘린더 연동용(serverAuthCode 반환)을 분리.
/// - 항상 finally에서 signOut()을 호출해 다음 시도에서 계정 선택기가 노출되도록 한다.
/// - kGoogleServerClientId가 비어 있으면 예외를 던진다.
class GoogleAuthHelper {
  GoogleAuthHelper._();
  static final instance = GoogleAuthHelper._();

  final _googleSignIn = GoogleSignIn(
    serverClientId:
        kGoogleServerClientId.isEmpty ? null : kGoogleServerClientId,
    scopes: const [
      "email",
      "https://www.googleapis.com/auth/calendar.readonly",
    ],
  );

  /// 로그인용 — idToken을 반환한다.
  /// 사용자가 취소하면 null, 인증 실패 시 예외.
  Future<String?> signInForLogin() async {
    _ensureClientId();
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) return null;

      final auth = await account.authentication;
      final idToken = auth.idToken;
      if (idToken == null) {
        throw StateError("Google 인증에서 idToken을 가져오지 못했습니다.");
      }
      return idToken;
    } finally {
      await _googleSignIn.signOut();
    }
  }

  /// 캘린더 연동용 — serverAuthCode를 반환한다.
  /// 사용자가 취소하면 null, 인증 실패 시 예외.
  Future<String?> signInForCalendar() async {
    _ensureClientId();
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) return null;

      final authCode = account.serverAuthCode;
      if (authCode == null || authCode.isEmpty) {
        throw StateError("Google serverAuthCode가 비어 있습니다.");
      }
      return authCode;
    } finally {
      await _googleSignIn.signOut();
    }
  }

  void _ensureClientId() {
    if (kGoogleServerClientId.isEmpty) {
      throw StateError("GOOGLE_SERVER_CLIENT_ID가 설정되지 않았습니다.");
    }
  }
}
