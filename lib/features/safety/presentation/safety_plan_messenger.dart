import 'package:flutter/material.dart';

import 'safety_ui_message.dart';

/// Purpose: Encapsulate transient feedback presentation for the safety-plan
/// flow so screens do not handcraft SnackBar plumbing.
class SafetyPlanMessenger {
  const SafetyPlanMessenger._();

  /// Purpose: Show one feedback message using the nearest scaffold messenger.
  static void show(BuildContext context, SafetyUiMessage message) {
    final colorScheme = Theme.of(context).colorScheme;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: message.isError
            ? colorScheme.errorContainer
            : colorScheme.inverseSurface,
        content: Text(
          message.text,
          style: TextStyle(
            color: message.isError
                ? colorScheme.onErrorContainer
                : colorScheme.onInverseSurface,
          ),
        ),
      ),
    );
  }
}
