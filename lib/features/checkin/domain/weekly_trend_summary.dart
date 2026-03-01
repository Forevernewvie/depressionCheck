import 'package:vibemental_app/features/checkin/domain/daily_checkin_entry.dart';

/// Purpose: Hold computed trend data for recent daily check-ins.
class WeeklyTrendSummary {
  const WeeklyTrendSummary({
    required this.entries,
    required this.averageMood,
    required this.averageEnergy,
  });

  final List<DailyCheckInEntry> entries;
  final double averageMood;
  final double averageEnergy;

  /// Purpose: Build trend summary from a list of entries.
  factory WeeklyTrendSummary.fromEntries(List<DailyCheckInEntry> entries) {
    if (entries.isEmpty) {
      return const WeeklyTrendSummary(
        entries: [],
        averageMood: 0,
        averageEnergy: 0,
      );
    }

    final moodTotal = entries.fold<int>(0, (sum, item) => sum + item.mood);
    final energyTotal = entries.fold<int>(0, (sum, item) => sum + item.energy);
    final count = entries.length;

    return WeeklyTrendSummary(
      entries: entries,
      averageMood: moodTotal / count,
      averageEnergy: energyTotal / count,
    );
  }
}
