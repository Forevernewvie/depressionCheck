import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibemental_app/core/config/app_env.dart';
import 'package:vibemental_app/core/platform/external_action_providers.dart';
import 'package:vibemental_app/features/safety/application/safety_providers.dart';
import 'package:vibemental_app/features/safety/presentation/add_contact_dialog.dart';
import 'package:vibemental_app/features/safety/presentation/safety_plan_contact_policy.dart';
import 'package:vibemental_app/features/safety/presentation/safety_plan_feedback_presenter.dart';
import 'package:vibemental_app/features/safety/presentation/safety_plan_messenger.dart';
import 'package:vibemental_app/features/safety/presentation/widgets/safety_plan_sections.dart';
import 'package:vibemental_app/l10n/app_localizations.dart';

class SafetyPlanScreen extends ConsumerStatefulWidget {
  const SafetyPlanScreen({super.key});

  @override
  ConsumerState<SafetyPlanScreen> createState() => _SafetyPlanScreenState();
}

class _SafetyPlanScreenState extends ConsumerState<SafetyPlanScreen> {
  static const _feedbackPresenter = SafetyPlanFeedbackPresenter();
  static const _contactPolicy = SafetyPlanContactPolicy();

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
          SafetyIntroCard(
            title: l10n.safetyPlanIntroTitle,
            body: l10n.safetyPlanIntroBody,
          ),
          const SizedBox(height: 12),
          SafetyEmergencyCard(
            onCallEmergency: () => _call(context, AppEnv.emergencyPhone),
            onCallCrisis: () => _call(context, AppEnv.crisisPhone),
            onCallPrimary: state.primaryContact == null
                ? null
                : () => _call(context, state.primaryContact!.phone),
            primaryContact: state.primaryContact,
          ),
          const SizedBox(height: 16),
          SafetySectionField(
            controller: _warningController,
            label: l10n.safetyPlanWarningSigns,
            icon: Icons.visibility_outlined,
            onChanged: ref
                .read(safetyControllerProvider.notifier)
                .updateWarningSigns,
          ),
          SafetySectionField(
            controller: _copingController,
            label: l10n.safetyPlanCoping,
            icon: Icons.self_improvement_outlined,
            onChanged: ref
                .read(safetyControllerProvider.notifier)
                .updateCopingStrategies,
          ),
          SafetySectionField(
            controller: _reasonsController,
            label: l10n.safetyPlanReasons,
            icon: Icons.favorite_border_rounded,
            onChanged: ref
                .read(safetyControllerProvider.notifier)
                .updateReasonsToStaySafe,
          ),
          SafetySectionField(
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
          SafetyContactsHeader(
            title: l10n.safetyPlanContactsTitle,
            addLabel: l10n.safetyPlanAddContact,
            countLabel: _contactPolicy.contactCountLabel(
              contactCount: state.contacts.length,
            ),
            canAddContact: _contactPolicy.canAddContact(
              contactCount: state.contacts.length,
            ),
            onAddContact: () => _showAddContactDialog(context),
          ),
          const SizedBox(height: 8),
          if (state.contacts.isEmpty)
            Text(l10n.safetyPlanContactsEmpty)
          else
            for (final contact in state.contacts)
              SafetyContactCard(
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
    SafetyPlanMessenger.show(
      context,
      _feedbackPresenter.savePlanResult(l10n: l10n, success: success),
    );
  }

  /// Purpose: Launch phone action and render failure feedback in UI.
  Future<void> _call(BuildContext context, String phone) async {
    final l10n = AppLocalizations.of(context)!;
    final result = await ref
        .read(externalActionServiceProvider)
        .callPhone(phone);
    if (!context.mounted) {
      return;
    }

    result.when(
      success: (_) {},
      failure: (failure) {
        SafetyPlanMessenger.show(
          context,
          _feedbackPresenter.callFailure(l10n: l10n, failure: failure),
        );
      },
    );
  }

  /// Purpose: Collect trusted contact input and persist through controller.
  Future<void> _showAddContactDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final submitted = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AddContactDialog(
          onSubmit: (draft) {
            return ref
                .read(safetyControllerProvider.notifier)
                .addContact(draft);
          },
        );
      },
    );

    if (submitted != true || !context.mounted) {
      return;
    }

    SafetyPlanMessenger.show(context, _feedbackPresenter.contactSaved(l10n));
  }
}
