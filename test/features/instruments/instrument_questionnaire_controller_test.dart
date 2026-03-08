import 'package:flutter_test/flutter_test.dart';
import 'package:vibemental_app/core/logging/app_logger.dart';
import 'package:vibemental_app/features/instruments/application/instrument_questionnaire_catalog.dart';
import 'package:vibemental_app/features/instruments/application/instrument_questionnaire_controller.dart';
import 'package:vibemental_app/features/screening/domain/screening_result.dart';

class _SilentLogger implements AppLogger {
  @override
  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?> context = const {},
  }) {}

  @override
  void info(String message, {Map<String, Object?> context = const {}}) {}

  @override
  void warn(String message, {Map<String, Object?> context = const {}}) {}
}

void main() {
  test('updateAnswer mutates only the targeted answer slot', () {
    final definition = InstrumentQuestionnaireCatalog.lookup(
      ScreeningInstrument.hadsD,
    )!;
    final controller = InstrumentQuestionnaireController(
      instrument: ScreeningInstrument.hadsD,
      definition: definition,
      questionCount: 3,
      logger: _SilentLogger(),
    );

    controller.updateAnswer(index: 1, value: 2);

    expect(controller.state.answers, <int?>[null, 2, null]);
    expect(controller.state.isComplete, isFalse);
  });

  test('submit returns null until every answer is complete', () {
    final definition = InstrumentQuestionnaireCatalog.lookup(
      ScreeningInstrument.hadsD,
    )!;
    final controller = InstrumentQuestionnaireController(
      instrument: ScreeningInstrument.hadsD,
      definition: definition,
      questionCount: 2,
      logger: _SilentLogger(),
    );

    controller.updateAnswer(index: 0, value: 1);

    expect(controller.submit(), isNull);
  });

  test('submit returns scored result when questionnaire is complete', () {
    final definition = InstrumentQuestionnaireCatalog.lookup(
      ScreeningInstrument.hadsD,
    )!;
    final controller = InstrumentQuestionnaireController(
      instrument: ScreeningInstrument.hadsD,
      definition: definition,
      questionCount: 7,
      logger: _SilentLogger(),
    );

    for (int index = 0; index < 7; index++) {
      controller.updateAnswer(index: index, value: 1);
    }

    final result = controller.submit();

    expect(result, isNotNull);
    expect(result!.instrument, ScreeningInstrument.hadsD);
    expect(result.totalScore, 7);
  });
}
