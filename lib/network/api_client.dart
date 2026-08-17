import "dart:convert";
import "package:http/http.dart" as http;
import "package:uuid/uuid.dart";
import "../core/secure_storage_service.dart";

/// API 명세서 §1 공통 규약 반영.
///
/// 리뷰 반영(REQUEST_CHANGES blocker 3): Idempotency-Key는 논리적 요청 1건당
/// 1개만 발급하고, 401->refresh 재시도에서도 같은 키를 재사용한다. 이전
/// 버전은 요청 클로저 내부(_headers)에서 매번 새로 uuid를 만들었기 때문에,
/// 첫 요청이 서버에 실제로는 반영됐는데 응답만 401로 유실된 경우 재시도가
/// 새 키로 나가면서 서버가 이를 별개 요청으로 처리할 위험이 있었다.
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

  Future<Map<String, String>> _readHeaders() async {
    final token = await _secureStorage.accessToken;
    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  /// idempotencyKey는 호출부(post/patch/delete)가 요청 시작 시 한 번만
  /// 발급해서 넘긴다. 여기서는 매 재시도마다 토큰만 새로 읽고 키는
  /// 그대로 재사용한다.
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

  Future<T> _handle<T>(
    Future<http.Response> Function() request, {
    bool retryOn401 = true,
  }) async {
    final response = await request();

    if (response.statusCode == 401 && retryOn401) {
      final refreshed = await _tryRefresh();
      if (refreshed) {
        // 같은 request 클로저를 재사용 -- 클로저 안에서 헤더를 다시 만들
        // 때 idempotencyKey는 그대로, accessToken만 새로 읽히므로 이 재시도가
        // "같은 논리 요청의 재전송"으로 유지된다.
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

  /// /auth/refresh 자체도 멱등키를 부여한다. 네트워크 재시도(예: 타임아웃
  /// 후 클라이언트가 자체적으로 재요청)로 refresh가 중복 호출돼도 서버가
  /// 세션을 두 번 갱신하지 않도록 하기 위함 -- 리뷰에서 지적된 "예외 계약
  /// 문서화" 요구를 코드 주석 + 헤더 부여 둘 다로 반영한다.
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
      final data = body["data"] as Map<String, dynamic>;
      await _secureStorage.updateAccessToken(data["accessToken"] as String);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<T> get<T>(String path, {Map<String, dynamic>? query}) {
    // 읽기 요청은 Idempotency-Key가 필요 없다 (API 명세 §1: 쓰기에만 적용).
    return _handle<T>(() async {
      final headers = await _readHeaders();
      return _http.get(_uri(path, query), headers: headers);
    });
  }

  Future<T> post<T>(String path, {Map<String, dynamic>? body}) {
    final idempotencyKey = _uuid.v4(); // 요청 시작 시 1회만 발급
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