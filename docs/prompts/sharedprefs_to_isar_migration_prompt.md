# Prompt: Convert SharedPreferences to Isar (Flutter MVP)

You are a senior Flutter engineer. Convert an existing app from SharedPreferences-based settings storage to Isar.

## Scope
- Replace all SharedPreferences usage with Isar.
- Persist these settings in Isar as a single-row preference record:
  - `themePreference` (`system|light|dark`)
  - `languagePreference` (`system|ko|en`)
  - `onboardingCompleted` (`bool`)
- Keep Riverpod provider architecture.
- Preserve current app behavior and tests.

## Requirements
1. Add Isar packages and codegen setup:
   - `isar`, `isar_flutter_libs`
   - dev: `isar_generator`, `build_runner`
2. Create Isar collection model:
   - `AppPreference` with fixed singleton id (`0`)
3. Create repository abstraction + Isar implementation:
   - `read()`, `saveThemePreference()`, `saveLanguagePreference()`, `saveOnboardingCompleted()`
4. Replace controllers to use repository:
   - `SettingsController`
   - `OnboardingController`
5. App startup:
   - Open Isar in `main.dart`
   - Provide `isarProvider` override in `ProviderScope`
6. Remove SharedPreferences dependency and imports.
7. Update tests to avoid SharedPreferences mocks:
   - Use fake in-memory repository in tests
   - Keep behavior assertions the same
8. Run and pass:
   - `flutter pub get`
   - `flutter pub run build_runner build --delete-conflicting-outputs`
   - `flutter analyze`
   - `flutter test`

## Output format
- Show changed files list.
- Show migration risks and rollback plan.
- Include exact run commands.
