import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vibemental_app/core/ads/ad_providers.dart';
import 'package:vibemental_app/core/config/ad_config.dart';
import 'package:vibemental_app/core/config/app_routes.dart';
import 'package:vibemental_app/core/config/instrument_module_config.dart';
import 'package:vibemental_app/core/config/screening_labels.dart';
import 'package:vibemental_app/core/logging/app_logger.dart';
import 'package:vibemental_app/core/logging/logging_providers.dart';
import 'package:vibemental_app/l10n/app_localizations.dart';

class ModulesScreen extends ConsumerWidget {
  const ModulesScreen({super.key});

  @override
  /// Purpose: Render available self-screen modules and clearly separate
  /// restricted content from user-startable paths.
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final adService = ref.watch(adServiceProvider);
    final logger = ref.watch(appLoggerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.modulesTitle)),
      body: ListView(
        padding: const EdgeInsets.all(InstrumentModuleConfig.screenPadding),
        children: [
          _IntroCard(
            title: l10n.modulesIntroTitle,
            body: l10n.modulesIntroBody,
          ),
          const SizedBox(height: InstrumentModuleConfig.sectionGap),
          _ModuleCard(
            title: l10n.modulePhq2Title,
            description: l10n.modulePhq2Desc,
            bands: ScreeningLabels.phq2Bands,
            icon: Icons.speed_outlined,
            startLabel: l10n.moduleStartButton,
            onStart: _buildModuleNavigationAction(
              context,
              logger: logger,
              route: AppRoutes.phq2,
              moduleName: 'phq2',
            ),
          ),
          _ModuleCard(
            title: l10n.modulePhq9Title,
            description: l10n.modulePhq9Desc,
            bands: ScreeningLabels.phq9Bands,
            icon: Icons.fact_check_outlined,
            startLabel: l10n.moduleStartButton,
            onStart: _buildModuleNavigationAction(
              context,
              logger: logger,
              route: AppRoutes.phq9,
              moduleName: 'phq9',
            ),
          ),
          const SizedBox(height: InstrumentModuleConfig.sectionGap),
          Text(
            l10n.modulesRestrictedTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: InstrumentModuleConfig.itemGap),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(InstrumentModuleConfig.cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.lock_outline_rounded,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          l10n.moduleBdiNote,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: InstrumentModuleConfig.sectionGap),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => context.push(AppRoutes.clinician),
                      icon: const Icon(Icons.badge_outlined),
                      label: Text(l10n.moduleClinicianButton),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: InstrumentModuleConfig.sectionGap),
          adService.buildBanner(placement: AdPlacement.modulesBottomBanner),
        ],
      ),
    );
  }

  /// Purpose: Build a reusable module-open action with structured logging.
  VoidCallback _buildModuleNavigationAction(
    BuildContext context, {
    required AppLogger logger,
    required String route,
    required String moduleName,
  }) {
    return () {
      logger.info(
        'module_open_requested',
        context: {'module': moduleName, 'route': route},
      );
      context.push(route);
    };
  }
}

class _IntroCard extends StatelessWidget {
  const _IntroCard({required this.title, required this.body});

  final String title;
  final String body;

  @override
  /// Purpose: Frame the module screen around the available self-screening
  /// paths before listing individual modules.
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.library_books_outlined,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Text(body, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({
    required this.title,
    required this.description,
    required this.bands,
    required this.icon,
    this.onStart,
    this.startLabel,
  });

  final String title;
  final String description;
  final String bands;
  final IconData icon;
  final VoidCallback? onStart;
  final String? startLabel;

  @override
  /// Purpose: Render instrument summary cards with stronger hierarchy and
  /// clearer separation between content and start action.
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(InstrumentModuleConfig.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: Icon(icon, color: colorScheme.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
            const SizedBox(height: InstrumentModuleConfig.itemGap),
            Text(description),
            const SizedBox(height: InstrumentModuleConfig.itemGap),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(bands, style: Theme.of(context).textTheme.labelLarge),
            ),
            if (onStart != null && startLabel != null) ...[
              const SizedBox(height: InstrumentModuleConfig.sectionGap),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: onStart,
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: Text(startLabel!),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
