# Ensom API 명세서 v5.0

| 항목 | 내용 |
|---|---|
| 문서 버전 | v5.0 |
| 작성일 | 2026-08-17 |
| 근거 문서 | **PRD v0.4.3** (최상위) · **ERD v3.1** · **TRD v4.0** |
| 스택 | Flutter · **Java 21 · Spring Boot 4.1.0** · PostgreSQL 16 |
| 외부 연동 | **ODsay 대중교통 API · 카카오맵 SDK · 기상청 · 에어코리아 · Google (OAuth · Calendar)** |
| 인증 | **이메일 계정 · Google 계정** 2종 |
| 필드 표기 | 요청·응답 **camelCase** · DB는 snake_case (ERD) |

---

## 1. 공통 규약

### 1.1 Base URL

```
https://api.ensom.shop/v1
```

### 1.2 인증

- `Authorization: Bearer <accessToken>` — 전 엔드포인트 필수 (`/auth/*` 제외)
- access JWT 1시간 · refresh 30일 (기기별, `PUSH_DEVICE.installation_id`와 연결)
- 모든 자원은 토큰의 `userId`로 **행 수준 필터링**. 타 사용자 자원 접근은 `404`
- **비회원·게스트 모드 없음** (AUTH-01)

### 1.3 공통 헤더

| 헤더 | 용도 |
|---|---|
| `Authorization` | Bearer 토큰 |
| `Idempotency-Key` | 모든 POST/PUT/PATCH 필수. 24시간 내 동일 키 → 이전 응답 재생 |
| `X-App-Version` | 최소 지원 버전 미만이면 `426` |
| `Accept-Language` | 알림·카드 문구 로컬라이즈 |

### 1.4 공통 응답 포맷

```json
// 성공
{ "data": { }, "meta": { "requestId": "req_123", "serverTime": "2026-08-17T09:00:00+09:00" } }

// 실패
{ "error": { "code": "EVENT_NOT_FOUND", "retryable": false, "message": "string" } }
```

### 1.5 시간 표현 (TR-02)

- 저장은 전부 `timestamptz`(UTC). **응답은 오프셋 포함 ISO-8601 필수** — `Z`만 오는 값은 요청에서 거부(`422`)
- 일정은 `USERS.timezone`(IANA, 예 `Asia/Seoul`)을 함께 반환
- 종일 일정은 계획 대상에서 제외
- 클라이언트가 보내는 `deviceTs`는 기기 시각이며, 서버 수신 시각과 **±120초**를 넘으면 `clockSkew` 플래그

### 1.6 멱등성 — 두 층위 (TR-03)

| 층위 | 수단 | 막는 것 |
|---|---|---|
| HTTP | `Idempotency-Key` 헤더 | 같은 요청의 재전송 |
| 도메인 | 바디의 `clientEventId` (UUID) | 다른 요청에 실려 온 같은 사건 |

---

## 2. 인증 · 기기 · 동의 (AUTH-01~04)

| Method | Path | 설명 |
|---|---|---|
| POST | `/auth/email/signup` | 이메일 계정 가입 |
| POST | `/auth/email/login` | 이메일 로그인 |
| POST | `/auth/email/verify` | 이메일 인증 완료 |
| POST | `/auth/email/verify/resend` | 인증 메일 재발송 |
| POST | `/auth/password/reset-request` | 재설정 메일 요청 |
| POST | `/auth/password/reset-confirm` | 재설정 완료 |
| PATCH | `/me/password` | 비밀번호 설정·변경 |
| POST | `/auth/login` | Google 로그인 |
| POST | `/auth/refresh` | 세션 갱신 |
| POST | `/auth/logout` | 로그아웃 |
| POST | `/push-devices` | FCM 토큰 등록·갱신 |
| DELETE | `/push-devices/{installationId}` | 토큰 해지 |
| GET / POST | `/consents` | 약관 동의 조회·기록 |

### 2.1 POST /auth/email/signup

```json
// Request
{ "email": "user@example.com", "password": "string", "nickname": "민형",
  "timezone": "Asia/Seoul", "installationId": "uuid" }

// Response 201
{
  "data": {
    "user": { "userId": "uuid", "email": "user@example.com", "emailVerified": false },
    "verificationSent": true
  }
}
```

- 가입 시점에는 토큰을 발급하지 않습니다. 이메일 인증 후 로그인해야 세션 생성
- 이미 Google로 가입된 이메일 → `409 EMAIL_ALREADY_LINKED`

### 2.2 POST /auth/email/login

```json
// Request
{ "email": "user@example.com", "password": "string", "installationId": "uuid" }

// Response 200
{
  "data": {
    "accessToken": "jwt", "refreshToken": "opaque", "expiresIn": 3600,
    "user": { "userId": "uuid", "nickname": "민형", "timezone": "Asia/Seoul", "isNew": false },
    "emailVerificationRequired": false,
    "consentRequired": []
  }
}
```

| 실패 | 응답 |
|---|---|
| 이메일 없음·비밀번호 불일치 | `401 AUTH_INVALID_CREDENTIALS` — 둘을 구분하지 않음 |
| 연속 5회 실패 | `423 ACCOUNT_LOCKED` + `retryAfterSec` |
| 이메일 미인증 | `200` + `emailVerificationRequired: true` |

### 2.3 이메일 인증

```json
// POST /auth/email/verify
{ "token": "원문 토큰" }

// POST /auth/email/verify/resend
{ "email": "user@example.com" }
// Response 200 — 계정 유무와 무관하게 항상 200 (TR-14)
```

- 토큰 수명 **24시간**, 단회용
- 재발송은 **60초 쿨다운**

### 2.4 비밀번호 재설정 · 변경

```json
// POST /auth/password/reset-request
{ "email": "user@example.com" }

// POST /auth/password/reset-confirm
{ "token": "원문 토큰", "newPassword": "string" }

// PATCH /me/password — 로그인 상태
{ "currentPassword": "string", "newPassword": "string" }
// Google 전용 계정이 비밀번호를 처음 설정할 때는 currentPassword 생략
```

- 재설정·변경 완료 시 해당 사용자의 **모든 refresh 토큰을 폐기**

### 2.5 POST /auth/login (Google)

```json
// Request
{ "provider": "google", "idToken": "string", "installationId": "uuid" }

// Response 200 — §2.2와 동일 형태
```

- `provider`는 **`google`만** 허용
- Google 로그인은 항상 `emailVerificationRequired: false`

### 2.6 POST /auth/refresh · /auth/logout

```json
// refresh Request
{ "refreshToken": "opaque" }
```

- 로그아웃 시 refresh 폐기 + `PUSH_DEVICE.token_status` 비활성화. **서버 데이터는 유지**

### 2.7 POST /push-devices

```json
// Request
{ "installationId": "uuid", "currentToken": "fcm-token", "platform": "ios" }
// Response 200
{ "data": { "pushDeviceId": "uuid", "tokenStatus": "active" } }
```

- 호출 시점: 로그인 직후 + 토큰 갱신 콜백 발생 시

### 2.8 GET · POST /consents

```json
// POST Request
{
  "consents": [
    { "consentType": "terms",    "policyVersion": "v3", "action": "agreed", "isRequired": true },
    { "consentType": "privacy",  "policyVersion": "v2", "action": "agreed", "isRequired": true },
    { "consentType": "marketing","policyVersion": "v1", "action": "revoked","isRequired": false }
  ],
  "idempotencyKey": "uuid"
}
```

- `consentType`: `terms` | `privacy` | `location` | `marketing`

### 2.9 가입 흐름 요약

```
이메일 경로   signup → (메일) verify → login → consents → 온보딩
Google 경로   login  → consents → 온보딩

두 경로 모두 consentRequired 가 빈 배열이 될 때까지 홈 진입을 막는다
```

---

## 3. 부트스트랩

| Method | Path | 설명 |
|---|---|---|
| GET | `/me/bootstrap` | 앱 진입 시 1회. 홈 렌더에 필요한 전부 |

```json
{
  "data": {
    "user": { "userId": "uuid", "nickname": "민형", "timezone": "Asia/Seoul", "accountStatus": "active" },
    "settings": { "initialPrepMinutes": 30, "arrivalBufferMinutes": 10, "notificationSensitivity": "normal",
                  "personalizationEnabled": true, "autoManageEnabled": true,
                  "wellnessEventEnabled": true, "lockscreenHideSensitive": true },
    "permissions": [ { "permissionType": "calendar", "status": "granted" } ],
    "wellnessPrefs": [ { "wellnessTopic": "uv", "isEnabled": true, "remindIntervalMinutes": 120, "dailyEventCap": 1 } ],
    "places": [],
    "prepRules": [],
    "nextEvent": { "eventId": "uuid", "startsAt": "…" },
    "todayPlan": { },
    "engineConfig": { "calcVersion": "3.1.0", "weightVersion": "w1" }
  }
}
```

---

## 4. 사용자 설정 · 권한 · 웰니스 선호

| Method | Path | 설명 |
|---|---|---|
| GET / PATCH | `/me/settings` | 준비 시간 시드·도착 여유·알림 민감도·잠금화면 |
| GET / PATCH | `/me/permissions` | 캘린더·위치·알림·백그라운드 위치 권한 상태 |
| GET / PATCH | `/me/wellness-prefs` | 항목별 on/off · 재알림 주기 · 일일 상한 |

### 4.1 PATCH /me/settings

```json
{
  "initialPrepMinutes": 30,
  "arrivalBufferMinutes": 10,
  "notificationSensitivity": "normal",
  "personalizationEnabled": true,
  "autoManageEnabled": true,
  "wellnessEventEnabled": true,
  "lockscreenHideSensitive": true
}
```

- `initialPrepMinutes`는 `null` 허용 — 온보딩의 "잘 모르겠어요"

### 4.2 PATCH /me/wellness-prefs

```json
{
  "prefs": [
    { "wellnessTopic": "uv",        "isEnabled": true,  "remindIntervalMinutes": 120, "dailyEventCap": 1 },
    { "wellnessTopic": "pm",        "isEnabled": true,  "remindIntervalMinutes": null, "dailyEventCap": 1 },
    { "wellnessTopic": "hydration", "isEnabled": false, "remindIntervalMinutes": null, "dailyEventCap": 1 }
  ]
}
```

- `wellnessTopic`: `uv` | `pm` | `temp` | `rain` | `hydration`

### 4.3 권한 요청 순서 (PRD §11.4)

```
로그인·약관        → 첫 실행
캘린더            → 연동 진입 시
위치("사용 중")    → 첫 목적지 입력 시
알림              → 첫 계획 생성 후
위치("항상")       → 자동 출발·도착 확인을 켤 때 별도 화면에서 명시 동의
웰니스 이벤트 알림  → 관심 항목 설정에서 별도 토글
```

---

## 5. 장소 (SET-01)

| Method | Path | 설명 |
|---|---|---|
| GET / POST | `/places` | 목록 · 생성 |
| PATCH / DELETE | `/places/{placeId}` | 수정 · 삭제(소프트) |

```json
// POST Request
{ "placeType": "home", "placeName": "집", "address": "서울시 …",
  "lat": 37.5, "lng": 127.0, "isPrimary": true }
```

---

## 6. 맞춤 준비 규칙 (ONB-01 · SET-02 · PLAN-05)

| Method | Path | 설명 |
|---|---|---|
| GET / POST | `/prep-items` | 목록 · 생성 |
| PATCH / DELETE | `/prep-items/{prepRuleId}` | 수정 · 삭제(소프트) |

### 6.1 POST /prep-items

```json
{
  "ruleName": "영양제",
  "ruleCategory": "supplement",
  "actionType": "consume",
  "ruleTiming": "pre_departure",
  "defaultMinutes": null,
  "applyEventKind": null,
  "applyTimeBand": null,
  "applyPlaceId": null,
  "applyWeather": null,
  "isRequired": false,
  "isSensitive": false,
  "fromChip": true
}
```

| 필드 | 값 |
|---|---|
| `ruleCategory` | `supplement` \| `medication` \| `personal_item` \| `routine` \| `general_item` |
| `actionType` | `carry` \| `consume` \| `purchase` \| `timed_routine` |
| `ruleTiming` | `pre_departure` \| `post_arrival` |
| `defaultMinutes` | int \| null — `timed_routine`일 때만 값 존재 |

### 6.2 서버 검증 규칙

- `timed_routine` ⟺ `defaultMinutes IS NOT NULL` (위반 → 422)
- `fromChip=true` ∧ `isSensitive=true` → `422 SENSITIVE_CHIP_REJECTED`
- `ruleCategory='medication'` → `isSensitive` 강제 true

---

## 7. 캘린더 연동 (CAL-02)

| Method | Path | 설명 |
|---|---|---|
| GET / POST | `/calendar/connections` | 연결 목록 · 연결 추가 |
| DELETE | `/calendar/connections/{connectionId}` | 연결 해제 |
| GET / PATCH | `/calendar/connections/{connectionId}/sources` | 개별 캘린더 조회·선택 |
| POST | `/calendar/sync` | 수동 동기화 |

- **읽기 전용.** 5~15분 폴링 + 수동 동기화
- `attendees`·`description`·제목 원문은 파싱 후 즉시 폐기

---

## 8. 일정 (CAL-01 · 03 · 04 · 05)

| Method | Path | 설명 |
|---|---|---|
| GET | `/events?from=&to=` | 기간 목록 + 계획 요약 |
| GET | `/events/next` | 다음 일정 + 활성 계획 |
| POST | `/events` | 생성 |
| GET / PATCH / DELETE | `/events/{eventId}` | 조회 · 수정 · 삭제 |
| POST | `/events/{eventId}/review` | 분류 확인 응답 |

### 8.1 POST /events

```json
{
  "startsAt": "2026-08-20T14:00:00+09:00",
  "endsAt": "2026-08-20T15:00:00+09:00",
  "locationState": "required_resolved",
  "destinationName": "강남역",
  "destinationLat": 37.498,
  "destinationLng": 127.027,
  "meetingUrl": null,
  "eventKind": "meeting",
  "sourceType": "map_search",
  "anchorMode": "arrive_by",
  "originPlaceId": "uuid",
  "selectedRouteOptionId": "uuid",
  "displayLabel": "강남역 미팅",
  "writeToCalendarSourceId": "uuid"
}
```

| 필드 | 값 |
|---|---|
| `locationState` | `required_resolved` \| `required_missing` \| `not_required` \| `undecided` |
| `sourceType` | `internal` \| `external` \| `map_search` |
| `anchorMode` | `arrive_by`(기본) \| `depart_at` |

### 8.2 응답

- `locationState`가 `required_resolved`면 저장과 동시에 계획이 생성되어 응답에 동봉
- `not_required`면 `plan`은 `null`

### 8.3 표시명 처리 규약

- 응답 `displayName` 해석 순서: `displayLabel` → `destinationName` → `"오후 2시 일정"`
- 클라이언트는 **`displayName` 하나만 읽으면 됩니다**

### 8.4 POST /events/{eventId}/review

```json
// Request
{ "questionType": "is_online", "userAnswer": "offline" }
// Response
{ "data": { "eventId": "uuid", "locationState": "required_missing", "reviewClosed": true } }
```

- `classificationConfidence < 0.70`일 때만 클라이언트가 이 질문을 노출

---

## 9. 계획 (PLAN-01~05)

| Method | Path | 설명 |
|---|---|---|
| GET | `/plans/{planId}` | 계획 상세 |
| GET | `/events/{eventId}/plans/latest` | 활성 리비전 |
| POST | `/events/{eventId}/plan/recalculate` | 강제 재계산 |
| PATCH | `/plans/{planId}` | 사용자 직접 수정 |

### 9.1 GET /plans/{planId} — 주요 응답 필드

```json
{
  "data": {
    "planId": "uuid",
    "revisionNo": 3,
    "planStatus": "active",
    "eventStatus": "notified",
    "feasible": true,
    "predictionConfidence": "high",

    "prepStartAt":         "2026-08-16T12:25:00+09:00",
    "recommendedDepartAt": "2026-08-16T13:10:00+09:00",
    "targetArriveAt":      "2026-08-16T13:50:00+09:00",

    "breakdown": {
      "estimatedPrepMinutes": 35,
      "extraPrepMinutes": 5,
      "personalRoutineMinutes": 10,
      "travelMinutes": 42,
      "trafficBufferMinutes": 7,
      "arrivalBufferMinutes": 10
    },

    "reasons": [ { "field": "…", "source": "estimate|prepRule|routeProvider|environment", "adjusted": true, "text": "…", "sampleCount": 8 } ],
    "checklist": [ { "planPrepItemId": "uuid", "itemName": "영양제", "actionType": "consume", "sourceType": "rule", "completionStatus": "pending", "isSensitive": false, "appliedMinutes": 0 } ],
    "wellnessActions": [ { "wellnessActionId": "uuid", "wellnessTopic": "uv", "actionCode": "sunscreen", "actionLabel": "출발 전 선크림 확인", "displayRank": 1, "reasonSnapshot": "…", "completionStatus": "proposed" } ],

    "wellness": { "wisScore": 72, "wisBand": "high", "weightVersion": "w1", "eventArmed": true },
    "context": { "uvIndex": 8, "pm10": 45, "pm25": 22, "feelsLike": 31.2, "precipitationProb": 70, "estimatedOutdoorMinutes": 45 },

    "selectedRouteOptionId": "uuid",
    "degraded": []
  }
}
```

### 9.2 응답 필드 규약

- `planStatus`(`active`/`superseded`) ≠ `eventStatus`(`planned`→`notified`→`preparing`→`enroute`→`arrived`→`closed`)
- `reasons`·`checklist`·`wellnessActions`는 정렬하지 않고 보냄 — 화면 순서는 클라이언트가 결정
- `degraded` 값: `route_stale` · `env_unavailable` · `seed_missing` · `walk_speed_default`

### 9.3 계산 파이프라인

```
① targetArriveAt        = event.startsAt − arrivalBufferMinutes
② recommendedDepartAt   = targetArriveAt − travelMinutes − trafficBufferMinutes
③ prepStartAt           = recommendedDepartAt − estimatedPrepMinutes − extraPrepMinutes − personalRoutineMinutes
```

### 9.4 POST /events/{eventId}/plan/recalculate

```json
// Request
{ "reason": "user_request" }
// Response
{ "data": { "revisionNo": 3, "changed": false, "…": "§9.1" } }
```

### 9.5 PATCH /plans/{planId}

```json
{ "originPlaceId": "uuid", "prepStartAt": "2026-08-16T12:10:00+09:00" }
```

사용자 수정은 **새 리비전을 만듭니다.**

---

## 10. 경로 (MAP-01~04)

| Method | Path | 설명 |
|---|---|---|
| GET | `/plans/{planId}/routes` | 경로 후보 3종 |
| POST | `/plans/{planId}/routes/select` | 선택 (재계산 동반) |
| GET | `/routes/search` | 계획 없이 검색 |

### 10.1 GET /plans/{planId}/routes

```json
{
  "data": [
    { "routeOptionId": "uuid", "routeRank": 1, "routeType": "fastest",
      "totalMinutes": 42, "walkMinutes": 11, "transferCount": 1,
      "departAt": "…", "arriveAt": "…" },
    { "routeOptionId": "uuid", "routeRank": 2, "routeType": "least_walk", "totalMinutes": 47 },
    { "routeOptionId": "uuid", "routeRank": 3, "routeType": "least_transfer", "totalMinutes": 51 }
  ]
}
```

- **단위는 분** (`totalMinutes` / `walkMinutes`)
- MVP는 이 3종만 제공

### 10.2 POST /plans/{planId}/routes/select

```json
// Request
{ "routeOptionId": "uuid" }
// Response — 재계산된 새 리비전
{ "data": { "revisionNo": 4, "recommendedDepartAt": "…" } }
```

### 10.3 GET /routes/search (CAL-05 진입점)

```
GET /routes/search?originPlaceId=&originLat=&originLng=
                  &destLat=&destLng=&destName=
                  &anchorMode=arrive_by&at=2026-08-20T14:00:00%2B09:00
```

- `routeOptionId`는 **임시 키**(TTL 30분)
- `POST /events`에 `selectedRouteOptionId`로 전달하면 계획 생성 시점에 확정

---

## 11. 알림 (NOTI-01~05)

| Method | Path | 설명 |
|---|---|---|
| GET | `/notifications/today` | 당일 알림 로그 |
| POST | `/notifications/{notificationId}/respond` | 알림 액션 응답 |

### 11.1 알림 예산

| 슬롯 | `notificationType` | 예산 |
|---|---|---|
| **A** | `relaxed` 여유 | 일정당 1 |
| **B** | `critical` 극한 | 일정당 1 |
| **C** | `disruption` 돌발 | 일정당 1 — 최신 1건만 유지(교체) |
| **W** | `wellness_event` | 일정당 1 + 항목별 일일 상한 |

### 11.2 POST /notifications/{notificationId}/respond

```json
// 시간 알림
{ "action": "prep_started", "clientEventId": "uuid", "deviceTs": "…" }

// 웰니스 이벤트 알림
{ "action": "completed", "userRating": "useful", "clientEventId": "uuid" }
// action: completed | snoozed | stop_today | ignored
```

### 11.3 로컬 알림 이중화 (TR-07)

클라이언트가 `prepStartAt` / `recommendedDepartAt` 2건을 **로컬 알림으로 미리 예약**하고 서버 푸시가 먼저 오면 로컬을 취소합니다.

---

## 12. 웰니스 (WELL-01~06)

### 12.1 WIS 산식

```
WIS = min(100, 100 × (0.35·U + 0.25·P + 0.20·T + 0.20·O) × M)
```

| `wisBand` | `wisScore` | 동작 |
|---|---|---|
| `low` | 0~39 | 일정 상세에만 표시. 푸시 없음 |
| `mid` | 40~69 | 외출 전 준비 카드에 행동 1~2개 |
| `high` | 70~100 | 행동 제안 + 웰니스 이벤트 알림 후보 생성 |

### 12.2 행동 응답 기록 — 두 경로

| Method | Path | 대상 |
|---|---|---|
| POST | `/plans/{planId}/prep-items/{planPrepItemId}/resolve` | 준비 항목 완료 |
| POST | `/plans/{planId}/wellness-actions/{wellnessActionId}/resolve` | 웰니스 행동 완료 |

```json
// 준비 항목
{ "completionStatus": "completed", "clientEventId": "uuid" }   // pending | completed

// 웰니스 행동
{ "completionStatus": "completed", "clientEventId": "uuid" }   // proposed | completed | dismissed
```

### 12.3 웰니스 이벤트 발사 조건 — 6중 게이트

1. `wellnessEventEnabled` ∧ `USER_WELLNESS_PREF.isEnabled` (둘 다 기본값 false — opt-in)
2. `wisScore ≥ 70`
3. 야외 노출이 계속 진행 중
4. `remindIntervalMinutes` 도달 (사용자가 설정한 값)
5. 같은 일정·같은 `actionCode`에 `completed`/`stop_today` 없음
6. `dailyEventCap` 미소진

### 12.4 일일 마무리 카드 (WELL-05)

| Method | Path | 설명 |
|---|---|---|
| GET | `/summary/daily?date=` | 하루 요약 카드 |
| POST | `/summary/daily/{summaryId}/viewed` | 조회 기록 |

- `dwlBand`만 UI에 노출. `dwlScore`는 응답에 포함하되 클라이언트는 표시하지 않음
- 관리 일정 0건이면 `404`

---

## 13. 행동 기록 (REPORT-01)

| Method | Path | 설명 |
|---|---|---|
| POST | `/plans/{planId}/actions` | 행동 이벤트 배치 (최대 100건) |

```json
// Request
{
  "actions": [
    { "actionType": "prep_started", "actionSource": "user",
      "deviceTs": "2026-08-16T12:31:00+09:00", "clientEventId": "uuid" },
    { "actionType": "departed", "actionSource": "geo",
      "deviceTs": "2026-08-16T13:14:00+09:00", "clientEventId": "uuid", "confidence": 0.78 }
  ]
}
```

- `actionType`: `prep_started` | `snoozed` | `departed` | `item_checked` | `excluded`
- `actionSource`: `user` | `geo` | `system`
- **좌표는 전송하지 않고** 지오펜스 판정 결과만 전송
- 응답에 **갱신된 계획을 동봉**

---

## 14. 결과 · 피드백 (REPORT-01)

| Method | Path | 설명 |
|---|---|---|
| GET | `/events/{eventId}/execution` | 실행 결과 조회 |
| POST | `/events/{eventId}/feedback` | 사후 평가 |

### 14.2 POST /events/{eventId}/feedback

```json
{
  "prepTimingAssessment": "too_early",
  "arrivalResult": "on_time",
  "rushAssessment": "not_rushed"
}
```

- `prepTimingAssessment`: `too_early` | `appropriate` | `too_late` | `unknown`
- 일정당 1건. 재제출은 갱신

---

## 15. 개인화 (MODEL-01 · 02)

| Method | Path | 설명 |
|---|---|---|
| GET | `/me/personalization` | 현재 추정값 조회 |
| POST | `/me/personalization/revert` | 직전 보정 되돌리기 |
| DELETE | `/me/personalization` | 초기화 |

```json
{
  "data": {
    "estimates": [
      { "scopeType": "global", "estimatedMinutes": 35, "sampleCount": 8, "confidence": 0.71,
        "adjustmentReason": "저녁 약속에서 평균 12분 늦게 출발" }
    ],
    "trafficBufferMinutes": 7,
    "notificationLeadMinutes": 20
  }
}
```

- MVP는 `scopeType: "global"`만 사용

---

## 16. 데이터 삭제 · 계정 수명주기

| 전이 | API | 처리 |
|---|---|---|
| **로그아웃** | `POST /auth/logout` | refresh 폐기. **데이터 유지** |
| **개인화 초기화** | `DELETE /me/personalization` | PrepEstimate 무효화. **ActionLog 유지** |
| **탈퇴** | `DELETE /me` | CASCADE 하드 삭제. `USER_CONSENT`만 잔존 |

---

## 17. 에러 코드

**공통:** `INVALID_ARGUMENT` · `VALIDATION_ERROR` · `UNAUTHORIZED` · `FORBIDDEN` · `NOT_FOUND` · `CONFLICT` · `RATE_LIMITED` · `INTERNAL_ERROR` · `APP_VERSION_UNSUPPORTED`(426)

**도메인 주요 코드:**

| 코드 | 상황 | `retryable` |
|---|---|---|
| `AUTH_INVALID_CREDENTIALS` | 이메일/비밀번호 불일치 (구분 안 함) | false |
| `ACCOUNT_LOCKED` | 연속 실패 잠금(423). `retryAfterSec` 동반 | **true** |
| `EMAIL_ALREADY_LINKED` | 이미 Google로 가입된 이메일(409) | false |
| `EMAIL_VERIFICATION_REQUIRED` | 이메일 미인증(403) | false |
| `AUTH_TOKEN_INVALID` | 토큰 만료·소비·위조 | false |
| `WEAK_PASSWORD` | 비밀번호 정책 미달 | false |
| `EVENT_NOT_FOUND` | 없거나 타 사용자 자원 | false |
| `PLAN_INFEASIBLE` | 지금 출발해도 늦음 (`feasible=false`) | false |
| `ROUTE_PROVIDER_UNAVAILABLE` | 경로 API 실패 | **true** |
| `WELLNESS_DATA_UNAVAILABLE` | 환경 API 실패 | **true** |
| `SENSITIVE_CHIP_REJECTED` | 민감 항목을 추천 칩으로 등록 시도 | false |
| `PREP_MINUTES_RULE_VIOLATION` | `timed_routine`이 아닌데 `defaultMinutes` 지정 | false |
| `SUMMARY_NOT_GENERATED` | 관리 일정 0건이라 카드 없음(404) | false |

> **저하 응답은 에러가 아닙니다.** 경로·환경 API 실패 시에도 계획 응답은 `200`으로 나가고 `degraded` 배열에 사유가 담깁니다.

---

*Ensom API 명세서 v5.0 · PRD v0.4.3 · ERD v3.1 · TRD v4.0 · 2026-08-17*
