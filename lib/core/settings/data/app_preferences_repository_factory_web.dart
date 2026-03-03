// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibemental_app/core/config/web_storage_keys.dart';
import 'package:vibemental_app/core/settings/app_settings.dart';
import 'package:vibemental_app/core/settings/data/app_preferences_repository.dart';

/// Purpose: Build AppPreferencesRepository using browser local storage.
AppPreferencesRepository createAppPreferencesRepository(Ref ref) {
  return WebAppPreferencesRepository();
}

/// Purpose: Persist app settings in browser local storage for web builds.
class WebAppPreferencesRepository implements AppPreferencesRepository {
  @override
  /// Purpose: Read persisted settings from local storage with safe defaults.
  StoredPreferences read() {
    final payload = _readPayload();
    return StoredPreferences(
      themePreference: _parseTheme(payload[_SettingField.theme] as String?),
      languagePreference: _parseLanguage(
        payload[_SettingField.language] as String?,
      ),
      onboardingCompleted:
          payload[_SettingField.onboardingCompleted] as bool? ?? false,
    );
  }

  @override
  /// Purpose: Save only theme preference while preserving other fields.
  void saveThemePreference(ThemePreference preference) {
    final payload = _readPayload();
    payload[_SettingField.theme] = preference.name;
    _writePayload(payload);
  }

  @override
  /// Purpose: Save only language preference while preserving other fields.
  void saveLanguagePreference(LanguagePreference preference) {
    final payload = _readPayload();
    payload[_SettingField.language] = preference.name;
    _writePayload(payload);
  }

  @override
  /// Purpose: Save onboarding completion while preserving other fields.
  void saveOnboardingCompleted(bool completed) {
    final payload = _readPayload();
    payload[_SettingField.onboardingCompleted] = completed;
    _writePayload(payload);
  }

  /// Purpose: Decode local storage JSON with schema fallback safety.
  Map<String, Object?> _readPayload() {
    final raw = html.window.localStorage[WebStorageKeys.appPreferences];
    if (raw == null || raw.isEmpty) {
      return <String, Object?>{};
    }

    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      return <String, Object?>{};
    }

    return decoded.map((key, value) => MapEntry<String, Object?>(key, value));
  }

  /// Purpose: Persist JSON payload to local storage in one write operation.
  void _writePayload(Map<String, Object?> payload) {
    html.window.localStorage[WebStorageKeys.appPreferences] = jsonEncode(
      payload,
    );
  }

  /// Purpose: Parse theme enum from stored raw string safely.
  ThemePreference _parseTheme(String? value) {
    return ThemePreference.values.firstWhere(
      (item) => item.name == value,
      orElse: () => ThemePreference.system,
    );
  }

  /// Purpose: Parse language enum from stored raw string safely.
  LanguagePreference _parseLanguage(String? value) {
    return LanguagePreference.values.firstWhere(
      (item) => item.name == value,
      orElse: () => LanguagePreference.system,
    );
  }
}

/// Purpose: Centralize serialized field names for app settings persistence.
abstract final class _SettingField {
  static const String theme = 'theme_preference';
  static const String language = 'language_preference';
  static const String onboardingCompleted = 'onboarding_completed';
}
