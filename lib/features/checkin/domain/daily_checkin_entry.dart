/// Purpose: Represent a daily check-in entry in the domain layer.
class DailyCheckInEntry {
  const DailyCheckInEntry({
    required this.localDateKey,
    required this.mood,
    required this.energy,
    required this.createdAt,
    this.note,
  });

  final String localDateKey;
  final int mood;
  final int energy;
  final DateTime createdAt;
  final String? note;
}
