import 'package:flutter/material.dart';
import 'package:vibemental_app/features/safety/application/safety_contact_draft.dart';
import 'package:vibemental_app/l10n/app_localizations.dart';

/// Purpose: Collect trusted-contact input while keeping validation and submit
/// state isolated from the parent safety-plan screen.
class AddContactDialog extends StatefulWidget {
  const AddContactDialog({required this.onSubmit, super.key});

  final Future<bool> Function(SafetyContactDraft draft) onSubmit;

  @override
  /// Purpose: Create mutable dialog state for field controllers and feedback.
  State<AddContactDialog> createState() => _AddContactDialogState();
}

class _AddContactDialogState extends State<AddContactDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _relationController;
  late final TextEditingController _phoneController;
  bool _isPrimary = false;
  bool _isSubmitting = false;
  String? _validationMessage;

  @override
  /// Purpose: Initialize dialog text controllers once for the current session.
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _relationController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  /// Purpose: Dispose dialog field controllers to avoid leaking listeners.
  void dispose() {
    _nameController.dispose();
    _relationController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  /// Purpose: Render trusted-contact inputs with guarded dismissal and inline
  /// validation feedback.
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PopScope(
      canPop: false,
      child: AlertDialog(
        title: Text(l10n.safetyPlanAddContact),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
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
                controller: _relationController,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: l10n.safetyPlanContactRelation,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.telephoneNumber],
                decoration: InputDecoration(
                  labelText: l10n.safetyPlanContactPhone,
                ),
                onSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 8),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: _isPrimary,
                onChanged: _isSubmitting
                    ? null
                    : (value) {
                        setState(() {
                          _isPrimary = value ?? false;
                        });
                      },
                title: Text(l10n.safetyPlanSetPrimary),
              ),
              if (_validationMessage != null) ...[
                const SizedBox(height: 8),
                Text(
                  _validationMessage!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isSubmitting
                ? null
                : () => Navigator.of(context).pop(false),
            child: Text(l10n.safetyPlanDialogCancel),
          ),
          FilledButton(
            onPressed: _isSubmitting ? null : _submit,
            child: _isSubmitting
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
  }

  /// Purpose: Normalize inputs, validate locally, and invoke the submit use case.
  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    final draft = SafetyContactDraft.fromRaw(
      name: _nameController.text,
      relation: _relationController.text,
      phone: _phoneController.text,
      isPrimary: _isPrimary,
    );

    if (!draft.isValid) {
      setState(() {
        _validationMessage = l10n.safetyPlanContactInvalid;
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
      _validationMessage = null;
    });

    final success = await widget.onSubmit(draft);
    if (!mounted) {
      return;
    }

    if (!success) {
      setState(() {
        _isSubmitting = false;
        _validationMessage = l10n.safetyPlanContactInvalid;
      });
      return;
    }

    Navigator.of(context).pop(true);
  }
}
