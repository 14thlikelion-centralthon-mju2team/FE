# PR 코멘트 및 본문 작성 규칙

## 필수 양식

PR 본문과 후속 커밋 코멘트는 아래 이모티콘 헤더 양식을 반드시 따른다.

### 섹션 구조

```markdown
## 🐣 변경 요약
한 줄 요약 + 이모티콘. 뭘 왜 바꿨는지 한 문장으로.

## 🌈 PR 요약
변경 파일과 내용을 표 또는 리스트로 상세 기술.
코드 스니펫, 상태 전이 다이어그램 등 필요 시 포함.

## 🐤 반영 브랜치 (PR 본문에만)
`{base}` 기준으로 분기한 `{branch}` → `{target}`

## 🐥 테스트 결과
- flutter analyze 결과
- flutter test 결과
- git diff --check 결과
- 기타 검증 항목

## ✅ 체크리스트 (선택)
* [x] 완료된 항목
* [ ] 미완료 항목

## 👾 참고 사항
제약, 제한, 알려진 이슈, 후속 작업 안내.

## 👀 실기기 확인 필요 / 추가 설명 (선택)
실기기 E2E나 환경 의존적 검증이 필요한 항목 나열.
```

### 규칙

1. **이모티콘 헤더는 생략하지 않는다.** 최소 `🐣`, `🌈`, `🐥`는 반드시 포함.
2. **변경 파일은 표로 정리한다.** 파일명 | 변경 내용.
3. **코드 변경이 있으면 핵심 diff를 코드 블록으로 보여준다.**
4. **후속 커밋 코멘트도 동일 양식을 따른다.** (🐤 반영 브랜치 생략 가능)
5. **검증 결과는 구체적 수치로 적는다.** "통과"만 쓰지 말고 "4/4 passed", "error 0" 등.
6. **관련 이슈/PR은 `Closes #N`, `Refs #N` 형식으로 명시한다.**

### 커밋 메시지 (별도)

커밋 메시지는 Conventional Commits를 따른다:
```
type: 한글 요약 (70자 이내)

본문 (선택): 변경 이유, 영향 범위
```

type: `feat`, `fix`, `chore`, `docs`, `refactor`, `test`, `style`

### 예시 — 후속 커밋 코멘트

```markdown
## 🐣 변경 요약
PR #48 리뷰 MUST 3건 수정 — 온보딩 복귀, 스플래시 깜빡임, GoogleSignIn 세션 🔧

## 🌈 PR 요약

### MUST 1: 온보딩 중간 단계 복귀
| 파일 | 변경 |
|---|---|
| `secure_storage_service.dart` | `onboarding_step` 키 추가 |
| `app_router.dart` | step별 redirect 분기 |

### MUST 2: Splash retry 깜빡임
`_isRetrying` 상태 추가로 에러→스피너 전환 안정화

## 🐥 테스트 결과
- `flutter analyze`: exit 0 · error 0
- `flutter test`: 4/4 passed

## 👾 참고 사항
SHOULD/NIT은 M5에서 처리 예정
```
