# UI/UX Pro Max 후속 정제 프롬프트: Support Screens

아래 프롬프트는 `ui-ux-pro-max` 스킬을 기반으로, 1차 정제 이후에도 상대적으로 구조가 덜 정리된 보조 화면들을 후속 개선하기 위한 실행 프롬프트입니다.

- 적용 스킬 경로: `/Users/jaebinchoi/Desktop/VibeMental/.codex/skills/ui-ux-pro-max/SKILL.md`
- 대상 화면:
  - `SafetyPlanScreen`
  - `MapScreen`
  - `ModulesScreen`
- 의도:
  - 핵심 선별 흐름을 해치지 않으면서도 보조 화면의 신뢰감, 읽기 순서, 안전성 계층을 본 화면들과 맞춘다.

```text
You are a Principal Mobile UX Finisher working on a Flutter mental-health screening app.

Workspace:
- /Users/jaebinchoi/Desktop/VibeMental

Mission:
Refine the secondary/support screens so they feel as intentional, clinically trustworthy, and system-consistent as the already polished core flow screens.

Target screens only:
- Safety plan
- Nearby clinics map/list
- Instrument modules

Constraints:
1) Do not change business logic, navigation intent, persistence semantics, or data loading rules.
2) UI/UX only: hierarchy, visual grouping, semantics, readability, and safer interaction affordances.
3) Keep safety-critical actions more prominent than non-critical actions.
4) Preserve ko/en and light/dark compatibility.
5) Use existing ThemeData / semantic color system; avoid new one-off colors unless justified.
6) Add `/// Purpose: ...` comments to changed/new functions.

ui-ux-pro-max follow-up direction:
- Use Trust & Authority styling, not playful consumer UI.
- Strengthen heading hierarchy and screen-reader clarity.
- Reduce “flat list of controls” feeling by grouping related content into purposeful sections.
- For dynamic lists, preserve stable identity with keys where helpful.
- For filters and action clusters, prefer predictable grouping over visual novelty.

Execution protocol:

Phase 1) Diagnose support-screen friction
- Safety plan:
  - Is the emergency block unmistakably primary?
  - Are reflective sections grouped in a calmer, more guided way?
  - Are trusted-contact actions easy to scan?
- Map:
  - Is location/search status understandable at a glance?
  - Are filters/sorts grouped clearly?
  - Does the clinic list feel medically trustworthy rather than generic?
- Modules:
  - Is the difference between self-screen modules and restricted/clinician content obvious?
  - Is the overall information hierarchy too flat?

Phase 2) Apply minimal but meaningful refinement
- Safety plan:
  - Add stronger screen introduction and section grouping.
  - Keep emergency actions visually strongest.
  - Make contacts feel operational, not just appended text cards.
- Map:
  - Improve load/status card and data-trust messaging.
  - Clarify filters and result grouping.
  - Improve clinic card structure and action scanability.
- Modules:
  - Add a stronger intro framing card.
  - Make available modules feel primary and clinician/restricted content clearly secondary.

Phase 3) Verification
- Run:
  - dart format .
  - flutter analyze
  - flutter test

Deliverable:
A) Remaining support-screen UX issues
B) Files changed and why
C) Verification results
D) Residual tradeoffs
```
