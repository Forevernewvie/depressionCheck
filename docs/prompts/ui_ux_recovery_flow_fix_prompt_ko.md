# UI/UX Recovery Flow Fix Prompt

아래 프롬프트는 최근 감사에서 확인된 실제 UI/UX 결함을 수정하기 위한 실행 프롬프트입니다.

- 대상 워크스페이스: `/Users/jaebinchoi/Desktop/VibeMental`
- 필수 스킬: `/Users/jaebinchoi/Desktop/VibeMental/.codex/skills/ui-ux-pro-max/SKILL.md`
- 목적:
  - 코어 선별 플로우의 back-stack 복구
  - 지도 권한 영구 거부 후 설정 복귀 흐름 복구
  - Safety Plan 연락처 다이얼로그 입력 유실 차단
  - 제한 콘텐츠 상세 화면에 실제 행동 가능한 CTA 부여

```text
You are a Principal Mobile UX Repair Engineer working on a Flutter mental-health screening app.

Workspace:
- /Users/jaebinchoi/Desktop/VibeMental

Mandatory skill:
- Use the local skill at:
  /Users/jaebinchoi/Desktop/VibeMental/.codex/skills/ui-ux-pro-max/SKILL.md

Mission:
Fix the current UI/UX breakage findings without broad redesign.
Do not invent new features. Repair the broken or misleading flows and add regression coverage.

Confirmed issues to fix:
1. Screening flow is one-way because navigation replaces history instead of preserving it.
2. Map permission-denied-forever recovery gets stuck after users return from system settings.
3. Safety Plan contact dialog still allows accidental dismissal that drops typed input.
4. Clinician-only restriction screen recommends urgent paths but provides no direct CTA to them.

Repair rules:
1. Preserve truthful state messaging.
2. Prefer explicit, recoverable user flows over silent dismissal.
3. Keep Flutter theming, localization, and design-token conventions intact.
4. Add or update tests for every repaired issue when feasible.
5. Do not regress overflow, localization, or accessibility behavior.

Implementation expectations:
- Screening flow:
  - Home -> PHQ-2 should preserve a back path.
  - PHQ-2 -> PHQ-9 / Result should preserve a back path.
  - PHQ-9 -> Result should preserve a back path.
- Map flow:
  - If the user opens system settings from a denied-forever state and returns,
    the screen must re-check nearby clinics automatically or otherwise recover to a truthful next step.
- Safety Plan dialog:
  - Outside taps and system back should not silently discard draft contact input.
  - Keep explicit Cancel as the deliberate exit.
- Clinician details:
  - Add direct CTA(s) to the recommended urgent support path(s), such as nearby clinics
    and/or safety support, matching the copy already shown.

Verification:
- Run focused widget tests for:
  - routing/back-stack behavior
  - map settings-return recovery
  - safety dialog draft preservation
  - clinician CTA presence
- Run `flutter analyze`
- Run at least the relevant focused test files, and preferably the full test suite if time allows.

Output:
- Summarize the concrete fixes
- List changed files
- State verification results
- Call out any residual manual-device risk only if it remains
```
