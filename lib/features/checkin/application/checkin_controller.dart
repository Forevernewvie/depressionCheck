import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibemental_app/core/config/checkin_config.dart';
import 'package:vibemental_app/core/logging/app_logger.dart';
import 'package:vibemental_app/features/checkin/application/checkin_state.dart';
import 'package:vibemental_app/features/checkin/data/checkin_repository.dart';
import 'package:vibemental_app/features/checkin/domain/checkin_date_key.dart';
import 'package:vibemental_app/features/checkin/domain/checkin_validators.dart';

/// Purpose: Manage daily check-in input and weekly trend state transitions.
class CheckInController extends StateNotifier<CheckInState> {
  CheckInController(this._repository, this._logger)
    : super(const CheckInState()) {
    _restore();
  }

  final CheckInRepository _repository;
  final AppLogger _logger;

  /// Purpose: Restore today's check-in and weekly entries from local storage.
  void _restore() {
    final todayKey = buildLocalDateKey(DateTime.now());
    final today = _repository.readByDateKey(todayKey);
    final recent = _repository.readRecentEntries(
      days: CheckInConfig.weeklyTrendDays,
    );

    state = state.copyWith(
      mood: today?.mood,
      energy: today?.energy,
      note: today?.note ?? '',
      entries: recent,
      clearSaveResult: true,
    );
  }

  /// Purpose: Update mood score in state with defensive validation.
  void updateMood(int value) {
    if (!isValidCheckInScore(value)) {
      return;
    }
    state = state.copyWith(mood: value, clearSaveResult: true);
  }

  /// Purpose: Update energy score in state with defensive validation.
  void updateEnergy(int value) {
    if (!isValidCheckInScore(value)) {
      return;
    }
    state = state.copyWith(energy: value, clearSaveResult: true);
  }

  /// Purpose: Update note text while normalizing length and spacing.
  void updateNote(String raw) {
    state = state.copyWith(
      note: normalizeCheckInNote(raw),
      clearSaveResult: true,
    );
  }

  /// Purpose: Persist today's check-in and refresh weekly trend entries.
  Future<bool> saveToday() async {
    if (!isValidCheckInScore(state.mood) ||
        !isValidCheckInScore(state.energy)) {
      state = state.copyWith(lastSaveSucceeded: false);
      return false;
    }

    state = state.copyWith(isSaving: true, clearSaveResult: true);

    try {
      final now = DateTime.now();
      _repository.saveEntry(
        localDateKey: buildLocalDateKey(now),
        mood: state.mood,
        energy: state.energy,
        note: normalizeCheckInNote(state.note),
        now: now,
      );

      final recent = _repository.readRecentEntries(
        days: CheckInConfig.weeklyTrendDays,
      );
      state = state.copyWith(
        isSaving: false,
        entries: recent,
        lastSaveSucceeded: true,
      );
      _logger.info(
        'Daily check-in saved.',
        context: {'entries': recent.length},
      );
      return true;
    } catch (error, stackTrace) {
      _logger.error(
        'Failed to save daily check-in.',
        error: error,
        stackTrace: stackTrace,
      );
      state = state.copyWith(isSaving: false, lastSaveSucceeded: false);
      return false;
    }
  }
}
