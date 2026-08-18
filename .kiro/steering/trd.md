# Ensom TRD v4.0 — 기술 요구사항 정의서

| 항목 | 내용 |
|---|---|
| 문서 버전 | v4.0 |
| 작성일 | 2026-08-17 |
| 상위 문서 | **PRD v0.4.3** — 충돌 시 PRD가 기준 |
| 백엔드 | Java 21 · Spring Boot 4.1.0 · PostgreSQL 16 |
| 프론트 | **Flutter · Riverpod · Drift** |
| 경로·지도 | **ODsay 대중교통 API · 카카오맵 SDK** |
| 인증 | **이메일 계정 · Google 계정** 2종 |

---

## 절대 원칙

| # | 원칙 | 무너지면 생기는 일 |
|---|---|---|
| **1** | **계획과 웰니스 판단의 권위는 서버가 단독으로 가진다** | 앱이 꺼진 사용자에게 제품의 핵심 가치가 사라진다 |
| **2** | **자기 보고는 시드이고, 관측된 편차가 진실이다** | 잘못된 추정치를 앱이 그대로 반복한다 |
| **3** | **의료 경계를 넘지 않는다** — 진단·치료·용량·효능·피부 판정 금지. WIS·RLS·DWL은 알림 우선순위 값이지 건강 점수가 아니다 | 규제 리스크 |
| **4** | **근거 없는 계획을 반환하지 않는다** | PLAN-03과 설명가능성이 성립하지 않는다 |
| **5** | **사용자가 지정한 값이 자동 판단을 항상 이긴다** | 자동 분류 오류가 사용자 의사를 덮어쓴다 |
| **6** | **알림은 예산 안에서만 나간다** — 시간 3회 + 웰니스 1회 | 알림 피로 → 전체 차단 → 제품 사망 |
| **7** | **지도는 기본 경로 기능만 제공한다** — 환경 레이어·센서·자체 경로 점수 없음 | PRD §17.2·§18 논쟁 재발 |
| **8** | **원문과 경로는 오래 머무르지 않는다** — 외부 일정 제목 원문·하루 전체 이동 경로 미보관 | PRD §20.2 최소 수집 위반 |

---

## 1. 시스템 아키텍처

### 컴포넌트 책임 경계

| 컴포넌트 | 책임 | 책임이 아닌 것 |
|---|---|---|
| **planengine** | 스냅샷 → 시각 3개 + 근거 분해 + 체크리스트 초안 | DB·네트워크·현재 시각 — 전부 주입받는다 |
| **wellness** | 환경 + 야외 노출 → WIS·행동 ≤3, DWL 집계 | 건강 판단. 우선순위만 계산 |
| **orchestrator** | 재평가 시점, 실질 변화 판정, 알림 예산 집행 | 계산 자체. 두 엔진을 호출할 뿐 |
| **personalization** | 행동·결과 → 준비/버퍼/알림 시점을 원인별 갱신 | 계획 생성. 값만 제공 |
| **calendar** | 증분 동기화, 변경·삭제 반영, **제목 원문 즉시 폐기** | 분류·계획 |
| **provider** | 외부 호출·정규화·캐시·쿼터·폴백 | 제품 의미 해석 |
| **앱 UI** | 계획 표현, 행동 기록, 체크리스트 조작 | 권위 있는 시각 계산 |

> **TR-01** — 앱이 종료된 상태에서도 교통 변화로 출발 시각을 앞당기고, 야외 노출 지속 조건을 평가해 재도포 알림을 보내야 합니다. 클라이언트는 확정된 값까지 남은 시간만 표시합니다.

---

## 2. 기술 스택 (Flutter FE 관련)

| 영역 | 선택 | 근거 |
|---|---|---|
| **앱** | Flutter + Riverpod + Drift | 4화면 + 하단 탭. 오프라인 큐가 1급 시민 |
| **지도 렌더** | **카카오맵 SDK** | 국내 POI·타일 품질. 렌더링 전용이며 경로 계산에는 쓰지 않는다 |
| **인증** | 이메일 계정 + Google 계정 | Google은 Calendar OAuth와 동의 화면 통합 |

### 시간 처리 규약 (TR-02)

- 저장은 전부 `timestamptz`(UTC). 응답은 **오프셋 포함 ISO-8601 필수**
- `Z`만 오는 값은 거부 (`422`)
- 종일 일정은 계획 대상에서 제외
- `EVENT_ACTION_LOG.action_at`은 **기기 시각**. 서버 수신 시각과 ±120초를 넘으면 학습 제외
- 엔진은 `now`를 **주입받는다.** `Instant.now()` 직접 호출 금지

---

## 3. 데이터 모델 핵심

### 준비 항목 3단 체인 (ERD v3 · PLAN-05 핵심)

```
USER_PREP_RULE          "나는 영양제를 챙긴다"          원형. 사용자 소유
   rule_category × action_type · rule_timing · default_minutes
      │
      ▼
EVENT_PREP_ITEM         "이 일정에는 영양제가 필요"      일정 파생
      │
      ▼
PLAN_PREP_ITEM          "이 계획의 체크리스트 · 완료"    계획 스냅샷
   item_name_snapshot · applied_minutes · completion_status
```

**2축 분류**

| `rule_category` | `action_type` | 시간 반영 |
|---|---|---|
| `general_item` 반복 준비물 | `carry` 챙기기 | 없음 |
| `supplement` 영양제 | `consume` 사용·섭취하기 | 없음 |
| `personal_item` 개인 기호 품목 | `purchase` 구매하기 | 없음 |
| `routine` 시간 소요 루틴 | `timed_routine` | **`default_minutes`만큼 준비 시간에 합산** |
| `medication` 복용약 | (사용자 선택) | `is_sensitive = true` 강제 |

### 일정 생명주기 vs 계획 리비전

- **`EVENT.status`**: `planned` → `notified` → `preparing` → `enroute` → `arrived` → `closed`
- **`PLAN_REVISION.plan_status`**: `active` | `superseded` — 일정당 active 1건

### 스키마 델타 (ERD v3 → v3.1) — M0에 전부 포함

```sql
ALTER TABLE plan_revision ADD COLUMN next_eval_at timestamptz;
ALTER TABLE plan_revision ADD COLUMN input_hash   text;
ALTER TABLE notification ADD COLUMN dedup_key text;
ALTER TABLE notification ADD CONSTRAINT uq_notification_dedup UNIQUE (dedup_key);
ALTER TABLE event ADD COLUMN display_label text;
ALTER TABLE user_prep_rule ADD COLUMN from_chip boolean NOT NULL DEFAULT false;
ALTER TABLE user_prep_estimate ADD COLUMN adjustment_reason text;
ALTER TABLE users ADD COLUMN email_verified_at timestamptz;
ALTER TABLE users ADD CONSTRAINT uq_users_email UNIQUE (email);

CREATE TABLE user_credential (
  user_id uuid PRIMARY KEY REFERENCES users(user_id) ON DELETE CASCADE,
  password_hash text NOT NULL, password_algo text NOT NULL DEFAULT 'argon2id',
  failed_attempts smallint NOT NULL DEFAULT 0, locked_until timestamptz
);

CREATE TABLE auth_token (
  token_id uuid PRIMARY KEY, user_id uuid NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
  purpose text NOT NULL, -- 'email_verify' | 'password_reset'
  token_hash text NOT NULL, -- SHA-256. 원문은 저장하지 않는다
  expires_at timestamptz NOT NULL, consumed_at timestamptz
);

CREATE TABLE engine_config (
  config_key text PRIMARY KEY, config_value jsonb NOT NULL, version text NOT NULL
);
```

---

## 4. Plan Engine

### 계산 파이프라인 (5단계)

```
① targetArriveAt        = event.startsAt − arrivalBufferMinutes
② recommendedDepartAt   = targetArriveAt − travelMinutes − trafficBufferMinutes
③ prepStartAt           = recommendedDepartAt
                            − estimatedPrepMinutes        (USER_PREP_ESTIMATE)
                            − extraPrepMinutes            (환경 가산)
                            − personalRoutineMinutes      (Σ timed_routine)
④ 제약 해결             → 충돌 시 feasible=false (TR-04, 제약을 깨지 않는다)
⑤ 체크리스트 초안       → EVENT_PREP_ITEM 투영 + 웰니스 행동 병합
```

### 체크리스트 합성 규칙 (PLAN-05)

- 사용자가 선크림 등록 + 웰니스도 sunscreen 제안 → **PLAN_PREP_ITEM 1건으로 합치고** `sourceType='rule'` 유지, 근거만 웰니스 것 추가
- 상한: 맞춤 3개 + 웰니스 3개
- **정렬하지 않는다** — `sourceType`·`displayRank` 태그만 실어 보내고 화면 순서는 클라이언트가 결정

> **TR-04** — 엔진은 영양제·복용약·기호 품목의 섭취 필요성·용량·효능·건강 추론을 하지 않습니다. ERD `USER_PREP_RULE`에 성분·용량·효능 필드가 없어 **판단할 데이터 자체가 없습니다.**

---

## 5. 개인화 — 원인 분리 보정

> **TR-05** — 하나의 관측은 정확히 하나의 손잡이만 조정한다.

### 손잡이 라우팅

| 원인 | 조정 대상 |
|---|---|
| `prep_overrun` | `USER_PREP_ESTIMATE.estimated_minutes` (EMA 갱신) |
| `prep_late` | 알림 선행 시간 확대 |
| `depart_late` | 출발 알림 강화 |
| `traffic` | `traffic_buffer_minutes` |
| `external` | 학습에서 제외 |

```
P ← (1−α)·P + α·Dactual     α = 0.30
arrival ∈ {late, rushed} → α ×1.5
arrival = 'early'         → α ×0.7
가드레일: P ∈ [10, 시드×2] · 1회 변화 ≤ 15분
콜드 스타트: sampleCount < 3 → 시드 유지
SEED_FALLBACK_MIN = 30 (initialPrepMinutes가 null일 때)
```

---

## 6. 웰니스 엔진

### WIS 정규화 초기값

| 항 | 원천 | 정규화 |
|---|---|---|
| U (자외선) | 기상청 | 0→0 · 6→0.6 · 8→0.8 · 11+→1.0 선형 |
| P (대기질) | 에어코리아 | 좋음 0 · 보통 0.25 · 나쁨 0.7 · 매우나쁨 1.0 |
| T (열환경) | 체감온도+강수 | 쾌적(5~28℃) 0 → 폭염·한파 1.0 선형 |
| O (야외 노출) | `ROUTE_OPTION.walk_minutes` | `min(1, 분/120)` |
| M (관심 항목) | `USER_WELLNESS_PREF` | 1.0 ~ 1.25 |

### 야외 노출 판별 (지상/지하 구분)

```
ODsay subPath 순회:
  trafficType=3 (도보)이고
  직전·직후가 지하철이며 구간 < 3분  → 지하 환승 통로로 제외
  그 외 도보                          → estimatedOutdoorMinutes 에 가산
버스 승하차 도보는 지상으로 간주
판별 불가 구간 → 야외로 계산하지 않고 degraded에 기록
```

### 웰니스 이벤트 6중 게이트 (TR-11)

1. `wellnessEventEnabled` ∧ `USER_WELLNESS_PREF.isEnabled` (둘 다 기본값 **false** — opt-in)
2. `wisScore ≥ 70`
3. 야외 노출이 계속 진행 중
4. `remindIntervalMinutes` 도달 (**사용자가 설정한 값**. 서비스가 판단하지 않는다)
5. 같은 일정·같은 `actionCode`에 `completed`/`stop_today` 없음
6. `dailyEventCap` 미소진 (항목별 **하루** 상한)

> **TR-09** — 웰니스 카피에 생성 모델 사용 금지. 사전 승인된 템플릿(PRD 부록 B.4)만 사용. CI가 템플릿 외 문자열 유입을 검사합니다.

---

## 7. 알림 오케스트레이션

### 알림 슬롯

| 슬롯 | 유형 | 예산 |
|---|---|---|
| **A** | `relaxed` 여유 | 일정당 1 |
| **B** | `critical` 극한 | 일정당 1 |
| **C** | `disruption` 돌발 | 일정당 1 — **최신 1건만 유지(교체)** |
| **W** | `wellness_event` | 일정당 1(`sequence_no`) + 항목별 일일 상한 |

### 실질 변화 판정

```
Δ = |new.recommendedDepartAt − current.recommendedDepartAt|

Δ < 2분        → 리비전조차 만들지 않음
2분 ≤ Δ < 5분  → 새 리비전 · 홈 갱신 · 푸시 없음 (로그에만)
Δ ≥ 5분        → 새 리비전 + 돌발 슬롯(C)

즉시 알림 예외 (Δ 무관):
  · feasible: true → false
  · 경로 수단 변경
  · 강수 등급 none → heavy
```

> **TR-07** — 준비 시작·출발 임박 2건을 **로컬 알림으로 미리 예약**하고, 서버 푸시가 먼저 도착하면 로컬을 취소합니다. 동일 `dedupKey`를 로컬 알림 식별자로 사용합니다.

---

## 8. 출발·도착 확인 (지오펜스)

> **TR-08** — 지오펜스는 활성 계획 1건 · 리전 2개로 제한합니다 (iOS 20개 한도 대응).

### 신뢰도 계산

```
confidence = 0.5
           + 0.20 체류 90초 충족
           + 0.15 수평 정확도 < 50m
           + 0.15 진입 시각이 예상 도착 ±20분 이내
           − 0.30 경계 진동 (60초 내 진입/이탈 반복)

≥ 0.6 자동 확정
0.4~0.6 조용한 확인 요청
< 0.4 unresolved
```

**서버는 지오펜스를 실행하지 않습니다.** 판정 결과 수신 API만 제공합니다 (`/plans/{id}/actions`, `source='geo'`). **좌표는 전송하지 않고** 판정 결과만 전송합니다 (절대 원칙 8).

---

## 9. 인증과 회원 수명주기

### 두 인증 경로

| 경로 | `provider` | 비밀번호 | 이메일 인증 |
|---|---|---|---|
| **이메일 계정** | `email` | `USER_CREDENTIAL`에 Argon2id 해시 | **필수** — 미인증 시 핵심 API `403` 차단 |
| **Google 계정** | `google` | 없음 | Google이 소유 증명 → 자동 완료 |

### 이메일 계정 보안 규약 (TR-14)

- **인증 응답은 계정의 존재를 노출하지 않는다** — 이메일 없음·비밀번호 틀림 구분 없이 동일한 `AUTH_INVALID_CREDENTIALS` 반환
- 비밀번호 정책: 최소 10자, 이메일 로컬파트·서비스명 포함 금지
- 연속 5회 실패 → 15분 잠금 (`locked_until`)
- 토큰 원문은 저장하지 않음 — `AUTH_TOKEN.token_hash`(SHA-256)만 저장
- 비밀번호 변경·재설정 완료 시 **해당 사용자의 모든 refresh 토큰 폐기**

### 이메일 미인증 상태

- 로그인 자체는 되지만 핵심 API는 `403 EMAIL_VERIFICATION_REQUIRED`로 차단
- 로그인 응답에 `emailVerificationRequired: true` 포함

### iOS 출시 확인

Google 로그인을 제공하므로 App Store 심사에서 Apple 로그인 병행을 요구받을 수 있음. 요구받으면 `USER_IDENTITY.provider`에 `apple`을 추가 — 스키마·API 계약 변경 없음.

---

## 10. 외부 연동

### 장애 시 저하 매트릭스

| 실패 | 동작 |
|---|---|
| 경로 API | 마지막 성공 경로 재사용 + 교통 버퍼 2배 |
| 환경 API | 웰니스 행동·WIS 생략. **시간 계획 정상** |
| 캘린더 | 마지막 스냅샷 + 지수 백오프 |
| FCM | 로컬 알림 폴백 (TR-07) |

**공통 원칙: 계산을 멈추지 않는다.** 입력이 없으면 기본값으로 진행하고 `degraded`에 기록.

### 표시명 처리 (D17)

- `EVENT.display_label` = 사용자가 입력·승인한 표시명만 저장
- 외부 캘린더 제목 원문 = **저장하지 않음**, 분류 후 즉시 폐기
- 응답 `displayName` 해석 순서: `displayLabel` → `destinationName` → `"오후 2시 일정"`
- **클라이언트는 `displayName` 하나만 읽으면 됩니다**

---

## 11. API 공통 규약

| 항목 | 규약 |
|---|---|
| 인증 | `Authorization: Bearer <JWT>` · 모든 자원은 `userId`로 행 수준 필터 · 교차 접근은 **404** |
| 멱등성 | 모든 POST/PUT에 `Idempotency-Key` 헤더 필수. 24시간 내 동일 키 → 이전 응답 재생 |
| 시각 | ISO-8601 오프셋 필수. `Z`만 오는 값은 `422` 거부 |
| 오류 | `{"error":{"code":"…","message":"…","retryable":bool}}` |
| 버전 | `X-App-Version` → 최소 지원 미만이면 `426` |
| 행동 배치 | 최대 100건 · 요청 1MB |

> **TR-03** — `EVENT_ACTION_LOG.client_event_id` UNIQUE 제약으로 오프라인 재전송 중복 흡수. `duplicated` 카운트는 오류가 아니라 **정상 결과**입니다.

---

## 12. 프라이버시 엔지니어링

### 민감 항목 3중 경계 (TR-10)

① **표시 경계** — 잠금화면·푸시에는 일반화 문구만 (`body_masked`)
② **추천 경계** — 민감·규제 품목은 추천 칩에 없음. `fromChip ∧ isSensitive` → 서버 거부
③ **집계 경계** — 리포트·일일 요약·지표 이벤트 입력에서 민감 항목명 원천 제외

### 삭제 3단

| 전이 | 클라이언트 | 서버 |
|---|---|---|
| **로그아웃** | 토큰·민감 캐시 소거 · 예약 로컬 알림 취소 | refresh 폐기 · **데이터 유지** |
| **개인화 초기화** | 캐시 갱신 | PrepEstimate 무효화. **ActionLog는 유지** |
| **탈퇴** | 로컬 전체 소거 | CASCADE 하드 삭제. `USER_CONSENT`만 잔존 |

---

## 13. 성능 예산과 SLO

| 항목 | 목표 |
|---|---|
| 홈 첫 일정 카드 | ≤ 400ms (로컬 캐시 우선 렌더) |
| 계획 생성 전체 | p95 ≤ 5s |
| WIS + 행동 제안 | p95 ≤ 2s |
| 재계산(캐시 적중) | p95 ≤ 400ms |
| 알림 발송 지연 | p95 ≤ 30s |
| 액션 배치 업로드 | p95 ≤ 800ms (100건 기준) |
| 배터리 추가 소모 | ≤ 2%/일 |
| 앱 콜드 스타트 | ≤ 2.0s (중급 Android) |

---

## 14. 마일스톤

| 단계 | 산출물 | 완료 판정 |
|---|---|---|
| **M0 기반** | ERD v3 전체 스키마 · 이메일+Google 로그인 · 캘린더 읽기 · Provider 스텁 | 로그인 → 일정 유입 → 스텁 경로로 계획 생성 E2E |
| **M1 엔진** | Plan Engine + 근거 분해 + 체크리스트 합성 · `/prep-items` CRUD | PRD §12.4 예시가 골든으로 재현 |
| **M2 순환** | Orchestrator · 시간 알림 3종 · 행동 이벤트 + 오프라인 큐 · 원인 분리 보정 | 알림 → 원탭 기록 → 다음 계획 보정이 한 바퀴 돎 |
| **M3 웰니스** | Wellness Engine(WIS·행동 매핑) · 이벤트 스케줄러 · 템플릿 카피 + 린트 | 야외 일정에서 행동 제안 ≤3개 · 재도포 푸시 1회 |
| **M4 완결** | 지도 화면(기본 경로·캘린더 저장) · 지오펜스 · 일일 마무리 카드 · 삭제 3단 | PRD §30 출시 기준 전 항목 충족 |
| **M5 경화** | 저하 매트릭스 검증 · 지표 대시보드 · 실기기 3기종 · 콘텐츠 검토 | SLO 측정 가능 · 예산 위반 0건 · 베타 배포 가능 |

**M0에서 반드시 포함:**
- `engine_config` 테이블 (TR-06)
- 스키마 델타 6종 전부 (`next_eval_at`, `input_hash`, `dedup_key`, `display_label`, `from_chip`, `adjustment_reason`)
- `POST /consents` · `POST /push-devices`

---

## 15. 기술 요구사항 (TR) 요약

| ID | 요구사항 |
|---|---|
| **TR-01** | 계획·웰니스 판단의 권위는 서버 단독 |
| **TR-02** | 시간대 규약 5항 · 기기 시계 불신 (±120초 초과 시 학습 제외) |
| **TR-03** | 행동 이벤트는 클라이언트 생성 멱등 키 필수 (`clientEventId`) |
| **TR-04** | 엔진은 사용자 등록 사실을 판단하지 않음. 제약 충돌 → `feasible=false` |
| **TR-05** | 하나의 관측은 하나의 손잡이만 조정 (원인 분리 라우팅) |
| **TR-06** | 모든 상수는 원격 설정. 변경 시 버전 증가. `engine_config`는 M0 필수 |
| **TR-07** | 준비·출발 알림은 로컬 알림으로 이중화 (FCM 전송 시각 미보장) |
| **TR-08** | 지오펜스는 활성 계획 1건·리전 2개 제한 (iOS 20개 한도) |
| **TR-09** | 웰니스 카피에 생성 모델 금지 — 승인 템플릿 전용 |
| **TR-10** | 민감 준비 항목의 3중 경계 (표시·추천·집계) |
| **TR-11** | 웰니스 푸시 6중 게이트 — 동의×점수×노출×주기×미완료×일일 상한 |
| **TR-12** | 분류 미응답 창 24시간 상한 후 원문 자동 폐기. 리뷰 행은 90일 보존 |
| **TR-13** | 계산 계층은 프레임워크에 의존하지 않음 (ArchUnit 강제) |
| **TR-14** | 인증 응답은 계정의 존재를 노출하지 않음 (더미 해시 검증으로 응답 시간도 동일) |

---

## 16. 파라미터 레지스트리 (주요값)

> **TR-06** — 전부 `engine_config` 테이블에 두고 원격 설정으로 관리합니다.

| 파라미터 | 값 |
|---|---|
| `ARRIVAL_BUFFER_MIN` | 10 |
| `TRAFFIC_BUFFER_MIN` | 5 |
| `RAIN_EXTRA_PREP_MIN` | 5 |
| `SILENT_SHIFT_MIN` | 2 |
| `MATERIAL_SHIFT_MIN` | 5 |
| `PREP_EMA_ALPHA` | 0.30 |
| `LATE_WEIGHT` / `EARLY_WEIGHT` | 1.5 / 0.7 |
| `MAX_STEP_MIN` | 15 |
| `PREP_FLOOR_MIN` / `PREP_CEIL_RATIO` | 10 / 2.0 |
| `SEED_FALLBACK_MIN` | 30 |
| `CLASSIFY_MIN_CONF` | 0.70 |
| `TITLE_PURGE_HOURS` | 24 |
| `PASSWORD_MIN_LENGTH` | 10 |
| `LOGIN_FAIL_LOCK_THRESHOLD` / `LOGIN_LOCK_MINUTES` | 5 / 15 |
| `EMAIL_VERIFY_TTL_HOURS` | 24 |
| `PASSWORD_RESET_TTL_MIN` | 30 |
| `WIS_W_UV` / `PM` / `TEMP` / `OUTDOOR` | .35 / .25 / .20 / .20 |
| `WIS_BAND_CARD` / `WIS_BAND_EVENT` | 40 / 70 |
| `WELLNESS_EVENT_DEFAULT_ON` | **false** (opt-in) |
| `DAILY_EVENT_CAP_DEFAULT` | 1 |
| `OUTDOOR_CAP_MIN` | 120 |
| `GEOFENCE_ORIGIN_R_M` | 150 |
| `GEOFENCE_DEST_R_M` | 100 / 150 / 200 (유형별) |
| `DWELL_SEC` / `AUTO_CONF` | 90 / 0.60 |
| `TICK_INTERVAL_MS` | 30000 |
| `TRANSFER_WALK_INDOOR_MAX_MIN` | 3 |

---

*Ensom TRD v4.0 · 상위 문서 PRD v0.4.3 · 2026-08-17 · 늦지 않게, 서두르지 않게.*
