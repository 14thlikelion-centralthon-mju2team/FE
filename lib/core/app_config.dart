/// 빌드 시점 주입 값. 커밋에 실제 키가 남지 않도록 --dart-define으로 받는다.
/// `flutter run --dart-define=KAKAO_NATIVE_APP_KEY=xxx --dart-define=KAKAO_REST_API_KEY=yyy`
library;

/// 카카오맵 SDK 네이티브 앱 키. 비어 있으면 지도 화면이 저하 동작한다.
const String kKakaoNativeAppKey = String.fromEnvironment(
  'KAKAO_NATIVE_APP_KEY',
  defaultValue: '',
);

/// 카카오 로컬(키워드 검색) REST API 키. 지도 SDK 키와 별도 발급값이다
/// (카카오 개발자 콘솔의 같은 앱에서 "REST API 키"로 확인 가능).
/// 비어 있으면 목적지 키워드 검색이 지도를 눌러 좌표를 고르는 방식으로 저하 동작한다.
const String kKakaoRestApiKey = String.fromEnvironment(
  'KAKAO_REST_API_KEY',
  defaultValue: '',
);

/// 구글 서버 클라이언트 ID. 비어 있으면 구글 로그인 버튼이 숨겨진다.
const String kGoogleServerClientId = String.fromEnvironment(
  'GOOGLE_SERVER_CLIENT_ID',
  defaultValue: '',
);

/// 백엔드 API base URL. 운영 도메인은 api.ensom.shop이며(구 api.ensom.app은
/// DNS 레코드가 없어 모든 호출이 해석 단계에서 실패했다, Issue #83),
/// 스테이징/로컬 전환을 위해 --dart-define=API_BASE_URL로 재정의할 수 있다.
/// 예: flutter run --dart-define=API_BASE_URL=https://staging.ensom.shop/v1
const String kApiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'https://api.ensom.shop/v1',
);
