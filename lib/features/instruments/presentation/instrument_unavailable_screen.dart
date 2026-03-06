import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vibemental_app/core/config/app_routes.dart';
import 'package:vibemental_app/features/common/widgets/page_content_container.dart';
import 'package:vibemental_app/features/screening/domain/screening_result.dart';
import 'package:vibemental_app/l10n/app_localizations.dart';

/// Purpose: Render a safety-first fallback when an instrument is not cleared
/// for distribution due to copyright/license verification requirements.
class InstrumentUnavailableScreen extends StatelessWidget {
  const InstrumentUnavailableScreen({required this.instrument, super.key});

  final ScreeningInstrument instrument;

  @override
  /// Purpose: Show license-related availability notice and safe return action.
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final title = _moduleTitle(l10n);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: PageContentContainer(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(
                      l10n.moduleBdiNote,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.notDiagnosis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => context.go(AppRoutes.modules),
              child: Text(l10n.moduleBackToModules),
            ),
          ],
        ),
      ),
    );
  }

  /// Purpose: Resolve localized module title for unavailable-state rendering.
  String _moduleTitle(AppLocalizations l10n) {
    return switch (instrument) {
      ScreeningInstrument.hadsD => l10n.moduleHadsTitle,
      ScreeningInstrument.cesD => l10n.moduleCesdTitle,
      ScreeningInstrument.bdi2 => l10n.moduleBdiTitle,
      ScreeningInstrument.phq2 => l10n.modulePhq2Title,
      ScreeningInstrument.phq9 => l10n.modulePhq9Title,
    };
  }
}
