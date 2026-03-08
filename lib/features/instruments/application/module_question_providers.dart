import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibemental_app/core/logging/logging_providers.dart';
import 'package:vibemental_app/features/instruments/application/instrument_questionnaire_catalog.dart';
import 'package:vibemental_app/features/instruments/application/instrument_questionnaire_controller.dart';
import 'package:vibemental_app/features/instruments/application/instrument_questionnaire_state.dart';
import 'package:vibemental_app/features/instruments/application/module_question_content_service.dart';
import 'package:vibemental_app/features/instruments/domain/module_question_bank.dart';
import 'package:vibemental_app/features/screening/domain/screening_result.dart';

/// Purpose: Expose module-question content service through dependency injection.
final moduleQuestionContentServiceProvider =
    Provider<ModuleQuestionContentService>((ref) {
      return ModuleQuestionContentService(ref.watch(appLoggerProvider));
    });

/// Purpose: Provide questionnaire session state per module instrument without
/// storing mutable answer arrays inside the screen widget.
final instrumentQuestionnaireControllerProvider = StateNotifierProvider
    .autoDispose
    .family<
      InstrumentQuestionnaireController,
      InstrumentQuestionnaireState,
      ScreeningInstrument
    >((ref, instrument) {
      final definition = InstrumentQuestionnaireCatalog.lookup(instrument);
      final questionSet = ModuleQuestionBank.byInstrument(instrument);
      if (definition == null || questionSet == null) {
        throw ArgumentError('Unsupported instrument for module questionnaire.');
      }

      return InstrumentQuestionnaireController(
        instrument: instrument,
        definition: definition,
        questionCount: questionSet.expectedQuestionCount,
        logger: ref.watch(appLoggerProvider),
      );
    });
