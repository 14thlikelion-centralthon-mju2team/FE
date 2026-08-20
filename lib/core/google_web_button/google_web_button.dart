import "package:flutter/widgets.dart";

// 웹에서만 GSI(Google Identity Services)가 직접 렌더링하는 버튼을 쓴다.
// dart:js_interop 유무로 갈라 모바일 빌드에는 웹 전용 패키지 import가
// 섞이지 않게 한다 (lib/local/connection/의 기존 관례와 동일 패턴).
import "stub.dart" if (dart.library.js_interop) "web.dart" as impl;

/// 구글이 직접 렌더링하는 로그인 버튼(웹 전용). 모바일에서는 빈 위젯을
/// 반환한다 — 모바일은 auth_screen.dart의 커스텀 버튼 + signIn()을 쓴다.
Widget buildGoogleWebButton() => impl.buildGoogleWebButton();
