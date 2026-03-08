import 'package:flutter/material.dart';
import 'package:vibemental_app/features/common/widgets/page_content_container.dart';
import 'package:vibemental_app/features/settings/domain/privacy_policy_content.dart';
import 'package:vibemental_app/l10n/app_localizations.dart';

/// Purpose: Present an in-app privacy policy that matches current app behavior.
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  /// Purpose: Render localized privacy-policy sections in a readable layout.
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final content = PrivacyPolicyContent.fromLocalizations(l10n);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(content.title)),
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
                    Text(content.summary, style: textTheme.bodyLarge),
                    const SizedBox(height: 12),
                    Text(
                      '${content.lastUpdatedLabel}: ${content.lastUpdatedValue}',
                      style: textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            for (final section in content.sections) ...[
              _PrivacyPolicySectionCard(section: section),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}

/// Purpose: Display one privacy-policy section with selectable legal text.
class _PrivacyPolicySectionCard extends StatelessWidget {
  const _PrivacyPolicySectionCard({required this.section});

  final PrivacyPolicySection section;

  @override
  /// Purpose: Keep each legal section visually distinct and easy to scan.
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(section.title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            SelectableText(section.body),
          ],
        ),
      ),
    );
  }
}
