import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vibemental_app/core/config/app_routes.dart';
import 'package:vibemental_app/core/theme/app_ui_tokens.dart';
import 'package:vibemental_app/l10n/app_localizations.dart';

/// Purpose: Present a truthful fallback when the result route is opened
/// without a completed screening payload.
class ResultUnavailableScreen extends StatelessWidget {
  const ResultUnavailableScreen({super.key});

  @override
  /// Purpose: Render an explanatory state instead of fabricating a benign
  /// screening result when route data is missing.
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.resultTitle)),
      body: ListView(
        padding: AppInsets.screen,
        children: [
          Card(
            child: Padding(
              padding: AppInsets.card,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: colorScheme.tertiaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.assignment_late_outlined,
                      color: colorScheme.onTertiaryContainer,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  Text(
                    l10n.resultUnavailableTitle,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.small),
                  Text(
                    l10n.resultUnavailableBody,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.small),
          FilledButton.icon(
            onPressed: () => context.go(AppRoutes.phq2),
            icon: const Icon(Icons.arrow_forward_rounded),
            label: Text(l10n.resultUnavailableStart),
          ),
          const SizedBox(height: AppSpacing.small),
          OutlinedButton(
            onPressed: () => context.go(AppRoutes.home),
            child: Text(l10n.buttonBackHome),
          ),
        ],
      ),
    );
  }
}
