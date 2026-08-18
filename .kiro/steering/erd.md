# Ensom ERD v3.1 — PRD v0.4.3 반영본

> 기준 문서: PRD v0.4.3 (2026-08-16)
> 설계 축: 5개 시간축 분리(계획·행동·결과·평가·추정)를 웰니스 레이어에도 동일 적용
> 핵심 원칙: WIS·RLS·DWL은 **의료 점수가 아니라 알림 우선순위 값** (`score_purpose = 'priority_only'`)

---

## 0. 시간축 분리 원칙

| 종류 | 시간 관리 | 웰니스 |
|---|---|---|
| **계획** | `PLAN_REVISION` | `PLAN_WELLNESS_SCORE`, `PLAN_WELLNESS_ACTION` |
| **행동** | `EVENT_ACTION_LOG` | `PLAN_WELLNESS_ACTION.completion_status` |
| **결과** | `EVENT_EXECUTION` | `EVENT_EXECUTION.rush_load_score` (RLS) |
| **평가** | `EVENT_FEEDBACK` | `WELLNESS_EVENT_SCHEDULE.user_rating` |
| **추정** | `USER_PREP_ESTIMATE` | `DAILY_WELLNESS_SUMMARY` (DWL) |

---

## 1. 주요 엔티티 요약

### USERS

```
uuid user_id PK
text email (UNIQUE)
text nickname
text timezone
text account_status "active/withdrawn"
timestamptz email_verified_at
timestamptz created_at
timestamptz withdrawn_at
```

### USER_IDENTITY

```
uuid identity_id PK
uuid user_id FK
text provider "email/google"
text provider_uid
timestamptz linked_at
UNIQUE (provider, provider_uid)
```

### USER_CREDENTIAL (이메일 계정만)

```
uuid user_id PK FK (CASCADE)
text password_hash  -- Argon2id
text password_algo  -- 'argon2id'
timestamptz password_updated_at
smallint failed_attempts DEFAULT 0
timestamptz locked_until
```

### AUTH_TOKEN (이메일 인증 · 비밀번호 재설정)

```
uuid token_id PK
uuid user_id FK (CASCADE)
text purpose  -- 'email_verify' | 'password_reset'
text token_hash  -- SHA-256. 원문은 저장하지 않는다
timestamptz expires_at
timestamptz consumed_at
UNIQUE INDEX (token_hash)
```

### USER_SETTING

```
uuid user_id PK FK
int initial_prep_minutes  -- NULL 허용 ("잘 모르겠어요")
int arrival_buffer_minutes
text notification_sensitivity
bool personalization_enabled
bool auto_manage_enabled
bool wellness_event_enabled  -- 웰니스 이벤트 푸시 전체 on/off
bool lockscreen_hide_sensitive
```

### USER_WELLNESS_PREF

```
uuid user_id PK FK
text wellness_topic PK  -- uv/pm/temp/rain/hydration
bool is_enabled
int remind_interval_minutes  -- 사용자 직접 설정
int daily_event_cap  -- 기본 1
```

### USER_PLACE

```
uuid place_id PK
uuid user_id FK
text place_type / place_name / address
double lat / lng  -- 애플리케이션 레벨 AES-GCM 암호화
bool is_primary
timestamptz deleted_at  -- 소프트 삭제
```

### USER_PREP_RULE (맞춤 준비 규칙 원형)

```
uuid prep_rule_id PK
uuid user_id FK
text rule_name
text rule_category  -- supplement/medication/personal_item/routine/general_item
text action_type    -- carry/consume/purchase/timed_routine
text rule_timing    -- pre_departure/post_arrival
int default_minutes -- timed_routine만 값 존재 (ck_prep_minutes 강제)
text apply_event_kind / apply_time_band / apply_weather
uuid apply_place_id
bool is_required / is_sensitive / is_active
bool from_chip  -- 추천 칩 선택 여부 (지표 원천)
timestamptz deleted_at
```

### CALENDAR_CONNECTION + CALENDAR_SOURCE

```
CALENDAR_CONNECTION: connection_id, user_id, provider, external_account_id, refresh_token_enc
CALENDAR_SOURCE: source_id, connection_id, external_calendar_id, display_name, is_writable, is_default
```

### EVENT

```
uuid event_id PK
uuid user_id FK
uuid calendar_source_id FK (NULL = 내부 생성)
text external_event_id
text source_type  -- internal/external/map_search
timestamptz starts_at / ends_at
text location_state  -- required_resolved/required_missing/not_required/undecided
text destination_name
double destination_lat / destination_lng
text meeting_url
text event_kind
text display_label  -- 사용자가 입력·승인한 표시명만
bool auto_manage_excluded
text status  -- planned→notified→preparing→enroute→arrived→closed
```

### EVENT_CLASSIFICATION_REVIEW

```
uuid review_id PK
uuid event_id FK
text title_snapshot  -- 분류 완료 후 즉시 NULL 처리 (ck_title_purged 강제)
text question_type
text user_answer
numeric classification_confidence
timestamptz title_purged_at
```

### PLAN_REVISION (계획 리비전 — 불변, 쌓는다)

```
uuid plan_id PK
uuid event_id FK
int revision_no
uuid origin_place_id FK
text/double origin_snapshot_name/lat/lng
uuid selected_route_option_id FK
timestamptz prep_start_at / recommended_depart_at / target_arrive_at
int estimated_prep_minutes     -- 분해 컬럼 ①
int extra_prep_minutes         -- 분해 컬럼 ② (환경 가산)
int personal_routine_minutes   -- 분해 컬럼 ③ (Σ timed_routine)
int travel_minutes             -- 분해 컬럼 ④
int traffic_buffer_minutes     -- 분해 컬럼 ⑤
text prediction_confidence
text plan_status  -- active/superseded (uq_active_plan_per_event: 일정당 active 1건)
text calc_version
timestamptz next_eval_at  -- 재평가 큐
text input_hash           -- 동일 입력 재계산 조기 종료
```

### ROUTE_OPTION

```
uuid route_option_id PK
uuid plan_id FK
int route_rank (1~3)
text route_type  -- fastest/least_walk/least_transfer
int total_minutes
int walk_minutes  -- ★ 야외 노출 추정의 핵심 입력
int transfer_count
timestamptz depart_at / arrive_at
jsonb route_payload
```

### PLAN_CONTEXT (환경 스냅샷)

```
uuid plan_id PK FK
numeric temperature / feels_like / precipitation_prob
int uv_index / pm10 / pm25
int estimated_outdoor_minutes  -- 도보 구간 합산 추정치
text weather_provider / air_provider
timestamptz observed_at
```

### PLAN_WELLNESS_SCORE

```
uuid plan_id PK FK
numeric uv_load / pm_load / thermal_load / outdoor_load  -- 0~1
numeric interest_multiplier  -- M 1.0~1.25
int wis_score  -- 0~100 (ck_wis_band CHECK 강제)
text wis_band  -- low(0~39) / mid(40~69) / high(70~100)
text weight_version
```

### PLAN_WELLNESS_ACTION

```
uuid wellness_action_id PK
uuid plan_id FK
text wellness_topic
text action_code  -- sunscreen/mask/hydration/outerwear/umbrella
text action_label
int display_rank  -- 1~3 (ck_wellness_rank CHECK 강제)
text reason_snapshot  -- 제안 근거 (설명가능성)
text completion_status  -- proposed/completed/dismissed
```

### WELLNESS_EVENT_SCHEDULE

```
uuid wellness_event_id PK
uuid plan_id FK
uuid notification_id FK
text action_code
int interval_minutes_snapshot  -- 사용자 설정값 스냅숏
timestamptz scheduled_at / sent_at
text response_action  -- completed/snoozed/stop_today/ignored
text user_rating  -- useful/not_relevant/null
int sequence_no  -- 동일 일정 내 회차 (uq_wellness_event_once)
timestamptz cancelled_at
text cancel_reason  -- indoor/plan_changed/user_completed
```

### PLAN_PREP_ITEM (체크리스트 스냅샷)

```
uuid plan_prep_item_id PK
uuid plan_id FK
uuid prep_rule_id FK
uuid event_prep_item_id FK
text item_name_snapshot / action_type_snapshot
int applied_minutes  -- timed_routine만 > 0
bool is_sensitive
text source_type  -- rule/event_item/weather
text completion_status  -- pending/completed
```

### EVENT_PREP_ITEM (일정 파생)

```
uuid event_prep_item_id PK
uuid event_id FK
uuid source_prep_rule_id FK
text item_name / action_type
int estimated_minutes
bool is_required / is_sensitive
```

### NOTIFICATION

```
uuid notification_id PK
uuid plan_id FK
text notification_category  -- time/wellness (ck_noti_category CHECK)
text notification_type  -- relaxed/critical/disruption/wellness_event
text dedup_key  -- UNIQUE (중복 발송 방지)
timestamptz scheduled_at / sent_at
text delivery_status
text body_masked  -- 민감 항목 일반화 문구
text trigger_reason  -- 알림 로그 표시용
```

### EVENT_ACTION_LOG

```
uuid action_log_id PK
uuid event_id FK / plan_id FK / notification_id FK
text action_type  -- prep_started/snoozed/departed/item_checked/excluded
text action_source  -- user/geo/system
timestamptz action_at
uuid client_event_id UK  -- 오프라인 재전송 멱등성
```

### EVENT_EXECUTION

```
uuid event_id PK FK
uuid final_plan_id FK
timestamptz actual_prep_started_at / actual_departed_at / actual_arrived_at
text arrival_result  -- early/on_time/rushed/late/unknown
text result_source  -- user/geo/inferred
int actual_outdoor_minutes
numeric prep_delay_norm / depart_delay_norm / critical_alert_norm  -- 0~1
int rush_load_score  -- RLS 0~100 (운영 지표 전용)
```

### EVENT_DELAY_REASON

```
uuid event_id PK FK
text reason_code PK  -- prep_late/prep_overrun/depart_late/traffic/external
text reason_source  -- user/inferred
numeric confidence
```

### EVENT_FEEDBACK

```
uuid event_id PK FK
text prep_timing_assessment  -- too_early/appropriate/too_late/unknown
text arrival_result
text rush_assessment  -- 사용자 촉박 평가
```

### DAILY_WELLNESS_SUMMARY

```
uuid summary_id PK
uuid user_id FK
date summary_date  -- UNIQUE (user_id, summary_date)
int event_count / total_outdoor_minutes
text outdoor_source  -- estimated/observed
int dwl_score / text dwl_band
text card_scenario  -- default/exposure/density/rushed/stable
text card_message_snapshot
bool is_viewed
```

### USER_PREP_ESTIMATE

```
uuid estimate_id PK
uuid user_id FK
text scope_type  -- global/event_kind/weather/origin_place/time_band
text scope_value
int estimated_minutes
int sample_count
numeric confidence
text model_version
text adjustment_reason  -- "왜 보정됐는지" 문장
timestamptz valid_from / valid_to
```

### USER_CONSENT

```
uuid consent_event_id PK
uuid user_id FK
text consent_type  -- terms/privacy/location/marketing
text policy_version
text action  -- agreed/revoked
bool is_required
uuid idempotency_key UK
timestamptz recorded_at
```

### PUSH_DEVICE

```
uuid push_device_id PK
uuid user_id FK
uuid installation_id UK
text current_token / token_status / platform
```

### ENGINE_CONFIG (원격 설정 — TR-06)

```
text config_key PK
jsonb config_value
text version
timestamptz updated_at
text updated_by
```

---

## 2. 필수 CHECK / UNIQUE 제약

```sql
-- 공급자별 식별자 유일
UNIQUE (provider, provider_uid) ON user_identity

-- 일정당 활성 계획 1건
UNIQUE INDEX uq_active_plan_per_event ON plan_revision (event_id)
  WHERE plan_status = 'active'

-- 외부 일정 중복 방지
UNIQUE INDEX uq_event_external ON event (calendar_source_id, external_event_id)
  WHERE calendar_source_id IS NOT NULL

-- timed_routine만 minutes 값을 가짐
CHECK ck_prep_minutes: (action_type = 'timed_routine' ⟺ default_minutes IS NOT NULL)

-- WIS 밴드-점수 정합성
CHECK ck_wis_band: 0~39=low, 40~69=mid, 70~100=high

-- 웰니스 행동 최대 3개
CHECK ck_wellness_rank: display_rank BETWEEN 1 AND 3

-- 웰니스 이벤트 중복 방지
UNIQUE INDEX uq_wellness_event_once ON wellness_event_schedule (plan_id, action_code, sequence_no)

-- 알림 카테고리 정합성
CHECK ck_noti_category: wellness_event ↔ wellness / 나머지 ↔ time

-- 알림 중복 발송 방지
UNIQUE dedup_key ON notification

-- 일정 제목 원문 즉시 폐기
CHECK ck_title_purged: (title_snapshot IS NULL ∧ title_purged_at IS NOT NULL)
  OR (title_snapshot IS NOT NULL ∧ title_purged_at IS NULL ∧ answered_at IS NULL)

-- 일일 요약 사용자·날짜당 1건
UNIQUE (user_id, summary_date) ON daily_wellness_summary

-- 동의 멱등성
UNIQUE idempotency_key ON user_consent

-- 기기 유일
UNIQUE installation_id ON push_device

-- 행동 이벤트 오프라인 재전송 멱등성
UNIQUE client_event_id ON event_action_log

-- 재평가 큐 인덱스
INDEX plan_due ON plan_revision (next_eval_at)
  WHERE next_eval_at IS NOT NULL AND plan_status = 'active'
```

---

## 3. 준비 항목 3단 체인

```
USER_PREP_RULE          "나는 영양제를 챙긴다"          원형. 사용자 소유
   rule_category × action_type · rule_timing · default_minutes
      │ (apply_* 조건 평가)
      ▼
EVENT_PREP_ITEM         "이 일정에는 영양제가 필요"      일정 파생
   item_name · action_type · estimated_minutes
      │ (계획 리비전 생성 시마다 복사)
      ▼
PLAN_PREP_ITEM          "이 계획의 체크리스트 · 완료"    계획 스냅샷
   item_name_snapshot · applied_minutes · completion_status
```

**왜 3단인가:** 사용자가 원형을 수정/삭제해도 **과거 계획의 기록이 바뀌면 안 됩니다.** `PLAN_PREP_ITEM`이 스냅샷을 가지고 있어 원형과 독립됩니다.

---

## 4. 웰니스 데이터 흐름

```
PLAN_CONTEXT (환경 수집)
  → PLAN_WELLNESS_SCORE (WIS 계산 · weight_version 기록)
    → WIS 0~39: 조용히 (일정 상세에만)
    → WIS 40~69: PLAN_WELLNESS_ACTION 최대 3개 (외출 전 제안)
    → WIS 70~100: 외출 전 제안 + WELLNESS_EVENT_SCHEDULE (이벤트 푸시 후보)
      → 응답: completed/snoozed/stop_today/ignored
  → EVENT_EXECUTION.rush_load_score (RLS)
  → DAILY_WELLNESS_SUMMARY.dwl_score (DWL)
    → card_scenario 선택 → 일일 마무리 카드
```

---

## 5. 안전·개인정보 설계

| 원칙 | 스키마 반영 |
|---|---|
| WIS는 건강 점수가 아님 | `PLAN_WELLNESS_SCORE`에 피부·건강 필드 없음 |
| 재도포 주기를 서비스가 판단하지 않음 | `remind_interval_minutes`는 `USER_WELLNESS_PREF`(사용자 입력)에만 존재 |
| 영양제·복용약은 효능 판단 안 함 | `USER_PREP_RULE`에 용량·성분·효능 필드 없음 |
| 잠금화면 마스킹 | `is_sensitive` → `NOTIFICATION.body_masked` |
| 하루 전체 경로 미저장 | 좌표는 출발지·목적지만. 경로는 계획 단위 `route_payload`만 |
| **일정 제목 미보관** | `EVENT.title` 컬럼 없음. 분류 시 `title_snapshot` 일시 저장 후 즉시 폐기 |
| 탈퇴 시 삭제 | `user_id` CASCADE. `USER_CONSENT`만 법정 기간 보존 |

---

## 6. 성공 지표 → 스키마 매핑

| 지표 | 계산 근거 |
|---|---|
| 웰니스 행동 완료율 | `PLAN_WELLNESS_ACTION` completed / proposed |
| 웰니스 이벤트 반응률 | `WELLNESS_EVENT_SCHEDULE` response ∈ (completed, snoozed) / sent |
| 웰니스 알림 적합률 | `user_rating = 'useful'` / rating 수집분 |
| 웰니스 커버리지 | WIS 생성 일정 / `estimated_outdoor_minutes > 0` 일정 |
| 맞춤 준비 항목 체크 완료율 | `PLAN_PREP_ITEM` completed / 노출분 |
| 촉박 도착률 | `EVENT_EXECUTION.arrival_result = 'rushed'` |
| 극한 알림 비율 | `NOTIFICATION.notification_type = 'critical'` |
| 일일 카드 확인률 | `DAILY_WELLNESS_SUMMARY.is_viewed` |
| 맞춤 항목 설정률 | `USER_PREP_RULE` 생성 시각 vs 온보딩 완료 |
| 되돌림률 | personalization/revert 호출 빈도 |

---

*Ensom ERD v3.1 · PRD v0.4.3 기준 · 2026-08-17*
