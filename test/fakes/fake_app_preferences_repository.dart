import 'package:vibemental_app/core/settings/app_settings.dart';
import 'package:vibemental_app/core/settings/data/app_preferences_repository.dart';

class FakeAppPreferencesRepository implements AppPreferencesRepository {
  FakeAppPreferencesRepository({
    ThemePreference themePreference = ThemePreference.system,
    LanguagePreference languagePreference = LanguagePreference.system,
    bool onboardingCompleted = false,
  }) : _stored = StoredPreferences(
         themePreference: themePreference,
         languagePreference: languagePreference,
         onboardingCompleted: onboardingCompleted,
       );

  StoredPreferences _stored;

  @override
  StoredPreferences read() => _stored;

  @override
  void saveLanguagePreference(LanguagePreference preference) {
    _stored = StoredPreferences(
      themePreference: _stored.themePreference,
      languagePreference: preference,
      onboardingCompleted: _stored.onboardingCompleted,
    );
  }

  @override
  void saveOnboardingCompleted(bool completed) {
    _stored = StoredPreferences(
      themePreference: _stored.themePreference,
      languagePreference: _stored.languagePreference,
      onboardingCompleted: completed,
    );
  }

  @override
  void saveThemePreference(ThemePreference preference) {
    _stored = StoredPreferences(
      themePreference: preference,
      languagePreference: _stored.languagePreference,
      onboardingCompleted: _stored.onboardingCompleted,
    );
  }

  StoredPreferences get snapshot => _stored;
}
