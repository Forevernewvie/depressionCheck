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
  /// Purpose: Present a clearer result hierarchy so urgency and next steps are
  /// immediately understandable.
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final semanticColors = context.semanticColors;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.resultTitle)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: _accentColor(
                            semanticColors,
                          ).withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          result.urgentCare
                              ? Icons.priority_high_rounded
                              : Icons.insights_outlined,
                          color: _accentColor(semanticColors),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.resultScore,
                              style: theme.textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${result.totalScore}',
                              style: theme.textTheme.headlineMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SeverityChip(severity: result.severity),
                  const SizedBox(height: 14),
                  Text(l10n.notDiagnosis, style: theme.textTheme.bodyMedium),
                  if (result.selfHarmPositive) ...[
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: semanticColors.danger.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: semanticColors.danger.withValues(alpha: 0.22),
                        ),
                      ),
                      child: Text(
                        l10n.selfHarmOverride,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: semanticColors.danger,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (result.urgentCare) ...[
            const SizedBox(height: 8),
            Card(
              color: semanticColors.emergencyBackground,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.emergencyTitle,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: semanticColors.emergencyText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.emergencyBody,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: semanticColors.emergencyText,
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
          ],
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.resultNextStep, style: theme.textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      _guidanceForSeverity(l10n, result.severity),
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                  if (result.severity == SeverityLevel.moderate ||
                      result.urgentCare) ...[
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () => context.push(AppRoutes.map),
                        icon: const Icon(Icons.map_outlined),
                        label: Text(l10n.buttonFindClinics),
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => context.go(AppRoutes.home),
                      child: Text(l10n.buttonBackHome),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Purpose: Resolve the summary accent color based on severity while keeping
  /// emergency states visually distinct.
  Color _accentColor(AppSemanticColors semanticColors) {
    switch (result.severity) {
      case SeverityLevel.normal:
        return semanticColors.success;
      case SeverityLevel.mild:
        return semanticColors.warning;
      case SeverityLevel.moderate:
        return semanticColors.warning;
      case SeverityLevel.highRisk:
        return semanticColors.danger;
    }
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
