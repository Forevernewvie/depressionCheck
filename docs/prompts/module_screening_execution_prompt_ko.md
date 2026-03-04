You are a Principal Flutter Engineer and Safe Refactor Executor.

Workspace:
- /Users/jaebinchoi/Desktop/depressionCheck_repo

Mission:
Implement missing module screening flows (BDI-II, HADS-D, CES-D) with minimal-risk patches.

Non-negotiable constraints:
1) Existing PHQ-2 -> PHQ-9 -> result/map behavior must remain unchanged.
2) No changes to persistence schema unless strictly required.
3) No changes to core business thresholds for existing PHQ flow.
4) Keep screening wording (NOT diagnosis).
5) Keep ko/en and light/dark parity.
6) Keep emergency/high-risk visibility and action path clear.
7) Follow layered boundaries and testability.
8) Add Dart doc comments on new/changed functions: `/// Purpose: ...`

Execution protocol:
PHASE 0) Safety lock
- List protected files/modules (existing PHQ/map/check-in/safety domain/app/data paths).
- Only proceed with module-related UI/domain additions.

PHASE 1) Implementation
- Add module entry actions in modules screen.
- Add route(s) for BDI-II / HADS-D / CES-D module questionnaires.
- Implement questionnaire screen(s) with answer validation.
- Implement score-to-severity mapping using domain-safe helpers.
- Reuse existing result screen path without changing PHQ behavior.
- Add localized copy keys in ko/en for new module UI text.
- Ensure BDI licensing caveat remains visible in module flow.

PHASE 2) Tests
- Add unit tests for new module scoring boundaries.
- Add widget tests for module open -> answer -> result navigation path.
- Keep existing tests passing.

PHASE 3) Verification
Run and require all pass:
- dart format .
- flutter analyze
- flutter test
- flutter build web --release --no-wasm-dry-run --dart-define=FIREBASE_PROJECT_ID=mentalvibe

PHASE 4) Deploy
- firebase deploy --only hosting --project mentalvibe
- verify:
  - curl -I -L https://mentalvibe.web.app
  - module page reachable from UI and route

Output format (strict):
A) Architecture delta
B) Files changed + purpose
C) Test evidence
D) Deploy evidence
E) Residual risks
F) Final assertion:
   “Existing PHQ flow unchanged; module flows added safely.”
