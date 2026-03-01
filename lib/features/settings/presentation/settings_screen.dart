import 'package:flutter/material.dart';
import 'package:vibemental_app/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibemental_app/core/settings/app_settings.dart';
import 'package:vibemental_app/core/settings/settings_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            l10n.settingsTheme,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          SegmentedButton<ThemePreference>(
            segments: [
              ButtonSegment(
                value: ThemePreference.system,
                label: Text(l10n.themeSystem),
              ),
              ButtonSegment(
                value: ThemePreference.light,
                label: Text(l10n.themeLight),
              ),
              ButtonSegment(
                value: ThemePreference.dark,
                label: Text(l10n.themeDark),
              ),
            ],
            selected: {settings.themePreference},
            onSelectionChanged: (selection) {
              controller.updateTheme(selection.first);
            },
          ),
          const SizedBox(height: 20),
          Text(
            l10n.settingsLanguage,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          SegmentedButton<LanguagePreference>(
            segments: [
              ButtonSegment(
                value: LanguagePreference.system,
                label: Text(l10n.languageSystem),
              ),
              ButtonSegment(
                value: LanguagePreference.ko,
                label: Text(l10n.languageKorean),
              ),
              ButtonSegment(
                value: LanguagePreference.en,
                label: Text(l10n.languageEnglish),
              ),
            ],
            selected: {settings.languagePreference},
            onSelectionChanged: (selection) {
              controller.updateLanguage(selection.first);
            },
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.settingsFallback),
                  const SizedBox(height: 6),
                  Text(l10n.settingsPriority),
                  const SizedBox(height: 6),
                  Text(l10n.settingsPersistence),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
