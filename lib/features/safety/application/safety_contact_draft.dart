import 'package:vibemental_app/features/safety/domain/safety_validators.dart';
import 'package:vibemental_app/features/safety/domain/trusted_contact.dart';

/// Purpose: Carry normalized trusted-contact input before persistence.
class SafetyContactDraft {
  const SafetyContactDraft._({
    required this.name,
    required this.relation,
    required this.phone,
    required this.isPrimary,
  });

  /// Purpose: Normalize raw user input into a consistent draft model.
  factory SafetyContactDraft.fromRaw({
    required String name,
    required String relation,
    required String phone,
    required bool isPrimary,
  }) {
    return SafetyContactDraft._(
      name: name.trim(),
      relation: relation.trim(),
      phone: normalizeContactPhone(phone),
      isPrimary: isPrimary,
    );
  }

  final String name;
  final String relation;
  final String phone;
  final bool isPrimary;

  /// Purpose: Indicate whether the draft satisfies all trusted-contact rules.
  bool get isValid {
    return isValidContactName(name) &&
        isValidContactRelation(relation) &&
        isValidContactPhone(phone);
  }

  /// Purpose: Create the persisted contact entity using ordering metadata.
  TrustedContact toTrustedContact({
    required int id,
    required int sortOrder,
    required bool enforcePrimary,
  }) {
    return TrustedContact(
      id: id,
      name: name,
      relation: relation,
      phone: phone,
      isPrimary: isPrimary || enforcePrimary,
      sortOrder: sortOrder,
    );
  }
}
