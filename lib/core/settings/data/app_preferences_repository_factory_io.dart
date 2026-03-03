import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:vibemental_app/core/settings/app_settings.dart';
import 'package:vibemental_app/core/settings/data/app_preference.dart';
import 'package:vibemental_app/core/settings/data/app_preferences_repository.dart';

/// Purpose: Expose Isar instance through DI so native platforms can override
/// storage in app bootstrap and tests.
final isarProvider = Provider<Isar>(
  (ref) => throw UnimplementedError('Isar override is required.'),
);

/// Purpose: Build AppPreferencesRepository using native Isar storage.
AppPreferencesRepository createAppPreferencesRepository(Ref ref) {
  final isar = ref.watch(isarProvider);
  return IsarAppPreferencesRepository(isar);
}

/// Purpose: Persist app settings into Isar on native platforms.
class IsarAppPreferencesRepository implements AppPreferencesRepository {
  IsarAppPreferencesRepository(this._isar);

  final Isar _isar;

  @override
  /// Purpose: Read preferences from Isar and map raw strings to enums safely.
  StoredPreferences read() {
    final pref = _ensurePreference();
    return StoredPreferences(
      themePreference: _parseTheme(pref.themePreference),
      languagePreference: _parseLanguage(pref.languagePreference),
      onboardingCompleted: pref.onboardingCompleted,
    );
  }

  @override
  /// Purpose: Persist only theme field while preserving other settings.
  void saveThemePreference(ThemePreference preference) {
    final pref = _ensurePreference();
    pref.themePreference = preference.name;
    _isar.writeTxnSync(() {
      _isar.appPreferences.putSync(pref);
    });
  }

  @override
  /// Purpose: Persist only language field while preserving other settings.
  void saveLanguagePreference(LanguagePreference preference) {
    final pref = _ensurePreference();
    pref.languagePreference = preference.name;
    _isar.writeTxnSync(() {
      _isar.appPreferences.putSync(pref);
    });
  }

  @override
  /// Purpose: Persist only onboarding flag while preserving other settings.
  void saveOnboardingCompleted(bool completed) {
    final pref = _ensurePreference();
    pref.onboardingCompleted = completed;
    _isar.writeTxnSync(() {
      _isar.appPreferences.putSync(pref);
    });
  }

  /// Purpose: Ensure singleton preference record exists before access/update.
  AppPreference _ensurePreference() {
    final existing = _isar.appPreferences.getSync(AppPreference.singletonId);
    if (existing != null) {
      return existing;
    }

    final created = AppPreference();
    _isar.writeTxnSync(() {
      _isar.appPreferences.putSync(created);
    });
    return created;
  }

  /// Purpose: Parse theme enum from stored string with safe default fallback.
  ThemePreference _parseTheme(String value) {
    return ThemePreference.values.firstWhere(
      (item) => item.name == value,
      orElse: () => ThemePreference.system,
    );
  }

  /// Purpose: Parse language enum from stored string with safe default fallback.
  LanguagePreference _parseLanguage(String value) {
    return LanguagePreference.values.firstWhere(
      (item) => item.name == value,
      orElse: () => LanguagePreference.system,
    );
  }
}
