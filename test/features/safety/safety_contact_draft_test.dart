import 'package:flutter_test/flutter_test.dart';
import 'package:vibemental_app/features/safety/application/safety_contact_draft.dart';

void main() {
  test('draft normalizes raw values and validates trusted contact input', () {
    final draft = SafetyContactDraft.fromRaw(
      name: '  Alex Example  ',
      relation: ' Friend ',
      phone: '010-1234-5678',
      isPrimary: true,
    );

    expect(draft.name, 'Alex Example');
    expect(draft.relation, 'Friend');
    expect(draft.phone, '01012345678');
    expect(draft.isValid, isTrue);
  });

  test('draft converts normalized values into persisted contact entity', () {
    final draft = SafetyContactDraft.fromRaw(
      name: 'Sam',
      relation: 'Family',
      phone: '+82 10 1234 5678',
      isPrimary: false,
    );

    final contact = draft.toTrustedContact(
      id: 7,
      sortOrder: 2,
      enforcePrimary: true,
    );

    expect(contact.id, 7);
    expect(contact.phone, '+821012345678');
    expect(contact.isPrimary, isTrue);
    expect(contact.sortOrder, 2);
  });
}
