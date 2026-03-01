import 'package:isar/isar.dart';
import 'package:vibemental_app/core/logging/app_logger.dart';
import 'package:vibemental_app/features/checkin/data/checkin_repository.dart';
import 'package:vibemental_app/features/checkin/data/daily_checkin_record.dart';
import 'package:vibemental_app/features/checkin/domain/daily_checkin_entry.dart';
import 'package:vibemental_app/features/checkin/domain/checkin_validators.dart';

/// Purpose: Persist and query daily check-ins using Isar.
class IsarCheckInRepository implements CheckInRepository {
  IsarCheckInRepository(this._isar, this._logger);

  final Isar _isar;
  final AppLogger _logger;

  @override
  List<DailyCheckInEntry> readRecentEntries({required int days}) {
    final from = DateTime.now().subtract(Duration(days: days));
    final records = _isar.dailyCheckInRecords
        .where()
        .createdAtGreaterThan(from)
        .sortByCreatedAtDesc()
        .findAllSync();
    return records.map(_toDomain).toList(growable: false);
  }

  @override
  DailyCheckInEntry? readByDateKey(String localDateKey) {
    final record = _isar.dailyCheckInRecords
        .where()
        .localDateKeyEqualTo(localDateKey)
        .findFirstSync();
    return record == null ? null : _toDomain(record);
  }

  @override
  void saveEntry({
    required String localDateKey,
    required int mood,
    required int energy,
    required DateTime now,
    String? note,
  }) {
    if (!isValidCheckInScore(mood) || !isValidCheckInScore(energy)) {
      _logger.warn(
        'Rejected invalid check-in score.',
        context: {'mood': mood, 'energy': energy},
      );
      return;
    }

    final existing = _isar.dailyCheckInRecords
        .where()
        .localDateKeyEqualTo(localDateKey)
        .findFirstSync();

    final record = existing ?? DailyCheckInRecord()
      ..localDateKey = localDateKey;
    record.mood = mood;
    record.energy = energy;
    record.note = note;
    record.createdAt = now;

    _isar.writeTxnSync(() {
      _isar.dailyCheckInRecords.putSync(record);
    });
  }

  /// Purpose: Map persistence entity to domain model.
  DailyCheckInEntry _toDomain(DailyCheckInRecord record) {
    return DailyCheckInEntry(
      localDateKey: record.localDateKey,
      mood: record.mood,
      energy: record.energy,
      createdAt: record.createdAt,
      note: record.note,
    );
  }
}
