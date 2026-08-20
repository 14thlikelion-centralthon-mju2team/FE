import "package:flutter/widgets.dart";
import "package:google_sign_in_web/web_only.dart" as gsi_web;

/// GIS가 직접 그리는 로그인 버튼. 클릭→팝업 사이에 우리 Dart 코드가
/// 끼지 않아 브라우저의 user-activation을 잃지 않는다(google_auth_helper.dart
/// 문서 참고). 로그인 결과는 GoogleAuthHelper.onLoginUserChanged로 온다.
Widget buildGoogleWebButton() {
  return Center(
    child: gsi_web.renderButton(
      configuration: gsi_web.GSIButtonConfiguration(
        type: gsi_web.GSIButtonType.standard,
        theme: gsi_web.GSIButtonTheme.outline,
        size: gsi_web.GSIButtonSize.large,
        text: gsi_web.GSIButtonText.continueWith,
        shape: gsi_web.GSIButtonShape.pill,
        minimumWidth: 320,
      ),
    ),
  );
}
