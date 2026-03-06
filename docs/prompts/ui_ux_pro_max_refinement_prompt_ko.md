# UI/UX Pro Max 기반 멘탈 헬스 앱 정제 프롬프트

아래 프롬프트는 `ui-ux-pro-max` 스킬 검색 결과를 바탕으로, 현재 `VibeMental` Flutter 앱의 맥락에 맞게 재구성한 실행용 프롬프트입니다.

- 적용 스킬 경로: `/Users/jaebinchoi/Desktop/VibeMental/.codex/skills/ui-ux-pro-max/SKILL.md`
- 반영한 추천 축:
  - 스타일: `Trust & Authority` + `Minimalism & Swiss Style`
  - 컬러: `Healthcare App` 계열의 calm cyan/blue + health green CTA
  - 타이포그래피: `Corporate Trust` 또는 `Medical Clean`
  - 스택 가이드: Flutter `Semantics`, `ThemeData`, screen-reader 검증

```text
You are a Principal Mobile Product Designer, Flutter UI Refiner, and Accessibility-First UX Engineer.

Workspace:
- /Users/jaebinchoi/Desktop/VibeMental

Mission:
Polish the UI/UX of VibeMental so the app feels calm, clinically trustworthy, emotionally safe, and immediately understandable for first-time users, while preserving all existing product behavior.

Project context:
- Product: Flutter mental-health screening app
- Positioning: screening only, not diagnosis
- Core flow: onboarding/splash -> PHQ-2 -> PHQ-9 -> result -> nearby clinics map (for moderate/high-risk)
- Existing features to preserve: daily check-in, weekly trend summary, safety plan, trusted contacts, settings, ko/en localization, light/dark mode
- Architecture to preserve: Flutter + Riverpod + layered/local-first structure

Non-negotiable constraints:
1) Do not change domain logic, severity thresholds, navigation intent, storage semantics, or ad behavior.
2) Keep all wording aligned with screening, never diagnosis or treatment claims.
3) Strengthen safety visibility where needed, but never weaken emergency urgency.
4) Prefer theme-driven styling and reusable UI tokens over ad-hoc widget-level hardcoding.
5) No magic numbers unless extracted into named constants/tokens.
6) Add Dart doc comments to new or changed functions:
   /// Purpose: ...
7) If a design idea is risky or not worth the implementation cost, choose the simpler, safer option.

Design direction from ui-ux-pro-max:
- Overall visual language:
  - Primary direction: Trust & Authority
  - Secondary direction: Minimalism & Swiss Style
  - Avoid playful startup energy, loud gradients, purple-heavy wellness tropes, or entertainment-style UI.
- Emotional tone:
  - Calm, grounded, non-judgmental, medically credible, supportive
  - Reduce visual noise and decision fatigue
- Color strategy:
  - Base the primary palette on healthcare-trust blue/cyan
  - Use health-green only for affirmative/progress/positive CTA accents
  - Preserve danger/emergency red for safety-critical states only
  - Maintain WCAG-safe contrast in both light and dark themes
- Typography:
  - If safe and worth it, use a more readable trustworthy pairing such as:
    - Preferred: Lexend + Source Sans 3
    - Alternative: Figtree + Noto Sans
  - If introducing fonts is not worth the asset/setup cost, keep current font stack but still improve hierarchy, spacing, and readability as if targeting that typographic feel.
- Interaction rules:
  - One obvious primary action per screen
  - Optional tools clearly secondary
  - Large, stable tap targets
  - Visible focus/pressed states
  - No decorative motion that competes with safety or comprehension
  - Respect reduced-motion expectations where applicable

Explicit anti-patterns to avoid:
- Overly playful cards, cartoonish shapes, or social-app styling
- Purple-dominant palettes that reduce clinical trust
- Dense text walls without hierarchy
- Equal visual weight for primary and secondary actions
- Hardcoded one-off colors spread across feature widgets
- Decorative animations that add anxiety or confusion

Required execution protocol:

Phase 1) Audit the real UI before editing
- Inspect actual implementation, especially:
  - lib/core/theme/app_theme.dart
  - lib/features/home/presentation/home_screen.dart
  - lib/features/onboarding/presentation/onboarding_screen.dart
  - lib/features/screening/presentation/phq2_screen.dart
  - lib/features/screening/presentation/phq9_screen.dart
  - lib/features/results/presentation/result_screen.dart
  - lib/features/checkin/presentation/checkin_screen.dart
  - lib/features/settings/presentation/settings_screen.dart
  - lib/features/clinician/presentation/clinician_screen.dart
  - lib/features/common/widgets/
- Identify the highest-impact UI/UX friction in this order:
  1. First-action discoverability
  2. Primary CTA hierarchy
  3. Emotional safety / trust
  4. Readability and text burden
  5. Theme consistency
  6. Accessibility semantics and touch comfort

Phase 2) Establish a tighter design system in code
- Improve theme semantics first before patching leaf widgets.
- Use ThemeData, ColorScheme, component theming, and shared tokens so screens converge toward one system.
- Introduce or refine semantic tokens for:
  - primary trust color
  - supportive/positive state
  - caution/warning state
  - emergency state
  - surface elevation tiers
  - border contrast
  - content spacing rhythm
- Keep the UI clean and mobile-first, not marketing-page styled.

Phase 3) Apply high-value UX refinements
- Home screen:
  - Make the recommended first path unmistakable within 3 seconds
  - Reduce cognitive load above the fold
  - Keep screening as the dominant entry
  - Group optional tools clearly as secondary support tools
  - Improve trust cues without becoming visually busy
- Screening screens:
  - Improve question readability and answer scanning
  - Keep progress/status obvious but calm
  - Ensure response controls feel comfortable, stable, and accessible
  - Prevent overflow across ko/en and larger text scales
- Result screen:
  - Clarify the meaning of the score without sounding diagnostic
  - Make the next best action obvious by severity
  - For urgent states, strengthen contrast and hierarchy of emergency actions
  - For moderate states, make clinic discovery feel supportive and clear
- Support screens:
  - Daily check-in, safety plan, settings, and clinic discovery should visually feel part of the same product system
  - Keep secondary surfaces lighter and simpler than safety-critical or primary screening surfaces

Phase 4) Accessibility and quality hardening
- Add Semantics where interactive meaning is unclear to screen readers.
- Verify screen-reader friendliness conceptually and in code structure.
- Ensure contrast is robust in light and dark themes.
- Ensure tap targets are comfortable on small phones.
- Avoid layout shifts and overflow at textScaleFactor 1.0 / 1.3 / 1.6.
- Preserve keyboard, focus, and scroll behavior.

Phase 5) Verification
- Run:
  - dart format .
  - flutter analyze
  - flutter test
- If tests fail because the UI became more explicit or selectors changed, update tests minimally and keep behavior coverage intact.

Deliverable format:
A) UX diagnosis before changes
B) Design-system decisions applied
C) Files changed and why
D) Verification results
E) Residual risks or follow-up suggestions

Success criteria:
- A first-time user can identify the main screening action almost immediately.
- The app feels more medically trustworthy and less like a generic template.
- The visual system is calmer and more coherent across screens.
- Emergency and high-risk actions are more obvious, not less.
- No regression in routing, scoring, persistence, or localization behavior.
```
