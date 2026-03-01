/// Purpose: Hold scoring thresholds and validation ranges for all screening
/// instruments to avoid magic numbers in business logic.
class ScreeningThresholds {
  ScreeningThresholds._();

  static const int likertMin = 0;
  static const int likertMax = 3;

  static const int phq2EscalationStart = 3;

  static const int phq9NormalMax = 4;
  static const int phq9MildMax = 9;
  static const int phq9ModerateMax = 14;
  static const int phq9HighRiskStart = 15;

  static const int hadsDNormalMax = 7;
  static const int hadsDMildMax = 10;
  static const int hadsDModerateMax = 14;

  static const int cesDNormalMax = 15;
  static const int cesDMidMax = 23;

  static const int bdi2NormalMax = 13;
  static const int bdi2MildMax = 19;
  static const int bdi2ModerateMax = 28;
}
