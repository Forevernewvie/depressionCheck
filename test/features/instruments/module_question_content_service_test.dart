import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:vibemental_app/core/config/instrument_module_config.dart';
import 'package:vibemental_app/core/config/screening_thresholds.dart';
import 'package:vibemental_app/features/instruments/application/module_question_content_service.dart';
import 'package:vibemental_app/features/screening/domain/screening_result.dart';

import '../../fakes/test_app_logger.dart';

void main() {
  late TestAppLogger logger;
  late ModuleQuestionContentService service;

  setUp(() {
    logger = TestAppLogger();
    service = ModuleQuestionContentService(logger);
  });

  group('ModuleQuestionContentService question banks', () {
    test('HADS-D returns non-empty ko/en content with valid count', () {
      _expectValidContent(
        service: service,
        instrument: ScreeningInstrument.hadsD,
        expectedCount: InstrumentModuleConfig.hadsDQuestionCount,
      );
    });

    test('CES-D returns non-empty ko/en content with valid count', () {
      _expectValidContent(
        service: service,
        instrument: ScreeningInstrument.cesD,
        expectedCount: InstrumentModuleConfig.cesDQuestionCount,
      );
    });

    test('BDI-II returns non-empty ko/en content with valid count', () {
      _expectValidContent(
        service: service,
        instrument: ScreeningInstrument.bdi2,
        expectedCount: InstrumentModuleConfig.bdi2QuestionCount,
      );
    });

    test('unsupported locale falls back safely to english content', () {
      final content = service.resolve(
        instrument: ScreeningInstrument.hadsD,
        locale: const Locale('ja'),
      );

      expect(
        content.questions.length,
        InstrumentModuleConfig.hadsDQuestionCount,
      );
      expect(content.questions.first.trim(), isNotEmpty);
      expect(content.optionLabels[0], isNotNull);
      expect(content.optionLabels[0]!.trim(), isNotEmpty);
      expect(logger.errors, isEmpty);
    });
  });
}

/// Purpose: Verify module content has expected question count and complete option labels.
void _expectValidContent({
  required ModuleQuestionContentService service,
  required ScreeningInstrument instrument,
  required int expectedCount,
}) {
  for (final locale in const [Locale('ko'), Locale('en')]) {
    final content = service.resolve(instrument: instrument, locale: locale);
    expect(content.questions.length, expectedCount);
    expect(
      content.questions.every((question) => question.trim().isNotEmpty),
      isTrue,
    );

    for (
      int value = ScreeningThresholds.likertMin;
      value <= ScreeningThresholds.likertMax;
      value++
    ) {
      final label = content.optionLabels[value];
      expect(label, isNotNull);
      expect(label!.trim(), isNotEmpty);
    }
  }
}
