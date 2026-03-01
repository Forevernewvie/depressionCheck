import 'package:flutter_test/flutter_test.dart';
import 'package:vibemental_app/core/config/safety_plan_config.dart';
import 'package:vibemental_app/features/safety/domain/safety_validators.dart';

void main() {
  test('normalizes section text and trims oversized content', () {
    final longText = 'a' * (SafetyPlanConfig.maxSectionLength + 20);

    final normalized = normalizeSafetySection('  $longText  ');

    expect(normalized.length, SafetyPlanConfig.maxSectionLength);
  });

  test('sanitizes phone number to dialable symbols', () {
    final normalized = normalizeContactPhone(' +82 (010)-1234-5678 ');

    expect(normalized, '+8201012345678');
  });

  test('validates trusted contact fields defensively', () {
    expect(isValidContactName('Alex'), isTrue);
    expect(isValidContactRelation('Friend'), isTrue);
    expect(isValidContactPhone('+8201012345678'), isTrue);

    expect(isValidContactName(''), isFalse);
    expect(isValidContactRelation(''), isFalse);
    expect(isValidContactPhone('123'), isFalse);
  });
}
