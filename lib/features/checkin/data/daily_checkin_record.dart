import 'package:isar/isar.dart';

part 'daily_checkin_record.g.dart';

/// Purpose: Persist one daily check-in entry for trend rendering.
@collection
class DailyCheckInRecord {
  Id id = Isar.autoIncrement;

  /// Purpose: Ensure one record per local date key.
  @Index(unique: true)
  late String localDateKey;

  /// Purpose: Mood score in the configured range.
  late int mood;

  /// Purpose: Energy score in the configured range.
  late int energy;

  /// Purpose: Optional short user note.
  String? note;

  /// Purpose: Keep insertion/update timestamp for sorting.
  @Index()
  late DateTime createdAt;
}
