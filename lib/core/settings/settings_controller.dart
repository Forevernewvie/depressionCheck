import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibemental_app/core/settings/app_settings.dart';
import 'package:vibemental_app/core/settings/data/app_preferences_repository.dart';

/// Purpose: Expose settings state controller through Riverpod.
final settingsControllerProvider =
    StateNotifierProvider<SettingsController, AppSettings>((ref) {
      final repository = ref.watch(appPreferencesRepositoryProvider);
      return SettingsController(repository);
    });

class SettingsController extends StateNotifier<AppSettings> {
  SettingsController(this._repository) : super(const AppSettings()) {
    _restore();
  }

  final AppPreferencesRepository _repository;

  /// Purpose: Load persisted settings snapshot when controller starts.
  void _restore() {
    final stored = _repository.read();

    state = AppSettings(
      themePreference: stored.themePreference,
      languagePreference: stored.languagePreference,
    );
  }

  /// Purpose: Persist theme preference and update in-memory state.
  void updateTheme(ThemePreference preference) {
    state = state.copyWith(themePreference: preference);
    _repository.saveThemePreference(preference);
  }

  /// Purpose: Persist language preference and update in-memory state.
  void updateLanguage(LanguagePreference preference) {
    state = state.copyWith(languagePreference: preference);
    _repository.saveLanguagePreference(preference);
  }
}
