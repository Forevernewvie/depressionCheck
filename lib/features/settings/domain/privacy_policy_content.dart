import 'package:vibemental_app/l10n/app_localizations.dart';

/// Purpose: Represent one readable privacy-policy section for the legal screen.
class PrivacyPolicySection {
  const PrivacyPolicySection({required this.title, required this.body});

  final String title;
  final String body;
}

/// Purpose: Bundle localized privacy-policy metadata and section content.
class PrivacyPolicyContent {
  const PrivacyPolicyContent({
    required this.title,
    required this.summary,
    required this.lastUpdatedLabel,
    required this.lastUpdatedValue,
    required this.sections,
  });

  final String title;
  final String summary;
  final String lastUpdatedLabel;
  final String lastUpdatedValue;
  final List<PrivacyPolicySection> sections;

  /// Purpose: Build privacy-policy copy from generated localizations so the
  /// screen remains presentation-only.
  factory PrivacyPolicyContent.fromLocalizations(AppLocalizations l10n) {
    return PrivacyPolicyContent(
      title: l10n.privacyPolicyTitle,
      summary: l10n.privacyPolicySummary,
      lastUpdatedLabel: l10n.privacyPolicyLastUpdatedLabel,
      lastUpdatedValue: l10n.privacyPolicyLastUpdatedValue,
      sections: [
        PrivacyPolicySection(
          title: l10n.privacyPolicyDataTitle,
          body: l10n.privacyPolicyDataBody,
        ),
        PrivacyPolicySection(
          title: l10n.privacyPolicyPurposeTitle,
          body: l10n.privacyPolicyPurposeBody,
        ),
        PrivacyPolicySection(
          title: l10n.privacyPolicyStorageTitle,
          body: l10n.privacyPolicyStorageBody,
        ),
        PrivacyPolicySection(
          title: l10n.privacyPolicySharingTitle,
          body: l10n.privacyPolicySharingBody,
        ),
        PrivacyPolicySection(
          title: l10n.privacyPolicyAdsTitle,
          body: l10n.privacyPolicyAdsBody,
        ),
        PrivacyPolicySection(
          title: l10n.privacyPolicySecurityTitle,
          body: l10n.privacyPolicySecurityBody,
        ),
        PrivacyPolicySection(
          title: l10n.privacyPolicyControlTitle,
          body: l10n.privacyPolicyControlBody,
        ),
        PrivacyPolicySection(
          title: l10n.privacyPolicyContactTitle,
          body: l10n.privacyPolicyContactBody,
        ),
      ],
    );
  }
}
