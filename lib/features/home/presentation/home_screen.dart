import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vibemental_app/core/ads/ad_providers.dart';
import 'package:vibemental_app/core/config/ad_config.dart';
import 'package:vibemental_app/core/config/app_routes.dart';
import 'package:vibemental_app/core/theme/app_semantic_colors.dart';
import 'package:vibemental_app/core/theme/app_ui_tokens.dart';
import 'package:vibemental_app/l10n/app_localizations.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  /// Purpose: Render first-entry home with a dominant screening path and
  /// calmer, clinically trustworthy support hierarchy.
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final adService = ref.watch(adServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            tooltip: l10n.homeBrowseModules,
            icon: const Icon(Icons.library_books_outlined),
            onPressed: () => context.push(AppRoutes.modules),
          ),
          IconButton(
            tooltip: l10n.homeThemeLanguage,
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
      body: ListView(
        padding: AppInsets.screenBody,
        children: [
          _heroCard(context, l10n),
          const SizedBox(height: AppSpacing.small),
          _primaryFlowCard(context, l10n),
          const SizedBox(height: AppSpacing.large),
          Text(
            l10n.homeWellnessToolsTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.xSmall),
          Text(
            l10n.homeSubtitle,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.medium),
          _featureCard(
            context,
            title: l10n.homeDailyCheckInTitle,
            subtitle: l10n.homeDailyCheckInSubtitle,
            buttonLabel: l10n.homeDailyCheckInCta,
            icon: Icons.calendar_today_outlined,
            accentColor: Theme.of(context).colorScheme.primary,
            onTap: () => context.push(AppRoutes.checkIn),
          ),
          _featureCard(
            context,
            title: l10n.homeSafetyPlanTitle,
            subtitle: l10n.homeSafetyPlanSubtitle,
            buttonLabel: l10n.homeSafetyPlanCta,
            icon: Icons.health_and_safety_outlined,
            accentColor: context.semanticColors.danger,
            onTap: () => context.push(AppRoutes.safetyPlan),
          ),
          const SizedBox(height: AppSpacing.small),
          _safetyBanner(context, l10n),
          const SizedBox(height: AppSpacing.medium),
          adService.buildBanner(placement: AdPlacement.homeBottomBanner),
        ],
      ),
    );
  }

  /// Purpose: Frame the app as a calm, screening-only experience with trust
  /// cues and reduced first-use ambiguity.
  Widget _heroCard(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: AppInsets.screen,
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
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.monitor_heart_outlined,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: AppSpacing.mediumPlus),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.homeTitle,
                        style: theme.textTheme.headlineSmall,
                      ),
                      const SizedBox(height: AppSpacing.xSmall),
                      Text(l10n.homeSubtitle, style: theme.textTheme.bodyLarge),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.large),
            Wrap(
              spacing: AppSpacing.small,
              runSpacing: AppSpacing.small,
              children: [
                _infoPill(
                  context,
                  label: l10n.notDiagnosis,
                  icon: Icons.verified_user_outlined,
                ),
                _infoPill(
                  context,
                  label: l10n.phq2FlowStepLabel,
                  icon: Icons.alt_route_outlined,
                ),
                _infoPill(
                  context,
                  label: l10n.phq2FlowEstimate,
                  icon: Icons.schedule_outlined,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Purpose: Highlight the first recommended user journey in one actionable
  /// block so the screening path is visually dominant.
  Widget _primaryFlowCard(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(AppRoutes.phq2),
        child: Padding(
          padding: AppInsets.screen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: AppInsets.section,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.play_arrow_rounded,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.medium),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.homeHowItWorksTitle,
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: AppSpacing.xSmall),
                          Text(
                            l10n.notDiagnosis,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.large),
              _guideStep(context, 1, l10n.homeHowItWorksStep1),
              const SizedBox(height: AppSpacing.smallPlus),
              _guideStep(context, 2, l10n.homeHowItWorksStep2),
              const SizedBox(height: AppSpacing.smallPlus),
              _guideStep(context, 3, l10n.homeHowItWorksStep3),
              const SizedBox(height: AppSpacing.large),
              Container(
                width: double.infinity,
                padding: AppInsets.inset,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Wrap(
                  spacing: AppSpacing.small,
                  runSpacing: AppSpacing.small,
                  children: [
                    _levelChip(context, l10n.levelNormal),
                    _levelChip(context, l10n.levelMild),
                    _levelChip(context, l10n.levelModerate),
                    _levelChip(context, l10n.levelHighRisk),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.large),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => context.push(AppRoutes.phq2),
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: Text(l10n.homeStart),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Purpose: Render reusable entry cards for secondary wellbeing tools without
  /// competing with the primary screening CTA.
  Widget _featureCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String buttonLabel,
    required IconData icon,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: AppInsets.section,
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
                    color: accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: Icon(icon, color: accentColor),
                ),
                const SizedBox(width: AppSpacing.medium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: theme.textTheme.titleMedium),
                      const SizedBox(height: AppSpacing.xSmall),
                      Text(subtitle, style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.mediumPlus),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onTap,
                icon: const Icon(Icons.arrow_forward_rounded),
                label: Text(buttonLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Purpose: Keep safety escalation visible but visually separate from the
  /// normal home-task hierarchy.
  Widget _safetyBanner(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final semanticColors = context.semanticColors;

    return Container(
      padding: AppInsets.section,
      decoration: BoxDecoration(
        color: semanticColors.danger.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: semanticColors.danger.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.local_hospital_outlined, color: semanticColors.danger),
          const SizedBox(width: AppSpacing.smallPlus),
          Expanded(
            child: Text(
              l10n.homeSafetyNote,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: semanticColors.danger,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Purpose: Render consistent severity label chips on the home screen.
  Widget _levelChip(BuildContext context, String label) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: AppInsets.compactChip,
        child: Text(label, style: Theme.of(context).textTheme.labelLarge),
      ),
    );
  }

  /// Purpose: Render a lightweight info pill for trust and time cues.
  Widget _infoPill(
    BuildContext context, {
    required String label,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: AppInsets.chip,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: colorScheme.primary),
            const SizedBox(width: AppSpacing.xSmall),
            Text(label, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  /// Purpose: Render one concise numbered guidance step on home.
  Widget _guideStep(BuildContext context, int index, String text) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            '$index',
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: colorScheme.onPrimary),
          ),
        ),
        const SizedBox(width: AppSpacing.smallPlus),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
        ),
      ],
    );
  }
}
