import "dart:convert";

import "package:ensom/core/secure_storage_service.dart";
import "package:ensom/network/api_client.dart";
import "package:ensom/repository/api_ensom_repository.dart";
import "package:flutter_test/flutter_test.dart";
import "package:http/http.dart" as http;
import "package:http/testing.dart";

class _StubStorage extends SecureStorageService {
  @override
  Future<String?> get accessToken async => "access";

  @override
  Future<String?> get refreshToken async => "refresh";

  @override
  Future<String?> get userId async => "user";

  @override
  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    required String userId,
  }) async {}

  @override
  Future<void> clearSession() async {}
}

void main() {
  test("personalization revert posts without an eventId body", () async {
    http.Request? captured;
    final client = ApiClient(
      baseUrl: "https://api.ensom.test/v1",
      secureStorage: _StubStorage(),
      httpClient: MockClient((request) async {
        captured = request;
        return http.Response("{}", 200);
      }),
    );
    final generation = client.beginSessionTransition();
    await client.saveSession(
      expectedGeneration: generation,
      accessToken: "access",
      refreshToken: "refresh",
      userId: "user",
    );

    await ApiEnsomRepository(client).revertPersonalization();

    expect(captured, isNotNull);
    expect(captured!.method, "POST");
    expect(captured!.url.path, "/v1/me/personalization/revert");
    expect(jsonDecode(captured!.body), isEmpty);
  });
}
