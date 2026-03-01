import 'package:vibemental_app/features/screening/domain/severity.dart';

enum ScreeningInstrument { phq2, phq9, hadsD, cesD, bdi2 }

class ScreeningResult {
  const ScreeningResult({
    required this.instrument,
    required this.totalScore,
    required this.severity,
    this.selfHarmPositive = false,
    this.urgentCare = false,
    this.shouldEscalateToStage2 = false,
  });

  final ScreeningInstrument instrument;
  final int totalScore;
  final SeverityLevel severity;
  final bool selfHarmPositive;
  final bool urgentCare;
  final bool shouldEscalateToStage2;

  factory ScreeningResult.fallback() {
    return const ScreeningResult(
      instrument: ScreeningInstrument.phq2,
      totalScore: 0,
      severity: SeverityLevel.normal,
    );
  }
}
