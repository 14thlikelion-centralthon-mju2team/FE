import "dart:io";

import "../network/api_client.dart";
import "secure_storage_service.dart";

/// API 명세 §2 인증 엔드포인트 전담 서비스.
/// EnsomRepository와 별도로 존재한다 — 인증은 도메인 리소스가 아니라
/// 세션 수립 경로이며, Bearer 토큰 없이 호출되는 유일한 그룹이기 때문이다.
class AuthService {
  AuthService({
    required ApiClient apiClient,
    required SecureStorageService secureStorage,
  })  : _client = apiClient,
        _secureStorage = secureStorage;

  final ApiClient _client;
  final SecureStorageService _secureStorage;

  // ─── 이메일 회원가입 (§2.1) ─────────────────────────────────────
  /// 가입 성공 시 토큰을 발급하지 않는다(API 명세 §2.1).
  /// 이메일 인증 후 로그인해야 세션이 생긴다.
  Future<SignupResult> signupWithEmail({
    required String email,
    required String password,
    String? nickname,
    String? timezone,
    String? installationId,
  }) async {
    try {
      final data = await _client.post<Map<String, dynamic>>(
        "/auth/email/signup",
        body: {
          "email": email,
          "password": password,
          // BE 계약에 따라 선택적으로 포함. BE가 수용하지 않으면 무시됨.
          if (nickname != null) "nickname": nickname,
          if (timezone != null) "timezone": timezone,
          if (installationId != null) "installationId": installationId,
        },
      );
      // BE 응답 형식 양쪽 대응:
      //   FE 기대: {"user": {"userId", "email", "emailVerified"}, "verificationSent"}
      //   BE 현재: {"id", "email", "provider"}
      final user = data["user"] as Map<String, dynamic>? ?? data;
      return SignupResult(
        userId: (user["userId"] ?? user["id"] ?? "") as String,
        email: (user["email"] ?? email) as String,
        emailVerified: user["emailVerified"] as bool? ?? false,
        verificationSent: data["verificationSent"] as bool? ?? true,
      );
    } on ApiException {
      rethrow;
    } on SocketException {
      throw ApiException(
        code: "NETWORK_ERROR",
        message: "네트워크에 연결할 수 없어요.",
        retryable: true,
      );
    }
  }

  // ─── 이메일 로그인 (§2.2) ──────────────────────────────────────
  Future<LoginResult> loginWithEmail({
    required String email,
    required String password,
    String? installationId,
  }) async {
    try {
      final data = await _client.post<Map<String, dynamic>>(
        "/auth/email/login",
        body: {
          "email": email,
          "password": password,
          if (installationId != null) "installationId": installationId,
        },
      );
      return _handleLoginResponse(data);
    } on ApiException {
      rethrow;
    } on SocketException {
      throw ApiException(
        code: "NETWORK_ERROR",
        message: "네트워크에 연결할 수 없어요.",
        retryable: true,
      );
    }
  }

  // ─── Google 로그인 (§2.5) ──────────────────────────────────────
  /// 현재 BE 매핑: POST /auth/google (dev BE 기준)
  /// API 명세는 POST /auth/login { provider: "google" } 이지만,
  /// BE와 합의해 /auth/google 단일 경로로 확정.
  Future<LoginResult> loginWithGoogle({
    required String idToken,
    required String installationId,
  }) async {
    try {
      final data = await _client.post<Map<String, dynamic>>(
        "/auth/google",
        body: {
          "idToken": idToken,
          "installationId": installationId,
        },
      );
      return _handleLoginResponse(data);
    } on ApiException {
      rethrow;
    } on SocketException {
      throw ApiException(
        code: "NETWORK_ERROR",
        message: "네트워크에 연결할 수 없어요.",
        retryable: true,
      );
    }
  }

  // ─── 이메일 인증 (§2.3) ────────────────────────────────────────
  Future<void> verifyEmail(String token) async {
    await _client.post<Map<String, dynamic>>(
      "/auth/email/verify",
      body: {"token": token},
    );
  }

  Future<void> resendVerification(String email) async {
    await _client.post<Map<String, dynamic>>(
      "/auth/email/verify/resend",
      body: {"email": email},
    );
  }

  // ─── 약관 동의 (§2.8) ─────────────────────────────────────────
  /// 현재 BE 계약: 단건 ConsentRequest + Idempotency-Key 헤더.
  /// ApiClient.post()가 Idempotency-Key를 자동 부여하므로 body에는
  /// 동의 내용만 담는다. 복수 항목은 순차 호출한다.
  Future<void> submitConsents(List<ConsentEntry> consents) async {
    for (final consent in consents) {
      await _client.post<Map<String, dynamic>>(
        "/consents",
        body: consent.toJson(),
      );
    }
  }

  // ─── 로그아웃 (§2.6) ──────────────────────────────────────────
  Future<void> logout() async {
    try {
      await _client.post<Map<String, dynamic>>("/auth/logout");
    } catch (_) {
      // 로그아웃 서버 호출 실패해도 로컬은 소거한다
    } finally {
      await _secureStorage.clearSession();
    }
  }

  // ─── 내부 ─────────────────────────────────────────────────────
  Future<LoginResult> _handleLoginResponse(Map<String, dynamic> data) async {
    final accessToken = data["accessToken"] as String;
    final refreshToken = data["refreshToken"] as String;
    final user = data["user"] as Map<String, dynamic>;
    final userId = user["userId"] as String;

    await _secureStorage.saveSession(
      accessToken: accessToken,
      refreshToken: refreshToken,
      userId: userId,
    );

    return LoginResult(
      userId: userId,
      nickname: user["nickname"] as String? ?? "",
      timezone: user["timezone"] as String? ?? "Asia/Seoul",
      isNew: user["isNew"] as bool? ?? false,
      emailVerificationRequired:
          data["emailVerificationRequired"] as bool? ?? false,
      consentRequired: (data["consentRequired"] as List<dynamic>?)
              ?.cast<String>() ??
          [],
    );
  }
}

// ─── Result DTOs ──────────────────────────────────────────────────

class SignupResult {
  const SignupResult({
    required this.userId,
    required this.email,
    required this.emailVerified,
    required this.verificationSent,
  });

  final String userId;
  final String email;
  final bool emailVerified;
  final bool verificationSent;
}

class LoginResult {
  const LoginResult({
    required this.userId,
    required this.nickname,
    required this.timezone,
    required this.isNew,
    required this.emailVerificationRequired,
    required this.consentRequired,
  });

  final String userId;
  final String nickname;
  final String timezone;
  final bool isNew;
  final bool emailVerificationRequired;
  final List<String> consentRequired;
}

class ConsentEntry {
  const ConsentEntry({
    required this.consentType,
    required this.policyVersion,
    required this.agreed,
  });

  final String consentType;
  final String policyVersion;
  final bool agreed;

  /// BE 현재 계약: consentType + policyVersion + agreed (boolean).
  /// action/isRequired는 FE 전용 개념이므로 서버에 보내지 않는다.
  Map<String, dynamic> toJson() => {
        "consentType": consentType,
        "policyVersion": policyVersion,
        "agreed": agreed,
      };
}
