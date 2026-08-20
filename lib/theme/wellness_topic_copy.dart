/// 웰니스 관심 항목(topic)의 표시 문구.
///
/// 온보딩(ONB-06)과 설정(SET) 화면이 동일 문구를 쓰므로 한곳에서 관리한다.
/// 설명(subtitle)은 PRD §15 "정보가 아니라 행동을 제안한다" 원칙에 맞춰
/// 모두 "~를 제안해요" 형식의 행동 카피로 통일한다.
library;

/// topic 키(uv/pm/temp/rain/hydration) → 표시 라벨.
const wellnessTopicLabels = {
  "uv": "자외선",
  "pm": "미세먼지",
  "temp": "기온·체감온도",
  "rain": "강수",
  "hydration": "수분",
};

/// topic 키 → 한 줄 행동 설명(subtitle).
const wellnessTopicSubtitles = {
  "uv": "자외선이 강한 날 선크림을 제안해요",
  "pm": "공기가 나쁜 날 마스크를 제안해요",
  "temp": "기온에 맞는 옷차림을 제안해요",
  "rain": "비·눈 예보가 있으면 우산을 제안해요",
  "hydration": "외출 전 물 챙기기를 제안해요",
};
