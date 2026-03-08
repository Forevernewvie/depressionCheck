import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibemental_app/core/settings/app_settings.dart';
import 'package:vibemental_app/core/settings/settings_controller.dart';
import 'package:vibemental_app/core/config/layout_config.dart';
import 'package:vibemental_app/features/common/widgets/page_content_container.dart';
import 'package:vibemental_app/features/settings/application/privacy_policy_providers.dart';
import 'package:vibemental_app/l10n/app_localizations.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  /// Purpose: Render theme/language controls with overflow-safe layout.
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: PageContentContainer(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              l10n.settingsTheme,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            _ResponsiveSegmentedControl<ThemePreference>(
              selected: {settings.themePreference},
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
            _ResponsiveSegmentedControl<LanguagePreference>(
              selected: {settings.languagePreference},
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
            const SizedBox(height: 20),
            Text(
              l10n.settingsLegal,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.privacy_tip_outlined),
                title: Text(l10n.settingsPrivacyPolicyTitle),
                subtitle: Text(l10n.settingsPrivacyPolicySubtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _openPrivacyPolicy(context, ref),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Purpose: Open the public privacy-policy page and show user feedback when
/// the external browser cannot be launched.
Future<void> _openPrivacyPolicy(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context)!;
  final launcher = ref.read(privacyPolicyLauncherProvider);
  final opened = await launcher.openPrivacyPolicy();
  if (!context.mounted || opened) {
    return;
  }

  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(l10n.settingsPrivacyPolicyOpenFailed)));
}

class _ResponsiveSegmentedControl<T> extends StatelessWidget {
  const _ResponsiveSegmentedControl({
    required this.segments,
    required this.selected,
    required this.onSelectionChanged,
  });

  final List<ButtonSegment<T>> segments;
  final Set<T> selected;
  final ValueChanged<Set<T>> onSelectionChanged;

  @override
  /// Purpose: Prevent segmented controls from overflowing on narrow widths.
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textScale = MediaQuery.textScalerOf(context).scale(1);
        final needsHorizontalScroll =
            constraints.maxWidth < LayoutConfig.compactScreenWidthThreshold ||
            textScale > LayoutConfig.compactTextScaleThreshold;
        if (!needsHorizontalScroll) {
          return SegmentedButton<T>(
            segments: segments,
            selected: selected,
            onSelectionChanged: onSelectionChanged,
          );
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: SegmentedButton<T>(
              segments: segments,
              selected: selected,
              onSelectionChanged: onSelectionChanged,
            ),
          ),
        );
      },
    );
  }
}
