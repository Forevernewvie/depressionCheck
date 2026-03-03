// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:html' as html;

import 'package:vibemental_app/core/config/web_storage_keys.dart';
import 'package:vibemental_app/core/logging/app_logger.dart';
import 'package:vibemental_app/features/checkin/data/checkin_repository.dart';
import 'package:vibemental_app/features/checkin/domain/checkin_validators.dart';
import 'package:vibemental_app/features/checkin/domain/daily_checkin_entry.dart';

/// Purpose: Store check-in entries in browser local storage for web builds.
class WebCheckInRepository implements CheckInRepository {
  WebCheckInRepository(this._logger);

  final AppLogger _logger;

  @override
  /// Purpose: Read check-ins for a trailing window sorted newest-first.
  List<DailyCheckInEntry> readRecentEntries({required int days}) {
    final from = DateTime.now().subtract(Duration(days: days));
    final values =
        _readPayload().values
            .map(_tryParseEntry)
            .whereType<DailyCheckInEntry>()
            .where((entry) => entry.createdAt.isAfter(from))
            .toList(growable: false)
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return values;
  }

  @override
  /// Purpose: Read one check-in entry by deterministic local date key.
  DailyCheckInEntry? readByDateKey(String localDateKey) {
    final raw = _readPayload()[localDateKey];
    return _tryParseEntry(raw);
  }

  @override
  /// Purpose: Upsert one day entry while validating score bounds and note text.
  void saveEntry({
    required String localDateKey,
    required int mood,
    required int energy,
    required DateTime now,
    String? note,
  }) {
    if (!isValidCheckInScore(mood) || !isValidCheckInScore(energy)) {
      _logger.warn(
        'Rejected invalid web check-in score.',
        context: {'mood': mood, 'energy': energy},
      );
      return;
    }

    final payload = _readPayload();
    payload[localDateKey] = <String, Object?>{
      _CheckInField.localDateKey: localDateKey,
      _CheckInField.mood: mood,
      _CheckInField.energy: energy,
      _CheckInField.createdAt: now.toIso8601String(),
      _CheckInField.note: note == null ? null : normalizeCheckInNote(note),
    };
    _writePayload(payload);
  }

  /// Purpose: Parse one serialized object into a domain check-in entry.
  DailyCheckInEntry? _tryParseEntry(Object? raw) {
    if (raw is! Map<String, dynamic>) {
      return null;
    }

    final key = raw[_CheckInField.localDateKey] as String?;
    final mood = raw[_CheckInField.mood] as int?;
    final energy = raw[_CheckInField.energy] as int?;
    final createdAtRaw = raw[_CheckInField.createdAt] as String?;
    final createdAt = createdAtRaw == null
        ? null
        : DateTime.tryParse(createdAtRaw);
    if (key == null || mood == null || energy == null || createdAt == null) {
      return null;
    }

    if (!isValidCheckInScore(mood) || !isValidCheckInScore(energy)) {
      return null;
    }

    return DailyCheckInEntry(
      localDateKey: key,
      mood: mood,
      energy: energy,
      createdAt: createdAt,
      note: raw[_CheckInField.note] as String?,
    );
  }

  /// Purpose: Read serialized check-in map from local storage safely.
  Map<String, Object?> _readPayload() {
    final raw = html.window.localStorage[WebStorageKeys.checkInEntries];
    if (raw == null || raw.isEmpty) {
      return <String, Object?>{};
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        return <String, Object?>{};
      }
      return decoded.map((key, value) => MapEntry<String, Object?>(key, value));
    } catch (error, stackTrace) {
      _logger.warn(
        'Failed to parse web check-in payload. Resetting payload.',
        context: {'error': error.toString()},
      );
      _logger.error(
        'Web check-in payload parse exception details.',
        error: error,
        stackTrace: stackTrace,
      );
      return <String, Object?>{};
    }
  }

  /// Purpose: Persist serialized check-in map in one local storage write.
  void _writePayload(Map<String, Object?> payload) {
    html.window.localStorage[WebStorageKeys.checkInEntries] = jsonEncode(
      payload,
    );
  }
}

/// Purpose: Centralize serialized field keys for check-in web persistence.
abstract final class _CheckInField {
  static const String localDateKey = 'local_date_key';
  static const String mood = 'mood';
  static const String energy = 'energy';
  static const String createdAt = 'created_at';
  static const String note = 'note';
}
