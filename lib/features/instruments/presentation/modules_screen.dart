import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vibemental_app/core/ads/ad_providers.dart';
import 'package:vibemental_app/core/config/ad_config.dart';
import 'package:vibemental_app/core/config/app_routes.dart';
import 'package:vibemental_app/core/config/screening_labels.dart';
import 'package:vibemental_app/features/common/widgets/page_content_container.dart';
import 'package:vibemental_app/l10n/app_localizations.dart';

class ModulesScreen extends ConsumerWidget {
  const ModulesScreen({super.key});

  @override
  /// Purpose: Render instrument module overview and a non-critical ad placement.
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final adService = ref.watch(adServiceProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.modulesTitle)),
      body: PageContentContainer(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _ModuleCard(
              title: l10n.modulePhq2Title,
              description: l10n.modulePhq2Desc,
              bands: ScreeningLabels.phq2Bands,
              buttonLabel: l10n.moduleStartButton,
              onTap: () => context.push(AppRoutes.phq2),
            ),
            _ModuleCard(
              title: l10n.modulePhq9Title,
              description: l10n.modulePhq9Desc,
              bands: ScreeningLabels.phq9Bands,
              buttonLabel: l10n.moduleStartButton,
              onTap: () => context.push(AppRoutes.phq9),
            ),
            _ModuleCard(
              title: l10n.moduleBdiTitle,
              description: l10n.moduleBdiDesc,
              bands: ScreeningLabels.bdi2Bands,
              note: l10n.moduleBdiNote,
              buttonLabel: l10n.moduleStartButton,
              onTap: () => context.push(AppRoutes.bdi2),
            ),
            _ModuleCard(
              title: l10n.moduleHadsTitle,
              description: l10n.moduleHadsDesc,
              bands: ScreeningLabels.hadsDBands,
              buttonLabel: l10n.moduleStartButton,
              onTap: () => context.push(AppRoutes.hadsD),
            ),
            _ModuleCard(
              title: l10n.moduleCesdTitle,
              description: l10n.moduleCesdDesc,
              bands: ScreeningLabels.cesDBands,
              buttonLabel: l10n.moduleStartButton,
              onTap: () => context.push(AppRoutes.cesD),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => context.push(AppRoutes.clinician),
              child: Text(l10n.moduleClinicianButton),
            ),
            const SizedBox(height: 12),
            adService.buildBanner(placement: AdPlacement.modulesBottomBanner),
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
    this.note,
    this.buttonLabel,
    this.onTap,
  });

  final String title;
  final String description;
  final String bands;
  final String? note;
  final String? buttonLabel;
  final VoidCallback? onTap;

  @override
  /// Purpose: Render one module summary card with optional entry CTA.
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 8),
            Text(bands, style: Theme.of(context).textTheme.labelLarge),
            if (note != null) ...[
              const SizedBox(height: 8),
              Text(note!, style: Theme.of(context).textTheme.bodySmall),
            ],
            if (onTap != null && buttonLabel != null) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: onTap,
                  child: Text(buttonLabel!),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
