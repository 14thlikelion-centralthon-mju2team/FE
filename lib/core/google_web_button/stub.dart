import "package:flutter/widgets.dart";

/// 모바일/데스크톱 스텁 — 실제로는 auth_screen.dart가 kIsWeb으로 이
/// 위젯을 아예 빌드하지 않으므로 호출되지 않는다.
Widget buildGoogleWebButton() => const SizedBox.shrink();
