import "dart:async";
import "dart:convert";
import "dart:io";

import "package:http/http.dart" as http;
import "package:uuid/uuid.dart";
import "../core/secure_storage_service.dart";

/// API 명세서 §1 공통 규약 반영.
///
/// 오프라인 vs 인증실패 구분 원칙 (TRD §2.6):
/// - SocketException / HandshakeException / TimeoutException → NETWORK_ERROR (retryable: true)
///   클라이언트는 로그인 화면으로 보내지 않고 재시도 UI를 표시한다.
/// - 401 + refresh 실패 → UNAUTHORIZED (retryable: false)
///   이때만 로그인 화면으로 보낸다.
///
/// Idempotency-Key 규약:
/// 논리적 요청 1건당 1개만 발급하고, 401→refresh 재시도에서도 같은 키를
/// 재사용한다.
class ApiException implements Exception {
  ApiException({
    required this.code,
    required this.message,
    this.retryable = false,
    this.statusCode,
  });

  final String code;
  final String message;
  final bool retryable;
  final int? statusCode;

  /// 네트워크 오류인지 판별 — UI가 "재연결 시 재시도" 안내를 할지 결정
  bool get isNetworkError => code == "NETWORK_ERROR";

  /// 세션이 완전히 만료되어 로그인이 필요한지 판별
  bool get isAuthExpired => code == "UNAUTHORIZED";

  @override
  String toString() => "ApiException($code, status=$statusCode): $message";
}

enum _RefreshResult { success, rejected, retryableFailure }

class ApiClient {
  ApiClient({
    required this.baseUrl,
    required SecureStorageService secureStorage,
    http.Client? httpClient,
    Future<void> Function()? onAuthExpired,
  }) : _secureStorage = secureStorage,
       _http = httpClient ?? http.Client(),
       _onAuthExpired = onAuthExpired;

  final String baseUrl;
  final SecureStorageService _secureStorage;
  final http.Client _http;
  final _uuid = const Uuid();
  Future<void> Function()? _onAuthExpired;

  /// 앱 전역 인증 provider가 생성된 뒤 terminal 세션 만료 처리기를 연결한다.
  /// null을 전달하면 provider dispose 시 연결을 해제한다.
  void setAuthExpiredHandler(Future<void> Function()? handler) {
    _onAuthExpired = handler;
  }

  Future<void> _notifyAuthExpired() async {
    final handler = _onAuthExpired;
    if (handler != null) await handler();
  }

  Future<Map<String, String>> _readHeaders() async {
    final token = await _secureStorage.accessToken;
    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  Future<Map<String, String>> _writeHeaders(String idempotencyKey) async {
    final token = await _secureStorage.accessToken;
    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
      "Idempotency-Key": idempotencyKey,
    };
  }

  Uri _uri(String path, [Map<String, dynamic>? query]) {
    final cleaned = path.startsWith("/") ? path.substring(1) : path;
    return Uri.parse(
      "$baseUrl/$cleaned",
    ).replace(queryParameters: query?.map((k, v) => MapEntry(k, v.toString())));
  }

  /// 핵심 요청 처리기. 네트워크 오류와 인증 만료를 구분한다.
  Future<T> _handle<T>(
    Future<http.Response> Function() request, {
    bool retryOn401 = true,
  }) async {
    final http.Response response;
    try {
      response = await request();
    } on SocketException {
      throw ApiException(
        code: "NETWORK_ERROR",
        message: "네트워크에 연결할 수 없어요. 인터넷 연결을 확인해주세요.",
        retryable: true,
      );
    } on HandshakeException {
      throw ApiException(
        code: "NETWORK_ERROR",
        message: "보안 연결에 실패했어요. 잠시 후 다시 시도해주세요.",
        retryable: true,
      );
    } on HttpException {
      throw ApiException(
        code: "NETWORK_ERROR",
        message: "서버와 통신에 실패했어요.",
        retryable: true,
      );
    } on TimeoutException {
      throw ApiException(
        code: "NETWORK_ERROR",
        message: "서버 응답 시간이 초과됐어요.",
        retryable: true,
      );
    } on http.ClientException {
      throw ApiException(
        code: "NETWORK_ERROR",
        message: "서버와 통신에 실패했어요.",
        retryable: true,
      );
    }

    // ─── 401 → refresh 시도 ─────────────────────────────────────
    if (response.statusCode == 401 && retryOn401) {
      final refreshResult = await _tryRefresh();
      if (refreshResult == _RefreshResult.success) {
        return _handle<T>(request, retryOn401: false);
      }
      if (refreshResult == _RefreshResult.retryableFailure) {
        // refresh 전송/서버 일시 장애는 세션 폐기로 간주하지 않는다.
        throw ApiException(
          code: "NETWORK_ERROR",
          message: "세션을 갱신하지 못했어요. 네트워크를 확인해주세요.",
          retryable: true,
        );
      }

      // refresh token 부재/거부만 terminal 만료로 인증 계층에 전달한다.
      await _notifyAuthExpired();
      throw ApiException(
        code: "UNAUTHORIZED",
        message: "세션이 만료됐어요. 다시 로그인해주세요.",
        retryable: false,
        statusCode: 401,
      );
    }

    // refresh 성공 뒤 재시도도 401이면 새 토큰 역시 거부된 terminal 상태다.
    if (response.statusCode == 401) {
      await _notifyAuthExpired();
      throw ApiException(
        code: "UNAUTHORIZED",
        message: "세션이 만료됐어요. 다시 로그인해주세요.",
        retryable: false,
        statusCode: 401,
      );
    }

    // ─── 응답 파싱 ──────────────────────────────────────────────
    // BE가 JSON object 또는 array를 직접 반환할 수 있으므로
    // 먼저 dynamic으로 디코딩한 뒤 타입에 따라 분기한다.
    final dynamic decoded = response.body.isEmpty
        ? <String, dynamic>{}
        : jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Case 1: {"data": ...} wrapper가 있으면 unwrap
      if (decoded is Map<String, dynamic> && decoded.containsKey("data")) {
        return decoded["data"] as T;
      }
      // Case 2: wrapper 없이 object/array 직접 반환
      return decoded as T;
    }

    // ─── 에러 응답 ──────────────────────────────────────────────
    // BE 에러 형식 2종 대응:
    //   중첩: {"error": {"code": "...", "message": "...", "retryable": bool}}
    //   평면: {"error": "INVALID_REQUEST", "message": "..."}
    final Map<String, dynamic> errorBody = decoded is Map<String, dynamic>
        ? decoded
        : <String, dynamic>{};
    final rawError = errorBody["error"];
    final Map<String, dynamic> error = rawError is Map<String, dynamic>
        ? rawError
        : errorBody;
    throw ApiException(
      code:
          error["code"] as String? ??
          (rawError is String ? rawError : "UNKNOWN_ERROR"),
      message: error["message"] as String? ?? "요청을 처리하지 못했어요.",
      retryable: error["retryable"] as bool? ?? false,
      statusCode: response.statusCode,
    );
  }

  /// refresh 토큰으로 access 토큰 갱신.
  /// refresh token 부재/명시적 거부는 [rejected], 전송·서버 일시 장애는
  /// [retryableFailure]로 구분해 비종료 오류가 세션 소거로 이어지지 않게 한다.
  Future<_RefreshResult> _tryRefresh() async {
    final refreshToken = await _secureStorage.refreshToken;
    if (refreshToken == null) return _RefreshResult.rejected;
    final refreshIdempotencyKey = _uuid.v4();
    try {
      final response = await _http.post(
        _uri("/auth/refresh"),
        headers: {
          "Content-Type": "application/json",
          "Idempotency-Key": refreshIdempotencyKey,
        },
        body: jsonEncode({"refreshToken": refreshToken}),
      );
      if ({400, 401, 403}.contains(response.statusCode)) {
        return _RefreshResult.rejected;
      }
      if (response.statusCode != 200) {
        return _RefreshResult.retryableFailure;
      }
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      // BE가 {"data": {accessToken}} 또는 {accessToken} 직접 반환 양쪽 대응
      final data = (body["data"] ?? body) as Map<String, dynamic>;
      await _secureStorage.updateAccessToken(data["accessToken"] as String);
      return _RefreshResult.success;
    } catch (_) {
      return _RefreshResult.retryableFailure;
    }
  }

  // ─── Public HTTP methods ──────────────────────────────────────

  Future<T> get<T>(String path, {Map<String, dynamic>? query}) {
    return _handle<T>(() async {
      final headers = await _readHeaders();
      return _http.get(_uri(path, query), headers: headers);
    });
  }

  Future<T> post<T>(String path, {Map<String, dynamic>? body}) {
    final idempotencyKey = _uuid.v4();
    return _handle<T>(() async {
      final headers = await _writeHeaders(idempotencyKey);
      return _http.post(
        _uri(path),
        headers: headers,
        body: jsonEncode(body ?? {}),
      );
    });
  }

  Future<T> patch<T>(String path, {Map<String, dynamic>? body}) {
    final idempotencyKey = _uuid.v4();
    return _handle<T>(() async {
      final headers = await _writeHeaders(idempotencyKey);
      return _http.patch(
        _uri(path),
        headers: headers,
        body: jsonEncode(body ?? {}),
      );
    });
  }

  Future<T> delete<T>(String path) {
    final idempotencyKey = _uuid.v4();
    return _handle<T>(() async {
      final headers = await _writeHeaders(idempotencyKey);
      return _http.delete(_uri(path), headers: headers);
    });
  }
}
