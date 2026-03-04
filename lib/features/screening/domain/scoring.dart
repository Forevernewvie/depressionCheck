import 'package:vibemental_app/core/config/screening_thresholds.dart';
import 'package:vibemental_app/core/config/instrument_module_config.dart';
import 'package:vibemental_app/features/screening/domain/screening_result.dart';
import 'package:vibemental_app/features/screening/domain/severity.dart';

/// Purpose: Score PHQ-2 answers and determine stage-2 escalation.
ScreeningResult scorePhq2({required int q1, required int q2}) {
  _validateLikertValue(q1, question: 'PHQ-2 Q1');
  _validateLikertValue(q2, question: 'PHQ-2 Q2');

  final total = q1 + q2;
  final shouldEscalate = total >= ScreeningThresholds.phq2EscalationStart;

  return ScreeningResult(
    instrument: ScreeningInstrument.phq2,
    totalScore: total,
    severity: shouldEscalate ? SeverityLevel.mild : SeverityLevel.normal,
    shouldEscalateToStage2: shouldEscalate,
  );
}

/// Purpose: Score PHQ-9 answers with self-harm override for urgent care flow.
ScreeningResult scorePhq9(List<int> answers) {
  if (answers.length != 9) {
    throw ArgumentError('PHQ-9 requires exactly 9 answers.');
  }

  for (int i = 0; i < answers.length; i++) {
    _validateLikertValue(answers[i], question: 'PHQ-9 Q${i + 1}');
  }

  final total = answers.fold<int>(0, (sum, value) => sum + value);
  final selfHarmPositive = answers[8] > 0;
  final urgentCare =
      selfHarmPositive || total >= ScreeningThresholds.phq9HighRiskStart;

  final SeverityLevel severity;
  if (urgentCare) {
    severity = SeverityLevel.highRisk;
  } else if (total <= ScreeningThresholds.phq9NormalMax) {
    severity = SeverityLevel.normal;
  } else if (total <= ScreeningThresholds.phq9MildMax) {
    severity = SeverityLevel.mild;
  } else if (total <= ScreeningThresholds.phq9ModerateMax) {
    severity = SeverityLevel.moderate;
  } else {
    severity = SeverityLevel.highRisk;
  }

  return ScreeningResult(
    instrument: ScreeningInstrument.phq9,
    totalScore: total,
    severity: severity,
    selfHarmPositive: selfHarmPositive,
    urgentCare: urgentCare,
  );
}

/// Purpose: Score HADS-D responses and map total score to severity.
ScreeningResult scoreHadsD(List<int> answers) {
  if (answers.length != InstrumentModuleConfig.hadsDQuestionCount) {
    throw ArgumentError(
      'HADS-D requires exactly ${InstrumentModuleConfig.hadsDQuestionCount} answers.',
    );
  }

  for (int i = 0; i < answers.length; i++) {
    _validateLikertValue(answers[i], question: 'HADS-D Q${i + 1}');
  }

  final total = answers.fold<int>(0, (sum, value) => sum + value);
  final severity = severityFromHadsD(total);
  return ScreeningResult(
    instrument: ScreeningInstrument.hadsD,
    totalScore: total,
    severity: severity,
    urgentCare: severity == SeverityLevel.highRisk,
  );
}

/// Purpose: Score CES-D responses and map total score to severity.
ScreeningResult scoreCesD(List<int> answers) {
  if (answers.length != InstrumentModuleConfig.cesDQuestionCount) {
    throw ArgumentError(
      'CES-D requires exactly ${InstrumentModuleConfig.cesDQuestionCount} answers.',
    );
  }

  for (int i = 0; i < answers.length; i++) {
    _validateLikertValue(answers[i], question: 'CES-D Q${i + 1}');
  }

  final total = answers.fold<int>(0, (sum, value) => sum + value);
  final severity = severityFromCesD(total);
  return ScreeningResult(
    instrument: ScreeningInstrument.cesD,
    totalScore: total,
    severity: severity,
    urgentCare: severity == SeverityLevel.highRisk,
  );
}

/// Purpose: Score BDI-II responses and map total score to severity.
ScreeningResult scoreBdi2(List<int> answers) {
  if (answers.length != InstrumentModuleConfig.bdi2QuestionCount) {
    throw ArgumentError(
      'BDI-II requires exactly ${InstrumentModuleConfig.bdi2QuestionCount} answers.',
    );
  }

  for (int i = 0; i < answers.length; i++) {
    _validateLikertValue(answers[i], question: 'BDI-II Q${i + 1}');
  }

  final total = answers.fold<int>(0, (sum, value) => sum + value);
  final severity = severityFromBdi2(total);
  return ScreeningResult(
    instrument: ScreeningInstrument.bdi2,
    totalScore: total,
    severity: severity,
    urgentCare: severity == SeverityLevel.highRisk,
  );
}

/// Purpose: Map HADS-D score to severity levels.
SeverityLevel severityFromHadsD(int total) {
  if (total <= ScreeningThresholds.hadsDNormalMax) {
    return SeverityLevel.normal;
  }
  if (total <= ScreeningThresholds.hadsDMildMax) {
    return SeverityLevel.mild;
  }
  if (total <= ScreeningThresholds.hadsDModerateMax) {
    return SeverityLevel.moderate;
  }
  return SeverityLevel.highRisk;
}

/// Purpose: Map CES-D score to severity levels.
SeverityLevel severityFromCesD(int total) {
  if (total <= ScreeningThresholds.cesDNormalMax) {
    return SeverityLevel.normal;
  }
  if (total <= ScreeningThresholds.cesDMidMax) {
    return SeverityLevel.moderate;
  }
  return SeverityLevel.highRisk;
}

/// Purpose: Map BDI-II score to severity levels.
SeverityLevel severityFromBdi2(int total) {
  if (total <= ScreeningThresholds.bdi2NormalMax) {
    return SeverityLevel.normal;
  }
  if (total <= ScreeningThresholds.bdi2MildMax) {
    return SeverityLevel.mild;
  }
  if (total <= ScreeningThresholds.bdi2ModerateMax) {
    return SeverityLevel.moderate;
  }
  return SeverityLevel.highRisk;
}

/// Purpose: Ensure each Likert answer falls within the validated scale range.
void _validateLikertValue(int value, {required String question}) {
  if (value < ScreeningThresholds.likertMin ||
      value > ScreeningThresholds.likertMax) {
    throw ArgumentError('$question must be between 0 and 3.');
  }
}
