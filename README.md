# Ensom FE

## 실행

### 1. Firebase 설정 파일 (필수 — Git 미추적)

`google-services.json`과 `GoogleService-Info.plist`는 API 키를 포함하므로 Git에 기록하지 않습니다.
빌드 전에 아래 경로에 직접 배치해야 합니다.

```
android/app/google-services.json      ← Android
ios/Runner/GoogleService-Info.plist    ← iOS
```

**파일 획득 방법:**
- 팀 Slack `#fe-secrets` 채널에서 다운로드
- 또는 Firebase 콘솔 → 프로젝트 설정 → 앱 추가에서 직접 발급

**파일이 없으면:**
- `flutter build apk`는 Google Services Gradle 플러그인 오류로 실패합니다
- `flutter run` (debug)은 `Firebase.initializeApp()` try-catch로 FCM만 비활성, 앱은 시작됨

### 2. 카카오 키 (선택 — 없어도 빌드 가능)

```bash
flutter run \
  --dart-define=KAKAO_NATIVE_APP_KEY=xxx \
  --dart-define=KAKAO_REST_API_KEY=yyy
```

- `KAKAO_NATIVE_APP_KEY`: 카카오 개발자 콘솔의 네이티브 앱 키 (지도 SDK)
- `KAKAO_REST_API_KEY`: 같은 콘솔의 REST API 키 (목적지 키워드 검색)
- 둘 다 비어 있어도 빌드는 되며, 해당 기능만 저하 동작

### 3. Google OAuth (선택)

```bash
flutter run \
  --dart-define=GOOGLE_SERVER_CLIENT_ID=xxx
```

- 비어 있으면 Google 로그인 버튼이 숨겨지고 이메일 로그인만 노출

### 전체 실행 예시

```bash
flutter run \
  --dart-define=KAKAO_NATIVE_APP_KEY=xxx \
  --dart-define=KAKAO_REST_API_KEY=yyy \
  --dart-define=GOOGLE_SERVER_CLIENT_ID=zzz
```

## CI 빌드 시 Firebase 설정 주입

```yaml
# GitHub Actions 예시
- name: Decode google-services.json
  run: echo "${{ secrets.GOOGLE_SERVICES_JSON_BASE64 }}" | base64 -d > android/app/google-services.json

- name: Build APK
  run: flutter build apk --debug
```

시크릿 `GOOGLE_SERVICES_JSON_BASE64`는 `base64 -w0 android/app/google-services.json`으로 생성합니다.

## 빌드 검증

```bash
# 분석 (error 0이면 통과)
flutter analyze --no-fatal-infos --no-fatal-warnings

# 테스트
flutter test

# APK 빌드 (google-services.json 필요)
flutter build apk --debug
```
