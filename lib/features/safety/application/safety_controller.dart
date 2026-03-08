import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibemental_app/core/config/safety_plan_config.dart';
import 'package:vibemental_app/core/logging/app_logger.dart';
import 'package:vibemental_app/features/safety/application/safety_contact_draft.dart';
import 'package:vibemental_app/features/safety/application/safety_state.dart';
import 'package:vibemental_app/features/safety/data/safety_repository.dart';
import 'package:vibemental_app/features/safety/domain/safety_plan_data.dart';
import 'package:vibemental_app/features/safety/domain/safety_validators.dart';
import 'package:vibemental_app/features/safety/domain/trusted_contact.dart';

/// Purpose: Coordinate safety-plan and trusted-contact state transitions.
class SafetyController extends StateNotifier<SafetyState> {
  SafetyController(this._repository, this._logger)
    : super(const SafetyState()) {
    _restore();
  }

  final SafetyRepository _repository;
  final AppLogger _logger;

  /// Purpose: Restore safety-plan snapshot from local persistence.
  void _restore() {
    final snapshot = _repository.readSnapshot();
    state = state.copyWith(
      warningSigns: snapshot.plan.warningSigns,
      copingStrategies: snapshot.plan.copingStrategies,
      reasonsToStaySafe: snapshot.plan.reasonsToStaySafe,
      emergencySteps: snapshot.plan.emergencySteps,
      contacts: snapshot.contacts,
      clearActionResult: true,
    );
  }

  /// Purpose: Update warning-signs section with defensive normalization.
  void updateWarningSigns(String raw) {
    state = state.copyWith(
      warningSigns: normalizeSafetySection(raw),
      clearActionResult: true,
    );
  }

  /// Purpose: Update coping-strategies section with defensive normalization.
  void updateCopingStrategies(String raw) {
    state = state.copyWith(
      copingStrategies: normalizeSafetySection(raw),
      clearActionResult: true,
    );
  }

  /// Purpose: Update reasons-to-stay-safe section with defensive normalization.
  void updateReasonsToStaySafe(String raw) {
    state = state.copyWith(
      reasonsToStaySafe: normalizeSafetySection(raw),
      clearActionResult: true,
    );
  }

  /// Purpose: Update emergency-steps section with defensive normalization.
  void updateEmergencySteps(String raw) {
    state = state.copyWith(
      emergencySteps: normalizeSafetySection(raw),
      clearActionResult: true,
    );
  }

  /// Purpose: Persist safety-plan sections and refresh state snapshot.
  Future<bool> savePlan() async {
    state = state.copyWith(isSaving: true, clearActionResult: true);
    try {
      _repository.savePlan(
        SafetyPlanData(
          warningSigns: state.warningSigns,
          copingStrategies: state.copingStrategies,
          reasonsToStaySafe: state.reasonsToStaySafe,
          emergencySteps: state.emergencySteps,
        ),
      );
      _restore();
      state = state.copyWith(isSaving: false, lastActionSucceeded: true);
      return true;
    } catch (error, stackTrace) {
      _logger.error(
        'Failed to save safety-plan.',
        error: error,
        stackTrace: stackTrace,
      );
      state = state.copyWith(isSaving: false, lastActionSucceeded: false);
      return false;
    }
  }

  /// Purpose: Add a new trusted contact after validation and sanitization.
  Future<bool> addContact(SafetyContactDraft draft) async {
    if (state.contacts.length >= SafetyPlanConfig.maxTrustedContacts) {
      return false;
    }

    if (!draft.isValid) {
      return false;
    }

    try {
      _repository.upsertContact(
        draft.toTrustedContact(
          id: 0,
          sortOrder: state.contacts.length,
          enforcePrimary: state.contacts.isEmpty,
        ),
      );
      _restore();
      state = state.copyWith(lastActionSucceeded: true);
      return true;
    } catch (error, stackTrace) {
      _logger.error(
        'Failed to add trusted contact.',
        error: error,
        stackTrace: stackTrace,
      );
      state = state.copyWith(lastActionSucceeded: false);
      return false;
    }
  }

  /// Purpose: Set one trusted contact as primary for one-tap action.
  Future<void> setPrimary(int id) async {
    TrustedContact? target;
    for (final contact in state.contacts) {
      if (contact.id == id) {
        target = contact;
        break;
      }
    }
    if (target == null) {
      _logger.warn('Requested primary contact not found.', context: {'id': id});
      return;
    }

    _repository.upsertContact(
      TrustedContact(
        id: target.id,
        name: target.name,
        relation: target.relation,
        phone: target.phone,
        isPrimary: true,
        sortOrder: target.sortOrder,
      ),
    );
    _restore();
  }

  /// Purpose: Remove trusted contact from safety-plan quick action list.
  Future<void> deleteContact(int id) async {
    _repository.deleteContact(id);
    _restore();
  }
}
