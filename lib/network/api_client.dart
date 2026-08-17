import "dart:convert";
import "package:http/http.dart" as http;
import "package:uuid/uuid.dart";
import "../core/secure_storage_service.dart";

/// API 명세서 §1 공통 규약 반영:
/// - Authorization: Bearer 토큰 자동 첨부
/// - 모든 쓰기(POST/PATCH/PUT/DELETE)에 Idempotency-Key 자동 생성
/// - 응답 포맷 { data, meta } / { error } 파싱
/// - access token 만료(401) 시 자동 갱신 후 1회 재시도
///
/// 가정: pubspec.yaml에 http 패키지가 있다고 가정. 프로젝트가 이미
/// dio 등 다른 HTTP 클라이언트를 쓰고 있다면 이 파일은 그 컨벤션에
/// 맞춰 다시 짜야 함 -- 실제 pubspec 확인 후 조정 필요.
class ApiException implements Exception {
  ApiException({required this.code, required this.message, this.retryable = false});
  final String code;
  final String message;
  final bool retryable;

  @override
  String toString() => "ApiException($code): $message";
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

  Future<Map<String, String>> _headers({bool isWrite = false}) async {
    final token = await _secureStorage.accessToken;
    final headers = <String, String>{
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
    if (isWrite) {
      headers["Idempotency-Key"] = _uuid.v4();
    }
    return headers;
  }

  Uri _uri(String path, [Map<String, dynamic>? query]) {
    final cleaned = path.startsWith("/") ? path.substring(1) : path;
    return Uri.parse("$baseUrl/$cleaned").replace(
      queryParameters:
          query?.map((k, v) => MapEntry(k, v.toString())),
    );
  }

  Future<T> _handle<T>(
    Future<http.Response> Function() request, {
    bool retryOn401 = true,
  }) async {
    final response = await request();

    if (response.statusCode == 401 && retryOn401) {
      final refreshed = await _tryRefresh();
      if (refreshed) {
        return _handle<T>(request, retryOn401: false);
      }
      throw ApiException(code: "UNAUTHORIZED", message: "세션이 만료됐어요. 다시 로그인해주세요.");
    }

    final body = response.body.isEmpty ? <String, dynamic>{} : jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return (body["data"] ?? body) as T;
    }

    final error = body["error"] as Map<String, dynamic>? ?? {};
    throw ApiException(
      code: error["code"] as String? ?? "UNKNOWN_ERROR",
      message: error["message"] as String? ?? "요청을 처리하지 못했어요.",
      retryable: error["retryable"] as bool? ?? false,
    );
  }

  Future<bool> _tryRefresh() async {
    final refreshToken = await _secureStorage.refreshToken;
    if (refreshToken == null) return false;
    try {
      final response = await _http.post(
        _uri("/auth/refresh"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"refreshToken": refreshToken}),
      );
      if (response.statusCode != 200) return false;
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final data = body["data"] as Map<String, dynamic>;
      await _secureStorage.updateAccessToken(data["accessToken"] as String);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<T> get<T>(String path, {Map<String, dynamic>? query}) {
    return _handle<T>(() async {
      final headers = await _headers();
      return _http.get(_uri(path, query), headers: headers);
    });
  }

  Future<T> post<T>(String path, {Map<String, dynamic>? body}) {
    return _handle<T>(() async {
      final headers = await _headers(isWrite: true);
      return _http.post(_uri(path), headers: headers, body: jsonEncode(body ?? {}));
    });
  }

  Future<T> patch<T>(String path, {Map<String, dynamic>? body}) {
    return _handle<T>(() async {
      final headers = await _headers(isWrite: true);
      return _http.patch(_uri(path), headers: headers, body: jsonEncode(body ?? {}));
    });
  }

  Future<T> delete<T>(String path) {
    return _handle<T>(() async {
      final headers = await _headers(isWrite: true);
      return _http.delete(_uri(path), headers: headers);
    });
  }
}