import 'package:vibemental_app/core/config/checkin_config.dart';

/// Purpose: Validate score input for daily check-in fields.
bool isValidCheckInScore(int value) {
  return value >= CheckInConfig.scoreMin && value <= CheckInConfig.scoreMax;
}

/// Purpose: Normalize free-form note for safe persistence.
String normalizeCheckInNote(String raw) {
  final trimmed = raw.trim();
  if (trimmed.length <= CheckInConfig.maxNoteLength) {
    return trimmed;
  }
  return trimmed.substring(0, CheckInConfig.maxNoteLength);
}
