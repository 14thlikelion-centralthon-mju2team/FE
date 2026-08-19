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

class ApiClient {
  ApiClient({
    required this.baseUrl,
    required SecureStorageService secureStorage,
    http.Client? httpClient,
  })  : _secureStorage = secureStorage,
        _http = httpClient ?? http.Client();

  final String baseUrl;
  final SecureStorageService _secureStorage;
  final http.Client _http;
  final _uuid = const Uuid();

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
    return Uri.parse("$baseUrl/$cleaned").replace(
      queryParameters: query?.map((k, v) => MapEntry(k, v.toString())),
    );
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
    }

    // ─── 401 → refresh 시도 ─────────────────────────────────────
    if (response.statusCode == 401 && retryOn401) {
      final refreshed = await _tryRefresh();
      if (refreshed) {
        return _handle<T>(request, retryOn401: false);
      }
      // refresh도 실패 → 세션 만료. 이때만 로그인 화면으로 보낸다.
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
    final Map<String, dynamic> errorBody =
        decoded is Map<String, dynamic> ? decoded : <String, dynamic>{};
    final error = errorBody["error"] as Map<String, dynamic>? ?? errorBody;
    throw ApiException(
      code: error["code"] as String? ?? "UNKNOWN_ERROR",
      message: error["message"] as String? ?? "요청을 처리하지 못했어요.",
      retryable: error["retryable"] as bool? ?? false,
      statusCode: response.statusCode,
    );
  }

  /// refresh 토큰으로 access 토큰 갱신.
  /// 네트워크 오류면 false 반환 — 이 경우 원래 요청이 네트워크 오류로
  /// 실패한 것이므로 401이 아니라 NETWORK_ERROR로 처리해야 한다.
  /// 그러나 401 응답 자체는 이미 받았으므로(네트워크는 되는 상태)
  /// refresh 실패는 세션 만료로 봐도 된다.
  Future<bool> _tryRefresh() async {
    final refreshToken = await _secureStorage.refreshToken;
    if (refreshToken == null) return false;
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
      if (response.statusCode != 200) return false;
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      // BE가 {"data": {accessToken}} 또는 {accessToken} 직접 반환 양쪽 대응
      final data = (body["data"] ?? body) as Map<String, dynamic>;
      await _secureStorage.updateAccessToken(data["accessToken"] as String);
      return true;
    } catch (_) {
      return false;
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
      return _http.post(_uri(path), headers: headers, body: jsonEncode(body ?? {}));
    });
  }

  Future<T> patch<T>(String path, {Map<String, dynamic>? body}) {
    final idempotencyKey = _uuid.v4();
    return _handle<T>(() async {
      final headers = await _writeHeaders(idempotencyKey);
      return _http.patch(_uri(path), headers: headers, body: jsonEncode(body ?? {}));
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
