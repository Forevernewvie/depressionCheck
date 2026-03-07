import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibemental_app/core/config/app_env.dart';
import 'package:vibemental_app/core/config/safety_plan_config.dart';
import 'package:vibemental_app/core/platform/external_action_providers.dart';
import 'package:vibemental_app/core/result/app_result.dart';
import 'package:vibemental_app/core/theme/app_semantic_colors.dart';
import 'package:vibemental_app/core/config/layout_config.dart';
import 'package:vibemental_app/features/safety/application/safety_providers.dart';
import 'package:vibemental_app/features/safety/domain/safety_validators.dart';
import 'package:vibemental_app/features/safety/domain/trusted_contact.dart';
import 'package:vibemental_app/l10n/app_localizations.dart';

class SafetyPlanScreen extends ConsumerStatefulWidget {
  const SafetyPlanScreen({super.key});

  @override
  ConsumerState<SafetyPlanScreen> createState() => _SafetyPlanScreenState();
}

class _SafetyPlanScreenState extends ConsumerState<SafetyPlanScreen> {
  late final TextEditingController _warningController;
  late final TextEditingController _copingController;
  late final TextEditingController _reasonsController;
  late final TextEditingController _emergencyController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(safetyControllerProvider);
    _warningController = TextEditingController(text: state.warningSigns);
    _copingController = TextEditingController(text: state.copingStrategies);
    _reasonsController = TextEditingController(text: state.reasonsToStaySafe);
    _emergencyController = TextEditingController(text: state.emergencySteps);
  }

  @override
  void dispose() {
    _warningController.dispose();
    _copingController.dispose();
    _reasonsController.dispose();
    _emergencyController.dispose();
    super.dispose();
  }

  @override
  /// Purpose: Render safety plan editor and trusted-contact actions.
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(safetyControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.safetyPlanTitle)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _IntroCard(
            title: l10n.safetyPlanIntroTitle,
            body: l10n.safetyPlanIntroBody,
          ),
          const SizedBox(height: 12),
          Card(
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
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
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
                        onPressed: () => _call(context, AppEnv.emergencyPhone),
                        icon: const Icon(Icons.local_phone),
                        label: Text(l10n.buttonCallEmergency),
                      ),
                      FilledButton.tonalIcon(
                        onPressed: () => _call(context, AppEnv.crisisPhone),
                        icon: const Icon(Icons.support_agent),
                        label: Text(l10n.buttonCallCrisis),
                      ),
                      if (state.primaryContact != null)
                        FilledButton.tonalIcon(
                          onPressed: () =>
                              _call(context, state.primaryContact!.phone),
                          icon: const Icon(Icons.person_pin_circle_outlined),
                          label: Text(l10n.safetyPlanCallPrimary),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _SectionField(
            controller: _warningController,
            label: l10n.safetyPlanWarningSigns,
            icon: Icons.visibility_outlined,
            onChanged: ref
                .read(safetyControllerProvider.notifier)
                .updateWarningSigns,
          ),
          _SectionField(
            controller: _copingController,
            label: l10n.safetyPlanCoping,
            icon: Icons.self_improvement_outlined,
            onChanged: ref
                .read(safetyControllerProvider.notifier)
                .updateCopingStrategies,
          ),
          _SectionField(
            controller: _reasonsController,
            label: l10n.safetyPlanReasons,
            icon: Icons.favorite_border_rounded,
            onChanged: ref
                .read(safetyControllerProvider.notifier)
                .updateReasonsToStaySafe,
          ),
          _SectionField(
            controller: _emergencyController,
            label: l10n.safetyPlanEmergencySteps,
            icon: Icons.rule_folder_outlined,
            onChanged: ref
                .read(safetyControllerProvider.notifier)
                .updateEmergencySteps,
          ),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: state.isSaving ? null : () => _savePlan(context),
            icon: const Icon(Icons.check_rounded),
            label: Text(l10n.safetyPlanSaveButton),
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final textScale = MediaQuery.textScalerOf(context).scale(1);
              final useCompactLayout =
                  constraints.maxWidth <
                      LayoutConfig.compactScreenWidthThreshold ||
                  textScale > LayoutConfig.compactTextScaleThreshold;

              if (useCompactLayout) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.safetyPlanContactsTitle,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        Chip(
                          label: Text(
                            '${state.contacts.length}/${SafetyPlanConfig.maxTrustedContacts}',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed:
                            state.contacts.length >=
                                SafetyPlanConfig.maxTrustedContacts
                            ? null
                            : () => _showAddContactDialog(context),
                        icon: const Icon(Icons.person_add_alt_1),
                        label: Text(l10n.safetyPlanAddContact),
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
                            l10n.safetyPlanContactsTitle,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Chip(
                          label: Text(
                            '${state.contacts.length}/${SafetyPlanConfig.maxTrustedContacts}',
                          ),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed:
                        state.contacts.length >=
                            SafetyPlanConfig.maxTrustedContacts
                        ? null
                        : () => _showAddContactDialog(context),
                    icon: const Icon(Icons.person_add_alt_1),
                    label: Text(l10n.safetyPlanAddContact),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 8),
          if (state.contacts.isEmpty)
            Text(l10n.safetyPlanContactsEmpty)
          else
            for (final contact in state.contacts)
              _ContactCard(
                key: ValueKey(contact.id),
                contact: contact,
                onCall: () => _call(context, contact.phone),
                onDelete: () => ref
                    .read(safetyControllerProvider.notifier)
                    .deleteContact(contact.id),
                onSetPrimary: () => ref
                    .read(safetyControllerProvider.notifier)
                    .setPrimary(contact.id),
              ),
        ],
      ),
    );
  }

  /// Purpose: Persist edited safety-plan content and show status feedback.
  Future<void> _savePlan(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final success = await ref
        .read(safetyControllerProvider.notifier)
        .savePlan();
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? l10n.safetyPlanSavedSuccess : l10n.safetyPlanSavedFail,
        ),
      ),
    );
  }

  /// Purpose: Launch phone action and render failure feedback in UI.
  Future<void> _call(BuildContext context, String phone) async {
    final l10n = AppLocalizations.of(context)!;
    final result = await ref
        .read(externalActionServiceProvider)
        .callPhone(phone);
    if (result is AppError && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${l10n.safetyPlanCallFailed}: ${result.failure.message}',
          ),
        ),
      );
    }
  }

  /// Purpose: Collect trusted contact input and persist through controller.
  Future<void> _showAddContactDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final nameController = TextEditingController();
    final relationController = TextEditingController();
    final phoneController = TextEditingController();
    bool isPrimary = false;
    bool isSubmitting = false;
    String? validationMessage;

    Future<void> submitContact(
      StateSetter setDialogState,
      BuildContext dialogContext,
    ) async {
      final errorMessage = _validateContactDraft(
        l10n,
        name: nameController.text,
        relation: relationController.text,
        phone: phoneController.text,
      );
      if (errorMessage != null) {
        setDialogState(() {
          validationMessage = errorMessage;
        });
        return;
      }

      setDialogState(() {
        isSubmitting = true;
        validationMessage = null;
      });

      final success = await ref
          .read(safetyControllerProvider.notifier)
          .addContact(
            name: nameController.text,
            relation: relationController.text,
            phone: phoneController.text,
            isPrimary: isPrimary,
          );

      if (!dialogContext.mounted) {
        return;
      }

      if (!success) {
        setDialogState(() {
          isSubmitting = false;
          validationMessage = l10n.safetyPlanContactInvalid;
        });
        return;
      }

      Navigator.of(dialogContext).pop(true);
    }

    try {
      final submitted = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (context, setDialogState) {
              return PopScope(
                canPop: false,
                child: AlertDialog(
                  title: Text(l10n.safetyPlanAddContact),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: nameController,
                          keyboardType: TextInputType.name,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.name],
                          decoration: InputDecoration(
                            labelText: l10n.safetyPlanContactName,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: relationController,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: l10n.safetyPlanContactRelation,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.done,
                          autofillHints: const [AutofillHints.telephoneNumber],
                          decoration: InputDecoration(
                            labelText: l10n.safetyPlanContactPhone,
                          ),
                          onSubmitted: (_) =>
                              submitContact(setDialogState, dialogContext),
                        ),
                        const SizedBox(height: 8),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          value: isPrimary,
                          onChanged: isSubmitting
                              ? null
                              : (value) {
                                  setDialogState(
                                    () => isPrimary = value ?? false,
                                  );
                                },
                          title: Text(l10n.safetyPlanSetPrimary),
                        ),
                        if (validationMessage != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            validationMessage!,
                            style: Theme.of(dialogContext).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    dialogContext,
                                  ).colorScheme.error,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: isSubmitting
                          ? null
                          : () => Navigator.of(dialogContext).pop(false),
                      child: Text(l10n.safetyPlanDialogCancel),
                    ),
                    FilledButton(
                      onPressed: isSubmitting
                          ? null
                          : () => submitContact(setDialogState, dialogContext),
                      child: isSubmitting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(l10n.safetyPlanDialogSave),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );

      if (submitted != true || !context.mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.safetyPlanContactSaved)));
    } finally {
      nameController.dispose();
      relationController.dispose();
      phoneController.dispose();
    }
  }

  /// Purpose: Validate contact draft input before dismissing the dialog so
  /// user-entered values are preserved on correction.
  String? _validateContactDraft(
    AppLocalizations l10n, {
    required String name,
    required String relation,
    required String phone,
  }) {
    final normalizedName = name.trim();
    final normalizedRelation = relation.trim();
    final normalizedPhone = normalizeContactPhone(phone);

    if (!isValidContactName(normalizedName) ||
        !isValidContactRelation(normalizedRelation) ||
        !isValidContactPhone(normalizedPhone)) {
      return l10n.safetyPlanContactInvalid;
    }

    return null;
  }
}

class _SectionField extends StatelessWidget {
  const _SectionField({
    required this.controller,
    required this.label,
    required this.icon,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final ValueChanged<String> onChanged;

  @override
  /// Purpose: Render one guided safety-plan writing section with consistent
  /// iconography and card grouping.
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

class _ContactCard extends StatelessWidget {
  const _ContactCard({
    super.key,
    required this.contact,
    required this.onCall,
    required this.onDelete,
    required this.onSetPrimary,
  });

  final TrustedContact contact;
  final VoidCallback onCall;
  final VoidCallback onDelete;
  final VoidCallback onSetPrimary;

  @override
  /// Purpose: Render trusted contacts as action-ready cards with clearer
  /// operational affordances.
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

class _IntroCard extends StatelessWidget {
  const _IntroCard({required this.title, required this.body});

  final String title;
  final String body;

  @override
  /// Purpose: Frame the safety-plan screen as a calm preparation workflow
  /// before users encounter the emergency block.
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
