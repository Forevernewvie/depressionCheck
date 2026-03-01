import 'package:vibemental_app/core/config/checkin_config.dart';
import 'package:vibemental_app/features/checkin/domain/daily_checkin_entry.dart';
import 'package:vibemental_app/features/checkin/domain/weekly_trend_summary.dart';

/// Purpose: Hold UI state for daily check-in and weekly trend.
class CheckInState {
  const CheckInState({
    this.mood = CheckInConfig.defaultScore,
    this.energy = CheckInConfig.defaultScore,
    this.note = '',
    this.entries = const [],
    this.isSaving = false,
    this.lastSaveSucceeded,
  });

  final int mood;
  final int energy;
  final String note;
  final List<DailyCheckInEntry> entries;
  final bool isSaving;
  final bool? lastSaveSucceeded;

  /// Purpose: Compute trend summary for rendering chart/list widgets.
  WeeklyTrendSummary get trend => WeeklyTrendSummary.fromEntries(entries);

  /// Purpose: Create immutable next state.
  CheckInState copyWith({
    int? mood,
    int? energy,
    String? note,
    List<DailyCheckInEntry>? entries,
    bool? isSaving,
    bool? lastSaveSucceeded,
    bool clearSaveResult = false,
  }) {
    return CheckInState(
      mood: mood ?? this.mood,
      energy: energy ?? this.energy,
      note: note ?? this.note,
      entries: entries ?? this.entries,
      isSaving: isSaving ?? this.isSaving,
      lastSaveSucceeded: clearSaveResult
          ? null
          : lastSaveSucceeded ?? this.lastSaveSucceeded,
    );
  }
}
