import 'package:vibemental_app/core/errors/app_failure.dart';
import 'package:vibemental_app/l10n/app_localizations.dart';

import 'safety_ui_message.dart';

/// Purpose: Convert safety-plan action outcomes into stable user-facing
/// feedback copy away from the screen widget.
class SafetyPlanFeedbackPresenter {
  const SafetyPlanFeedbackPresenter();

  /// Purpose: Build feedback for saving the safety plan.
  SafetyUiMessage savePlanResult({
    required AppLocalizations l10n,
    required bool success,
  }) {
    return SafetyUiMessage(
      text: success ? l10n.safetyPlanSavedSuccess : l10n.safetyPlanSavedFail,
      isError: !success,
    );
  }

  /// Purpose: Build feedback after a trusted contact is saved successfully.
  SafetyUiMessage contactSaved(AppLocalizations l10n) {
    return SafetyUiMessage(text: l10n.safetyPlanContactSaved, isError: false);
  }

  /// Purpose: Build feedback for failed phone actions without leaking
  /// additional platform details into the screen.
  SafetyUiMessage callFailure({
    required AppLocalizations l10n,
    required AppFailure failure,
  }) {
    return SafetyUiMessage(
      text: '${l10n.safetyPlanCallFailed}: ${failure.message}',
      isError: true,
    );
  }
}
