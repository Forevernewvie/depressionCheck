import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibemental_app/app/router.dart';
import 'package:vibemental_app/core/config/app_env.dart';
import 'package:vibemental_app/core/settings/app_settings.dart';
import 'package:vibemental_app/core/settings/settings_controller.dart';
import 'package:vibemental_app/core/theme/app_theme.dart';
import 'package:vibemental_app/l10n/app_localizations.dart';

class MindCheckApp extends ConsumerWidget {
  const MindCheckApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsControllerProvider);
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: AppEnv.appName,
      routerConfig: router,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settings.themeMode,
      locale: settings.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      localeResolutionCallback: _resolveLocale(settings),
    );
  }

  /// Purpose: Resolve effective locale with explicit user override precedence.
  Locale? Function(Locale?, Iterable<Locale>) _resolveLocale(
    AppSettings settings,
  ) {
    return (deviceLocale, supportedLocales) {
      if (settings.languagePreference != LanguagePreference.system) {
        return settings.locale;
      }

      if (deviceLocale == null) {
        return const Locale('en');
      }

      final code = deviceLocale.languageCode.toLowerCase();
      if (code == 'ko') {
        return const Locale('ko');
      }
      return const Locale('en');
    };
  }
}
