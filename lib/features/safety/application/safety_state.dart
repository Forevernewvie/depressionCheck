import 'package:vibemental_app/features/safety/domain/trusted_contact.dart';

/// Purpose: Hold safety-plan editable content and trusted contacts for UI.
class SafetyState {
  const SafetyState({
    this.warningSigns = '',
    this.copingStrategies = '',
    this.reasonsToStaySafe = '',
    this.emergencySteps = '',
    this.contacts = const [],
    this.isSaving = false,
    this.lastActionSucceeded,
  });

  final String warningSigns;
  final String copingStrategies;
  final String reasonsToStaySafe;
  final String emergencySteps;
  final List<TrustedContact> contacts;
  final bool isSaving;
  final bool? lastActionSucceeded;

  /// Purpose: Return current primary contact if one exists.
  TrustedContact? get primaryContact {
    for (final contact in contacts) {
      if (contact.isPrimary) {
        return contact;
      }
    }
    return null;
  }

  /// Purpose: Build immutable next state.
  SafetyState copyWith({
    String? warningSigns,
    String? copingStrategies,
    String? reasonsToStaySafe,
    String? emergencySteps,
    List<TrustedContact>? contacts,
    bool? isSaving,
    bool? lastActionSucceeded,
    bool clearActionResult = false,
  }) {
    return SafetyState(
      warningSigns: warningSigns ?? this.warningSigns,
      copingStrategies: copingStrategies ?? this.copingStrategies,
      reasonsToStaySafe: reasonsToStaySafe ?? this.reasonsToStaySafe,
      emergencySteps: emergencySteps ?? this.emergencySteps,
      contacts: contacts ?? this.contacts,
      isSaving: isSaving ?? this.isSaving,
      lastActionSucceeded: clearActionResult
          ? null
          : lastActionSucceeded ?? this.lastActionSucceeded,
    );
  }
}
