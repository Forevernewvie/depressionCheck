import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vibemental_app/core/config/app_routes.dart';
import 'package:vibemental_app/l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                l10n.notDiagnosis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
          const SizedBox(height: 8),
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
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => context.go(AppRoutes.phq2),
            child: Text(l10n.homeStart),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => context.push(AppRoutes.modules),
            child: Text(l10n.homeBrowseModules),
          ),
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
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton(onPressed: onTap, child: Text(buttonLabel)),
            ),
          ],
        ),
      ),
    );
  }
}
