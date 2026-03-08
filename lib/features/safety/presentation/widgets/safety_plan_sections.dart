import 'package:flutter/material.dart';
import 'package:vibemental_app/core/config/layout_config.dart';
import 'package:vibemental_app/core/config/safety_plan_config.dart';
import 'package:vibemental_app/core/theme/app_semantic_colors.dart';
import 'package:vibemental_app/features/safety/domain/trusted_contact.dart';
import 'package:vibemental_app/l10n/app_localizations.dart';

/// Purpose: Render the introductory framing card for the safety-plan workflow.
class SafetyIntroCard extends StatelessWidget {
  const SafetyIntroCard({required this.title, required this.body, super.key});

  final String title;
  final String body;

  @override
  /// Purpose: Build a calm introduction before users reach urgent actions.
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: Icon(Icons.shield_outlined, color: colorScheme.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Text(body, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Purpose: Render urgent-call actions without duplicating emergency styling in
/// the parent screen widget.
class SafetyEmergencyCard extends StatelessWidget {
  const SafetyEmergencyCard({
    required this.onCallEmergency,
    required this.onCallCrisis,
    required this.onCallPrimary,
    required this.primaryContact,
    super.key,
  });

  final VoidCallback onCallEmergency;
  final VoidCallback onCallCrisis;
  final VoidCallback? onCallPrimary;
  final TrustedContact? primaryContact;

  @override
  /// Purpose: Build high-emphasis emergency actions with optional primary
  /// contact shortcut.
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      color: context.semanticColors.emergencyBackground,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.health_and_safety_outlined,
                  color: context.semanticColors.emergencyText,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    l10n.safetyPlanEmergencyTitle,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: context.semanticColors.emergencyText,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              l10n.safetyPlanEmergencyBody,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: context.semanticColors.emergencyText,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.tonalIcon(
                  onPressed: onCallEmergency,
                  icon: const Icon(Icons.local_phone),
                  label: Text(l10n.buttonCallEmergency),
                ),
                FilledButton.tonalIcon(
                  onPressed: onCallCrisis,
                  icon: const Icon(Icons.support_agent),
                  label: Text(l10n.buttonCallCrisis),
                ),
                if (primaryContact != null)
                  FilledButton.tonalIcon(
                    onPressed: onCallPrimary,
                    icon: const Icon(Icons.person_pin_circle_outlined),
                    label: Text(l10n.safetyPlanCallPrimary),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Purpose: Render one guided safety-plan writing section with consistent
/// layout and iconography.
class SafetySectionField extends StatelessWidget {
  const SafetySectionField({
    required this.controller,
    required this.label,
    required this.icon,
    required this.onChanged,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final ValueChanged<String> onChanged;

  @override
  /// Purpose: Build a reusable card-wrapped text field for plan sections.
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Icon(icon, color: colorScheme.primary),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      label,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                minLines: 2,
                maxLines: 4,
                maxLength: SafetyPlanConfig.maxSectionLength,
                decoration: InputDecoration(labelText: label),
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Purpose: Render a trusted-contact card with primary/call/delete actions.
class SafetyContactCard extends StatelessWidget {
  const SafetyContactCard({
    required this.contact,
    required this.onCall,
    required this.onDelete,
    required this.onSetPrimary,
    super.key,
  });

  final TrustedContact contact;
  final VoidCallback onCall;
  final VoidCallback onDelete;
  final VoidCallback onSetPrimary;

  @override
  /// Purpose: Build a contact card with action buttons and primary marker.
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.person_outline_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '${contact.name} (${contact.relation})',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                if (contact.isPrimary)
                  const Icon(Icons.star, color: Colors.amber),
              ],
            ),
            const SizedBox(height: 4),
            Text(contact.phone),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.tonalIcon(
                  onPressed: onCall,
                  icon: const Icon(Icons.call),
                  label: Text(l10n.safetyPlanCallContact),
                ),
                OutlinedButton.icon(
                  onPressed: contact.isPrimary ? null : onSetPrimary,
                  icon: const Icon(Icons.star_border),
                  label: Text(l10n.safetyPlanSetPrimaryAction),
                ),
                OutlinedButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline),
                  label: Text(l10n.safetyPlanRemoveContact),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Purpose: Render the trusted-contacts section header with adaptive layout
/// and centralized count/add-action presentation.
class SafetyContactsHeader extends StatelessWidget {
  const SafetyContactsHeader({
    required this.title,
    required this.addLabel,
    required this.countLabel,
    required this.canAddContact,
    required this.onAddContact,
    super.key,
  });

  final String title;
  final String addLabel;
  final String countLabel;
  final bool canAddContact;
  final VoidCallback onAddContact;

  @override
  /// Purpose: Build a responsive contact header that keeps button affordance
  /// truthful across compact and wide layouts.
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textScale = MediaQuery.textScalerOf(context).scale(1);
        final useCompactLayout =
            constraints.maxWidth < LayoutConfig.compactScreenWidthThreshold ||
            textScale > LayoutConfig.compactTextScaleThreshold;

        if (useCompactLayout) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Chip(label: Text(countLabel)),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: canAddContact ? onAddContact : null,
                  icon: const Icon(Icons.person_add_alt_1),
                  label: Text(addLabel),
                ),
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Chip(label: Text(countLabel)),
                ],
              ),
            ),
            OutlinedButton.icon(
              onPressed: canAddContact ? onAddContact : null,
              icon: const Icon(Icons.person_add_alt_1),
              label: Text(addLabel),
            ),
          ],
        );
      },
    );
  }
}
