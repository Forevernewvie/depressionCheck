/// Purpose: Centralize limits and defaults for daily check-in and trend logic.
class CheckInConfig {
  CheckInConfig._();

  static const int scoreMin = 1;
  static const int scoreMax = 5;
  static const int defaultScore = 3;
  static const int weeklyTrendDays = 7;
  static const int maxNoteLength = 200;
  static const double trendBarMaxWidth = 88;
}
