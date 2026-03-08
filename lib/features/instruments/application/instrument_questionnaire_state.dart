import 'package:vibemental_app/features/instruments/application/instrument_questionnaire_catalog.dart';

/// Purpose: Hold immutable questionnaire session state for one module
/// instrument flow.
class InstrumentQuestionnaireState {
  const InstrumentQuestionnaireState({
    required this.definition,
    required this.answers,
  });

  final InstrumentQuestionnaireDefinition definition;
  final List<int?> answers;

  /// Purpose: Tell the presentation layer whether all questions were answered.
  bool get isComplete => answers.every((value) => value != null);

  /// Purpose: Create immutable next questionnaire state.
  InstrumentQuestionnaireState copyWith({
    InstrumentQuestionnaireDefinition? definition,
    List<int?>? answers,
  }) {
    return InstrumentQuestionnaireState(
      definition: definition ?? this.definition,
      answers: answers ?? this.answers,
    );
  }
}
