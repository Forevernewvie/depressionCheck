import 'package:flutter_test/flutter_test.dart';
import 'package:vibemental_app/core/settings/app_settings.dart';
import 'package:vibemental_app/core/settings/settings_controller.dart';
import 'fakes/fake_app_preferences_repository.dart';

void main() {
  test('restores and persists theme/language preferences', () {
    final repository = FakeAppPreferencesRepository(
      themePreference: ThemePreference.dark,
      languagePreference: LanguagePreference.ko,
    );
    final controller = SettingsController(repository);

    expect(controller.state.themePreference, ThemePreference.dark);
    expect(controller.state.languagePreference, LanguagePreference.ko);

    controller.updateTheme(ThemePreference.light);
    controller.updateLanguage(LanguagePreference.en);

    expect(repository.snapshot.themePreference, ThemePreference.light);
    expect(repository.snapshot.languagePreference, LanguagePreference.en);
  });
}
