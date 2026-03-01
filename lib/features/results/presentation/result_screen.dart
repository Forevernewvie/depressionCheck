import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vibemental_app/core/config/app_env.dart';
import 'package:vibemental_app/core/config/app_routes.dart';
import 'package:vibemental_app/core/platform/external_action_providers.dart';
import 'package:vibemental_app/core/result/app_result.dart';
import 'package:vibemental_app/core/theme/app_semantic_colors.dart';
import 'package:vibemental_app/features/common/widgets/severity_chip.dart';
import 'package:vibemental_app/features/screening/domain/screening_result.dart';
import 'package:vibemental_app/features/screening/domain/severity.dart';
import 'package:vibemental_app/l10n/app_localizations.dart';

class ResultScreen extends ConsumerWidget {
  const ResultScreen({required this.result, super.key});

  final ScreeningResult result;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.resultTitle)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.resultScore),
                  const SizedBox(height: 8),
                  Text(
                    '${result.totalScore}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  SeverityChip(severity: result.severity),
                  if (result.selfHarmPositive) ...[
                    const SizedBox(height: 8),
                    Text(
                      l10n.selfHarmOverride,
                      style: TextStyle(color: context.semanticColors.danger),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.resultNextStep,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            _guidanceForSeverity(l10n, result.severity),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          if (result.urgentCare) ...[
            Card(
              color: context.semanticColors.emergencyBackground,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.emergencyTitle,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: context.semanticColors.emergencyText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.emergencyBody,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: context.semanticColors.emergencyText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: () => _callNumber(context, ref, AppEnv.emergencyPhone),
              icon: const Icon(Icons.local_phone),
              label: Text(l10n.buttonCallEmergency),
            ),
            const SizedBox(height: 8),
            FilledButton.tonalIcon(
              onPressed: () => _callNumber(context, ref, AppEnv.crisisPhone),
              icon: const Icon(Icons.support_agent),
              label: Text(l10n.buttonCallCrisis),
            ),
            const SizedBox(height: 8),
          ],
          if (result.severity == SeverityLevel.moderate || result.urgentCare)
            FilledButton(
              onPressed: () => context.push(AppRoutes.map),
              child: Text(l10n.buttonFindClinics),
            ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => context.go(AppRoutes.home),
            child: Text(l10n.buttonBackHome),
          ),
        ],
      ),
    );
  }

  /// Purpose: Resolve localized next-step guidance for each severity level.
  String _guidanceForSeverity(AppLocalizations l10n, SeverityLevel severity) {
    switch (severity) {
      case SeverityLevel.normal:
        return l10n.guidanceNormal;
      case SeverityLevel.mild:
        return l10n.guidanceMild;
      case SeverityLevel.moderate:
        return l10n.guidanceModerate;
      case SeverityLevel.highRisk:
        return l10n.guidanceHighRisk;
    }
  }

  /// Purpose: Execute a call action and surface errors to the user safely.
  Future<void> _callNumber(
    BuildContext context,
    WidgetRef ref,
    String phone,
  ) async {
    final actions = ref.read(externalActionServiceProvider);
    final result = await actions.callPhone(phone);

    if (result is AppError && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result.failure.message)));
    }
  }
}
