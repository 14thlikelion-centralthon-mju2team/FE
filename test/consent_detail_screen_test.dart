import "package:ensom/screens/onboarding/consent_detail_screen.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  testWidgets("unapproved legal documents stay in an approval-pending state", (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ConsentDetailScreen(consentType: "privacy", title: "개인정보 처리방침"),
      ),
    );

    expect(find.textContaining("Product/Legal 검토 및 승인 대기"), findsOneWidget);
    expect(find.textContaining("수집 항목·이용 목적·보유기간·시행일"), findsOneWidget);
    expect(find.textContaining("이름을 필수 항목으로 수집"), findsNothing);
    expect(find.textContaining("시행일 2026년"), findsNothing);
  });
}
