import 'package:flutter_test/flutter_test.dart';
import 'package:vibemental_app/features/screening/domain/scoring.dart';
import 'package:vibemental_app/features/screening/domain/severity.dart';

void main() {
  group('PHQ-2 score boundaries', () {
    test('score 2 stays in stage 1', () {
      final result = scorePhq2(q1: 1, q2: 1);
      expect(result.totalScore, 2);
      expect(result.shouldEscalateToStage2, isFalse);
      expect(result.severity, SeverityLevel.normal);
    });

    test('score 3 escalates to stage 2', () {
      final result = scorePhq2(q1: 2, q2: 1);
      expect(result.totalScore, 3);
      expect(result.shouldEscalateToStage2, isTrue);
      expect(result.severity, SeverityLevel.mild);
    });
  });

  group('PHQ-9 score boundaries', () {
    test('9 is mild', () {
      final result = scorePhq9([2, 1, 1, 1, 1, 1, 1, 1, 0]);
      expect(result.totalScore, 9);
      expect(result.severity, SeverityLevel.mild);
      expect(result.urgentCare, isFalse);
    });

    test('10 is moderate', () {
      final result = scorePhq9([2, 2, 1, 1, 1, 1, 1, 1, 0]);
      expect(result.totalScore, 10);
      expect(result.severity, SeverityLevel.moderate);
      expect(result.urgentCare, isFalse);
    });

    test('15 is high-risk', () {
      final result = scorePhq9([2, 2, 2, 2, 2, 2, 2, 1, 0]);
      expect(result.totalScore, 15);
      expect(result.severity, SeverityLevel.highRisk);
      expect(result.urgentCare, isTrue);
    });

    test('self-harm item overrides to urgent path', () {
      final result = scorePhq9([0, 0, 0, 0, 0, 0, 0, 0, 1]);
      expect(result.totalScore, 1);
      expect(result.selfHarmPositive, isTrue);
      expect(result.severity, SeverityLevel.highRisk);
      expect(result.urgentCare, isTrue);
    });
  });

  group('Other instrument bands', () {
    test('HADS-D boundaries', () {
      expect(severityFromHadsD(7), SeverityLevel.normal);
      expect(severityFromHadsD(8), SeverityLevel.mild);
      expect(severityFromHadsD(11), SeverityLevel.moderate);
      expect(severityFromHadsD(15), SeverityLevel.highRisk);
    });

    test('CES-D boundaries', () {
      expect(severityFromCesD(15), SeverityLevel.normal);
      expect(severityFromCesD(16), SeverityLevel.moderate);
      expect(severityFromCesD(24), SeverityLevel.highRisk);
    });
  });
}
