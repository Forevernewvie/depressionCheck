import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vibemental_app/core/ads/ad_providers.dart';
import 'package:vibemental_app/core/config/ad_config.dart';
import 'package:vibemental_app/core/config/app_routes.dart';
import 'package:vibemental_app/l10n/app_localizations.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  /// Purpose: Render first-entry home with primary screening and support tools.
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
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            l10n.homeTitle,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          Text(l10n.homeSubtitle, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 16),
          _primaryFlowCard(context, l10n),
          const SizedBox(height: 20),
          Text(
            l10n.homeWellnessToolsTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          _featureCard(
            context,
            title: l10n.homeDailyCheckInTitle,
            subtitle: l10n.homeDailyCheckInSubtitle,
            buttonLabel: l10n.homeDailyCheckInCta,
            icon: Icons.calendar_today_outlined,
            onTap: () => context.push(AppRoutes.checkIn),
          ),
          _featureCard(
            context,
            title: l10n.homeSafetyPlanTitle,
            subtitle: l10n.homeSafetyPlanSubtitle,
            buttonLabel: l10n.homeSafetyPlanCta,
            icon: Icons.health_and_safety_outlined,
            onTap: () => context.push(AppRoutes.safetyPlan),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.homeSafetyNote,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          adService.buildBanner(placement: AdPlacement.homeBottomBanner),
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(label, style: Theme.of(context).textTheme.labelLarge),
      ),
    );
  }

  /// Purpose: Render reusable entry card for optional wellbeing tools.
  Widget _featureCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String buttonLabel,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(subtitle),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(onPressed: onTap, child: Text(buttonLabel)),
            ),
          ],
        ),
      ),
    );
  }

  /// Purpose: Highlight the first recommended user journey in one actionable
  /// card so users unfamiliar with features can start without confusion.
  Widget _primaryFlowCard(BuildContext context, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.homeHowItWorksTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.notDiagnosis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            _guideStep(context, 1, l10n.homeHowItWorksStep1),
            const SizedBox(height: 8),
            _guideStep(context, 2, l10n.homeHowItWorksStep2),
            const SizedBox(height: 8),
            _guideStep(context, 3, l10n.homeHowItWorksStep3),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _levelChip(context, l10n.levelNormal),
                _levelChip(context, l10n.levelMild),
                _levelChip(context, l10n.levelModerate),
                _levelChip(context, l10n.levelHighRisk),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => context.go(AppRoutes.phq2),
                child: Text(l10n.homeStart),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Purpose: Render one concise numbered guidance step on home.
  Widget _guideStep(BuildContext context, int index, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            child: Text(
              '$index',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(text)),
      ],
    );
  }
}
