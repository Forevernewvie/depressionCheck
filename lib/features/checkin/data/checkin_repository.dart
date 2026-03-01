import 'package:vibemental_app/features/checkin/domain/daily_checkin_entry.dart';

/// Purpose: Define check-in persistence contract independent from storage
/// mechanism.
abstract class CheckInRepository {
  /// Purpose: Read recent check-in entries within day window.
  List<DailyCheckInEntry> readRecentEntries({required int days});

  /// Purpose: Read one check-in by local date key.
  DailyCheckInEntry? readByDateKey(String localDateKey);

  /// Purpose: Save one daily check-in entry.
  void saveEntry({
    required String localDateKey,
    required int mood,
    required int energy,
    required DateTime now,
    String? note,
  });
}
