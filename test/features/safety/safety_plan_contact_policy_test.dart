import 'package:flutter_test/flutter_test.dart';
import 'package:vibemental_app/core/config/safety_plan_config.dart';
import 'package:vibemental_app/features/safety/presentation/safety_plan_contact_policy.dart';

void main() {
  const policy = SafetyPlanContactPolicy();

  test('allows adding contacts below the configured limit', () {
    expect(policy.canAddContact(contactCount: 0), isTrue);
    expect(policy.canAddContact(contactCount: 2), isTrue);
  });

  test('blocks adding contacts at the configured limit', () {
    expect(
      policy.canAddContact(contactCount: SafetyPlanConfig.maxTrustedContacts),
      isFalse,
    );
  });

  test('renders the stable contact count label', () {
    expect(
      policy.contactCountLabel(contactCount: 2),
      '2/${SafetyPlanConfig.maxTrustedContacts}',
    );
  });
}
