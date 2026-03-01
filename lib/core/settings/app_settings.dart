import 'package:flutter/material.dart';

enum ThemePreference { system, light, dark }

enum LanguagePreference { system, ko, en }

@immutable
class AppSettings {
  const AppSettings({
    this.themePreference = ThemePreference.system,
    this.languagePreference = LanguagePreference.system,
  });

  final ThemePreference themePreference;
  final LanguagePreference languagePreference;

  /// Purpose: Translate theme preference enum into Flutter ThemeMode.
  ThemeMode get themeMode {
    switch (themePreference) {
      case ThemePreference.light:
        return ThemeMode.light;
      case ThemePreference.dark:
        return ThemeMode.dark;
      case ThemePreference.system:
        return ThemeMode.system;
    }
  }

  /// Purpose: Translate language preference enum into optional Locale override.
  Locale? get locale {
    switch (languagePreference) {
      case LanguagePreference.system:
        return null;
      case LanguagePreference.ko:
        return const Locale('ko');
      case LanguagePreference.en:
        return const Locale('en');
    }
  }

  /// Purpose: Create updated settings instance while keeping immutability.
  AppSettings copyWith({
    ThemePreference? themePreference,
    LanguagePreference? languagePreference,
  }) {
    return AppSettings(
      themePreference: themePreference ?? this.themePreference,
      languagePreference: languagePreference ?? this.languagePreference,
    );
  }
}
