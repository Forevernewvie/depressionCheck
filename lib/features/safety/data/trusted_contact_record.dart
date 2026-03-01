import 'package:isar/isar.dart';

part 'trusted_contact_record.g.dart';

/// Purpose: Persist trusted contact used by one-tap safety actions.
@collection
class TrustedContactRecord {
  Id id = Isar.autoIncrement;

  @Index()
  late String name;

  @Index()
  late String relation;

  @Index(unique: true)
  late String phone;

  @Index()
  bool isPrimary = false;

  @Index()
  int sortOrder = 0;

  @Index()
  late DateTime updatedAt;
}
