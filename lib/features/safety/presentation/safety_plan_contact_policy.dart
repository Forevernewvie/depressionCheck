import 'package:vibemental_app/core/config/safety_plan_config.dart';

/// Purpose: Centralize trusted-contact header policy for count labels and
/// button availability.
class SafetyPlanContactPolicy {
  const SafetyPlanContactPolicy();

  /// Purpose: Determine whether another contact can be added.
  bool canAddContact({required int contactCount}) {
    return contactCount < SafetyPlanConfig.maxTrustedContacts;
  }

  /// Purpose: Render a stable contact-count progress label.
  String contactCountLabel({required int contactCount}) {
    return '$contactCount/${SafetyPlanConfig.maxTrustedContacts}';
  }
}
