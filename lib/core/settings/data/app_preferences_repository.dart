import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibemental_app/core/settings/app_settings.dart';
import 'package:vibemental_app/core/settings/data/app_preferences_repository_factory.dart';

/// Purpose: Carry stored preference values as a domain-friendly immutable object.
class StoredPreferences {
  const StoredPreferences({
    required this.themePreference,
    required this.languagePreference,
    required this.onboardingCompleted,
  });

  final ThemePreference themePreference;
  final LanguagePreference languagePreference;
  final bool onboardingCompleted;
}

abstract class AppPreferencesRepository {
  /// Purpose: Read current persisted settings snapshot.
  StoredPreferences read();

  /// Purpose: Persist theme preference update.
  void saveThemePreference(ThemePreference preference);

  /// Purpose: Persist language preference update.
  void saveLanguagePreference(LanguagePreference preference);

  /// Purpose: Persist onboarding completion state.
  void saveOnboardingCompleted(bool completed);
}

/// Purpose: Expose repository dependency through DI.
final appPreferencesRepositoryProvider = Provider<AppPreferencesRepository>((
  ref,
) {
  return createAppPreferencesRepository(ref);
});
