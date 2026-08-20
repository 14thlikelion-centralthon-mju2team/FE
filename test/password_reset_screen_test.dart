import "package:ensom/core/secure_storage_service.dart";
import "package:ensom/network/api_client.dart";
import "package:ensom/providers/auth_providers.dart";
import "package:ensom/screens/onboarding/password_reset_screen.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_test/flutter_test.dart";
import "package:http/http.dart" as http;
import "package:http/testing.dart";

void main() {
  testWidgets("password reset uses the unauthenticated public endpoint", (
    tester,
  ) async {
    var requestCount = 0;
    late http.Request capturedRequest;
    final apiClient = ApiClient(
      baseUrl: "https://api.ensom.test/v1",
      secureStorage: SecureStorageService(),
      httpClient: MockClient((request) async {
        requestCount++;
        capturedRequest = request;
        return http.Response('{"data":{}}', 200);
      }),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [apiClientProvider.overrideWithValue(apiClient)],
        child: const MaterialApp(home: PasswordResetScreen()),
      ),
    );

    await tester.enterText(find.byType(TextField), "user@example.com");
    await tester.pump();
    await tester.tap(find.text("재설정 메일 보내기"));
    await tester.pumpAndSettle();

    expect(requestCount, 1);
    expect(capturedRequest.url.path, "/v1/auth/password/reset-request");
    expect(capturedRequest.headers.containsKey("Authorization"), isFalse);
    expect(find.text("메일을 보냈어요"), findsOneWidget);
  });
}
