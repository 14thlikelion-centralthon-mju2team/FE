import "package:flutter/material.dart";

/// 08.20 화면 프로토타입 패키지에서 확정된 Ensom 색상 토큰.
abstract final class EnsomColors {
  static const lime = Color(0xFFC6F135);
  static const limeSoft = Color(0xFFE4FB9B);
  static const limeInk = Color(0xFF4E6810);

  static const canvas = Color(0xFFFFFFFF);
  static const surface1 = Color(0xFFFFFFFF);
  static const surface2 = Color(0xFFEEF0EA);
  static const surfaceNeutral = Color(0xFFE9E9E6);
  static const hairline = Color(0xFFE3E5E0);

  static const ink = Color(0xFF14150F);
  static const inkMuted = Color(0xFF63655E);
  static const inkFaint = Color(0xFF6F7269);
  static const panel = Color(0xFF15170F);
  static const cta = Color(0xFF1F231A);
  static const caution = Color(0xFFE3A13B);

  // ── 오버레이 (코치마크 등) ──────────────────────────────
  static const scrim = Color(0x99000000); // 60% 검정 — 오버레이 배경
  static const shadow = Color(0x29000000); // 16% 검정 — 그림자

  // ── 데이터 시각화 전용 시맨틱 토큰 (Issue #56) ──────────
  // 날씨/대기질 등 상태 표현에만 사용. UI 컴포넌트에는 쓰지 않는다.
  static const dataGood = Color(0xFF4CAF50); // 좋음 (초록)
  static const dataModerate = Color(0xFF2196F3); // 보통 (파랑)
  static const dataWarning = Color(0xFFFF9800); // 주의 (주황)
  static const dataSevere = Color(0xFFF44336); // 나쁨 (빨강)
}
