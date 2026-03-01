# CI/CD 설정 프롬프트 (CI 전용, CD 제외)

아래 프롬프트를 그대로 사용하면, Flutter 프로젝트에서 Git Flow 기반 CI를 단계적으로 구축할 수 있습니다.

```text
You are a Principal DevOps Engineer for Flutter projects.

Goal:
Set up robust GitHub Actions **CI-only** pipeline for this repository.
Do NOT configure deployment (CD).

Branch strategy (Git Flow):
- main: production
- develop: integration
- feature/*, bugfix/*, chore/*: topic branches

Mandatory requirements:
1) CI must run on pull requests to `develop` and `main`.
2) CI must explicitly gate `develop -> main` PR with release-grade checks.
3) No deployment job, no artifact publish to stores, no infra mutation.
4) Keep workflow deterministic and cache-aware.
5) Fail fast on formatting/analyze/test errors.

Step-by-step execution plan:
Step 1. Repository inspection
- Read `pubspec.yaml`, `analysis_options.yaml`, `lib/`, `test/`.
- Detect Flutter/Dart versions and test commands from project reality.
- If missing info, mark `TODO:` in PR description rather than guessing.

Step 2. Create CI workflow files
- Create `.github/workflows/flutter_ci.yml` with:
  - trigger:
    - pull_request: [develop, main]
    - push: [develop]
    - workflow_dispatch
  - permissions: contents: read
  - concurrency cancellation to avoid duplicate runs
  - job `quality-check`:
    - checkout
    - setup Flutter stable
    - `flutter pub get`
    - `dart format --output=none --set-exit-if-changed lib test`
    - `flutter analyze`
    - `flutter test`
  - job `release-pr-gate`:
    - run only when pull_request base is `main` and head is `develop`
    - depends on `quality-check`
    - rerun critical checks (`flutter analyze`, `flutter test`)
  - Add comments in workflow header: `CI only / no CD`.

Step 3. Validation
- Run locally:
  - `dart format .`
  - `flutter analyze`
  - `flutter test`
- Ensure workflow YAML syntax is valid.

Step 4. Git Flow delivery
- Branch from `develop` as `chore/ci-pipeline`.
- Commit with Conventional Commit message.
- Push branch.
- Open PR to `develop` with checklist and risk notes.
- Merge PR to `develop`.

Step 5. Develop->Main release gating
- Open PR `develop -> main`.
- Wait for CI checks to pass.
- Merge only after all required checks are green.

Security constraints:
- Do not print secrets.
- Do not add any CD/deploy tokens.
- Keep permissions 최소화(principle of least privilege).

Output format:
1) Files created/changed
2) CI jobs summary
3) Local validation result
4) PR links
5) Merge status (`develop`, `main`)
```
