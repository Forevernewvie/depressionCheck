import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vibemental_app/core/config/app_routes.dart';
import 'package:vibemental_app/core/config/screening_labels.dart';
import 'package:vibemental_app/l10n/app_localizations.dart';

class ModulesScreen extends StatelessWidget {
  const ModulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.modulesTitle)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _ModuleCard(
            title: l10n.modulePhq2Title,
            description: l10n.modulePhq2Desc,
            bands: ScreeningLabels.phq2Bands,
          ),
          _ModuleCard(
            title: l10n.modulePhq9Title,
            description: l10n.modulePhq9Desc,
            bands: ScreeningLabels.phq9Bands,
          ),
          _ModuleCard(
            title: l10n.moduleBdiTitle,
            description: l10n.moduleBdiDesc,
            bands: ScreeningLabels.bdi2Bands,
            note: l10n.moduleBdiNote,
          ),
          _ModuleCard(
            title: l10n.moduleHadsTitle,
            description: l10n.moduleHadsDesc,
            bands: ScreeningLabels.hadsDBands,
          ),
          _ModuleCard(
            title: l10n.moduleCesdTitle,
            description: l10n.moduleCesdDesc,
            bands: ScreeningLabels.cesDBands,
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => context.push(AppRoutes.clinician),
            child: Text(l10n.moduleClinicianButton),
          ),
        ],
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
  });

  final String title;
  final String description;
  final String bands;
  final String? note;

  @override
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
          ],
        ),
      ),
    );
  }
}
