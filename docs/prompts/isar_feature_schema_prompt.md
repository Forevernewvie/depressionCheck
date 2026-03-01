# Isar Schema Prompt Template (Flutter, Local-First)

Use this prompt when adding new offline-first features that need Isar persistence without breaking existing Flutter flows.

```text
You are a Principal Flutter Engineer.

Project context:
- Existing Flutter app with Riverpod and layered architecture
- Local persistence uses Isar
- Existing features must remain backward compatible

Task:
Implement Isar schema and repository wiring for the following feature(s):
- {FEATURE_NAME_1}
- {FEATURE_NAME_2}

Requirements:
1) Data model
- Create Isar `@collection` entities with typed fields only.
- Add indexes for:
  - lookup keys
  - sort fields
  - unique constraints where needed
- Include Dart doc comments on each class/function:
  /// Purpose: ...

2) Layered architecture
- `domain`: pure entities/value objects/validators
- `data`: repository interfaces
- `infrastructure`: Isar repository implementation
- `application`: Riverpod controller/state providers
- `presentation`: UI should depend only on application layer providers

3) Integration
- Register new schemas in `main.dart` Isar.open(...)
- Keep old schemas unchanged
- Add route/home entry only if explicitly requested

4) Quality/Safety
- No hardcoded business thresholds (move to typed config class)
- No magic numbers
- Defensive validation for all user input
- Structured logging through abstraction
- Never use diagnosis wording for screening features

5) Generation and verification
- Run build_runner for `*.g.dart`
- Run:
  - dart format .
  - flutter analyze
  - flutter test
- Do not ship if any command fails

Output format:
1. Architecture delta
2. Patch-ready file changes
3. Test list added
4. Risk notes (error/security/performance)
```

