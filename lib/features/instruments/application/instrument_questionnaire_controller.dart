import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibemental_app/core/logging/app_logger.dart';
import 'package:vibemental_app/features/instruments/application/instrument_questionnaire_catalog.dart';
import 'package:vibemental_app/features/instruments/application/instrument_questionnaire_state.dart';
import 'package:vibemental_app/features/screening/domain/screening_result.dart';

/// Purpose: Coordinate answer updates and submission validation for one module
/// questionnaire session.
class InstrumentQuestionnaireController
    extends StateNotifier<InstrumentQuestionnaireState> {
  InstrumentQuestionnaireController({
    required ScreeningInstrument instrument,
    required InstrumentQuestionnaireDefinition definition,
    required int questionCount,
    required AppLogger logger,
  }) : _instrument = instrument,
       _logger = logger,
       super(
         InstrumentQuestionnaireState(
           definition: definition,
           answers: List<int?>.filled(questionCount, null),
         ),
       );

  final ScreeningInstrument _instrument;
  final AppLogger _logger;

  /// Purpose: Update one answer slot without mutating the full answer list.
  void updateAnswer({
    required int index,
    required int value,
  }) {
    final nextAnswers = List<int?>.from(state.answers);
    nextAnswers[index] = value;
    state = state.copyWith(answers: nextAnswers);
  }

  /// Purpose: Validate completion and compute the shared result payload.
  ScreeningResult? submit() {
    if (!state.isComplete) {
      _logger.warn(
        'instrument_submit_blocked_missing_answer',
        context: {'instrument': _instrument.name},
      );
      return null;
    }

    try {
      final result = state.definition.score(state.answers.cast<int>());
      _logger.info(
        'instrument_submit_success',
        context: {
          'instrument': _instrument.name,
          'totalScore': result.totalScore,
          'severity': result.severity.name,
        },
      );
      return result;
    } on ArgumentError catch (error, stackTrace) {
      _logger.error(
        'instrument_submit_failed_validation',
        error: error,
        stackTrace: stackTrace,
        context: {'instrument': _instrument.name},
      );
      return null;
    }
  }
}
