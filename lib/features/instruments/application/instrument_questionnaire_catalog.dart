import 'package:vibemental_app/features/screening/domain/scoring.dart';
import 'package:vibemental_app/features/screening/domain/screening_result.dart';
import 'package:vibemental_app/l10n/app_localizations.dart';

typedef QuestionnaireTextResolver = String Function(AppLocalizations l10n);
typedef QuestionnaireScoreResolver = ScreeningResult Function(List<int> answers);

/// Purpose: Describe one supported module questionnaire without scattering
/// presentation and scoring rules across the screen widget.
class InstrumentQuestionnaireDefinition {
  const InstrumentQuestionnaireDefinition({
    required this.instrument,
    required this.title,
    required this.intro,
    required this.score,
    this.notice,
  });

  final ScreeningInstrument instrument;
  final QuestionnaireTextResolver title;
  final QuestionnaireTextResolver intro;
  final QuestionnaireTextResolver? notice;
  final QuestionnaireScoreResolver score;
}

/// Purpose: Provide a single lookup point for supported module questionnaires.
class InstrumentQuestionnaireCatalog {
  InstrumentQuestionnaireCatalog._();

  static const Map<ScreeningInstrument, InstrumentQuestionnaireDefinition>
  _definitions = {
    ScreeningInstrument.hadsD: InstrumentQuestionnaireDefinition(
      instrument: ScreeningInstrument.hadsD,
      title: _moduleHadsTitle,
      intro: _moduleHadsIntro,
      score: scoreHadsD,
    ),
    ScreeningInstrument.cesD: InstrumentQuestionnaireDefinition(
      instrument: ScreeningInstrument.cesD,
      title: _moduleCesdTitle,
      intro: _moduleCesdIntro,
      score: scoreCesD,
    ),
    ScreeningInstrument.bdi2: InstrumentQuestionnaireDefinition(
      instrument: ScreeningInstrument.bdi2,
      title: _moduleBdiTitle,
      intro: _moduleBdiIntro,
      notice: _moduleBdiNotice,
      score: scoreBdi2,
    ),
  };

  /// Purpose: Resolve the questionnaire definition for one supported instrument.
  static InstrumentQuestionnaireDefinition? lookup(
    ScreeningInstrument instrument,
  ) {
    return _definitions[instrument];
  }

  /// Purpose: Expose supported instruments for tests and defensive checks.
  static List<ScreeningInstrument> supportedInstruments() {
    return _definitions.keys.toList(growable: false);
  }

  /// Purpose: Read localized HADS-D title text.
  static String _moduleHadsTitle(AppLocalizations l10n) {
    return l10n.moduleHadsTitle;
  }

  /// Purpose: Read localized HADS-D intro text.
  static String _moduleHadsIntro(AppLocalizations l10n) {
    return l10n.moduleHadsIntro;
  }

  /// Purpose: Read localized CES-D title text.
  static String _moduleCesdTitle(AppLocalizations l10n) {
    return l10n.moduleCesdTitle;
  }

  /// Purpose: Read localized CES-D intro text.
  static String _moduleCesdIntro(AppLocalizations l10n) {
    return l10n.moduleCesdIntro;
  }

  /// Purpose: Read localized BDI-II title text.
  static String _moduleBdiTitle(AppLocalizations l10n) {
    return l10n.moduleBdiTitle;
  }

  /// Purpose: Read localized BDI-II intro text.
  static String _moduleBdiIntro(AppLocalizations l10n) {
    return l10n.moduleBdiIntro;
  }

  /// Purpose: Read localized BDI-II in-app licensing notice.
  static String _moduleBdiNotice(AppLocalizations l10n) {
    return l10n.moduleBdiInAppNotice;
  }
}
