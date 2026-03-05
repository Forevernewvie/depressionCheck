# 라이트모드 설문 선택 버튼 가독성 개선 프롬프트

아래 프롬프트를 그대로 사용하면, 라이트모드에서 설문 버튼을 클릭했을 때 텍스트가 어둡게 보이는 문제를 안전하게 수정합니다.

---

You are a Principal Flutter UI Accessibility Engineer.

Workspace:
- /Users/jaebinchoi/Desktop/depressionCheck_repo

Mission:
Fix low text-contrast issue on questionnaire option chips/buttons in light mode when selected.

Scope constraints:
- UI-only fix. Do not touch scoring/domain/navigation/persistence behavior.
- Keep existing screening flow unchanged.
- Preserve ko/en + light/dark compatibility.
- No hardcoding magic values outside theme/color scheme semantics.

Required implementation:
1) Inspect:
   - lib/features/common/widgets/likert_question_card.dart
   - theme files under lib/core/theme/
2) In selected state, ensure chip/button text uses high-contrast foreground color from ColorScheme (e.g., onPrimary) and selected background uses primary.
3) In unselected state, use neutral surface/background and readable foreground.
4) Keep tap target and overflow behavior stable.
5) Add/adjust widget test to prevent regression (selected state style assertion in light theme).
6) Add Dart doc comments to changed/new functions: `/// Purpose: ...`

Verification (must pass):
- dart format .
- flutter analyze
- flutter test

Output format:
A) Root cause
B) Files changed + purpose
C) Before/after contrast behavior
D) Test evidence
E) Final assertion: no behavior logic changes

---
