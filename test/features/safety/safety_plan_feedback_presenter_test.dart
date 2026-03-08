import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vibemental_app/core/errors/app_failure.dart';
import 'package:vibemental_app/features/safety/presentation/safety_plan_feedback_presenter.dart';
import 'package:vibemental_app/l10n/app_localizations.dart';

void main() {
  const presenter = SafetyPlanFeedbackPresenter();
  final l10n = lookupAppLocalizations(const Locale('en'));

  test('maps save success to non-error feedback', () {
    final message = presenter.savePlanResult(l10n: l10n, success: true);

    expect(message.text, 'Safety plan saved.');
    expect(message.isError, isFalse);
  });

  test('maps save failure to error feedback', () {
    final message = presenter.savePlanResult(l10n: l10n, success: false);

    expect(message.text, 'Unable to save safety plan.');
    expect(message.isError, isTrue);
  });

  test('builds contact-saved feedback', () {
    final message = presenter.contactSaved(l10n);

    expect(message.text, 'Trusted contact saved.');
    expect(message.isError, isFalse);
  });

  test(
    'builds phone-failure feedback from localized prefix and failure text',
    () {
      final message = presenter.callFailure(
        l10n: l10n,
        failure: const PermissionFailure(
          message: 'Phone calls are unavailable.',
          code: 'call_unavailable',
        ),
      );

      expect(message.text, 'Call action failed: Phone calls are unavailable.');
      expect(message.isError, isTrue);
    },
  );
}
