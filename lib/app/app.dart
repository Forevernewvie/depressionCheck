import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibemental_app/app/router.dart';
import 'package:vibemental_app/core/config/app_env.dart';
import 'package:vibemental_app/core/config/layout_config.dart';
import 'package:vibemental_app/core/settings/app_settings.dart';
import 'package:vibemental_app/core/settings/settings_controller.dart';
import 'package:vibemental_app/core/theme/app_theme.dart';
import 'package:vibemental_app/l10n/app_localizations.dart';

class MindCheckApp extends ConsumerWidget {
  const MindCheckApp({super.key});

  @override
  /// Purpose: Build app router shell with web-only frame polish and unchanged app behavior.
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
      builder: _buildAppShell,
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

  /// Purpose: Apply web-only frame layout so mobile/tablet app UI remains unchanged.
  Widget _buildAppShell(BuildContext context, Widget? child) {
    if (child == null) {
      return const SizedBox.shrink();
    }

    if (!kIsWeb) {
      return child;
    }

    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontalPadding =
            constraints.maxWidth >= LayoutConfig.webWideBreakpoint
            ? LayoutConfig.webWideHorizontalPadding
            : LayoutConfig.webHorizontalPadding;

        return ColoredBox(
          color: theme.scaffoldBackgroundColor,
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: LayoutConfig.webHorizontalPadding,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: LayoutConfig.webAppFrameMaxWidth,
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: theme.colorScheme.outlineVariant),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
