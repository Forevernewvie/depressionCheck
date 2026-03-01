import 'package:flutter_test/flutter_test.dart';
import 'package:vibemental_app/features/checkin/domain/daily_checkin_entry.dart';
import 'package:vibemental_app/features/checkin/domain/weekly_trend_summary.dart';

void main() {
  DailyCheckInEntry buildEntry({
    required String key,
    required int mood,
    required int energy,
  }) {
    return DailyCheckInEntry(
      localDateKey: key,
      mood: mood,
      energy: energy,
      createdAt: DateTime.parse('${key}T08:00:00'),
      note: '',
    );
  }

  test('returns zero averages when entry list is empty', () {
    final summary = WeeklyTrendSummary.fromEntries(const []);

    expect(summary.entries, isEmpty);
    expect(summary.averageMood, 0);
    expect(summary.averageEnergy, 0);
  });

  test('calculates mood and energy weekly averages', () {
    final entries = [
      buildEntry(key: '2026-02-25', mood: 1, energy: 2),
      buildEntry(key: '2026-02-26', mood: 3, energy: 4),
      buildEntry(key: '2026-02-27', mood: 5, energy: 1),
    ];

    final summary = WeeklyTrendSummary.fromEntries(entries);

    expect(summary.entries.length, 3);
    expect(summary.averageMood, closeTo(3, 0.001));
    expect(summary.averageEnergy, closeTo(2.333, 0.001));
  });
}
