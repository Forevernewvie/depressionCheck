import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vibemental_app/core/config/app_routes.dart';
import 'package:vibemental_app/core/config/instrument_module_config.dart';
import 'package:vibemental_app/features/common/widgets/likert_question_card.dart';
import 'package:vibemental_app/features/common/widgets/page_content_container.dart';
import 'package:vibemental_app/features/screening/domain/scoring.dart';
import 'package:vibemental_app/features/screening/domain/screening_result.dart';
import 'package:vibemental_app/l10n/app_localizations.dart';

class InstrumentQuestionnaireScreen extends StatefulWidget {
  const InstrumentQuestionnaireScreen({required this.instrument, super.key});

  final ScreeningInstrument instrument;

  @override
  State<InstrumentQuestionnaireScreen> createState() =>
      _InstrumentQuestionnaireScreenState();
}

class _InstrumentQuestionnaireScreenState
    extends State<InstrumentQuestionnaireScreen> {
  late final List<int?> _answers = List<int?>.filled(_questionCount, null);

  int get _questionCount {
    switch (widget.instrument) {
      case ScreeningInstrument.hadsD:
        return InstrumentModuleConfig.hadsDQuestionCount;
      case ScreeningInstrument.cesD:
        return InstrumentModuleConfig.cesDQuestionCount;
      case ScreeningInstrument.bdi2:
        return InstrumentModuleConfig.bdi2QuestionCount;
      case ScreeningInstrument.phq2:
      case ScreeningInstrument.phq9:
        throw UnimplementedError('PHQ routes should use dedicated screens.');
    }
  }

  @override
  /// Purpose: Render generic questionnaire flow for non-PHQ instruments.
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final moduleTitle = _moduleTitle(l10n, widget.instrument);
    final moduleIntro = _moduleIntro(l10n, widget.instrument);

    return Scaffold(
      appBar: AppBar(title: Text(moduleTitle)),
      body: PageContentContainer(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(moduleIntro, style: Theme.of(context).textTheme.bodyLarge),
            if (widget.instrument == ScreeningInstrument.bdi2) ...[
              const SizedBox(height: 8),
              Text(
                l10n.moduleBdiInAppNotice,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            const SizedBox(height: 8),
            for (int i = 0; i < _answers.length; i++)
              LikertQuestionCard(
                question: l10n.moduleQuestionLabel(moduleTitle, i + 1),
                value: _answers[i],
                onChanged: (value) => setState(() => _answers[i] = value),
              ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _onSubmit,
              child: Text(l10n.buttonViewResult),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.go(AppRoutes.modules),
              child: Text(l10n.moduleBackToModules),
            ),
          ],
        ),
      ),
    );
  }

  /// Purpose: Validate responses and navigate to shared result screen.
  void _onSubmit() {
    final l10n = AppLocalizations.of(context)!;
    if (_answers.any((item) => item == null)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.commonMissingAnswer)));
      return;
    }

    final resolvedAnswers = _answers.cast<int>();
    final result = _scoreByInstrument(resolvedAnswers);
    context.go(AppRoutes.result, extra: result);
  }

  /// Purpose: Dispatch score calculation by selected instrument safely.
  ScreeningResult _scoreByInstrument(List<int> answers) {
    switch (widget.instrument) {
      case ScreeningInstrument.hadsD:
        return scoreHadsD(answers);
      case ScreeningInstrument.cesD:
        return scoreCesD(answers);
      case ScreeningInstrument.bdi2:
        return scoreBdi2(answers);
      case ScreeningInstrument.phq2:
      case ScreeningInstrument.phq9:
        throw UnimplementedError('PHQ routes should use dedicated screens.');
    }
  }

  /// Purpose: Resolve module title from localization keys.
  String _moduleTitle(AppLocalizations l10n, ScreeningInstrument instrument) {
    switch (instrument) {
      case ScreeningInstrument.hadsD:
        return l10n.moduleHadsTitle;
      case ScreeningInstrument.cesD:
        return l10n.moduleCesdTitle;
      case ScreeningInstrument.bdi2:
        return l10n.moduleBdiTitle;
      case ScreeningInstrument.phq2:
      case ScreeningInstrument.phq9:
        throw UnimplementedError('PHQ routes should use dedicated screens.');
    }
  }

  /// Purpose: Resolve module intro guidance from localization keys.
  String _moduleIntro(AppLocalizations l10n, ScreeningInstrument instrument) {
    switch (instrument) {
      case ScreeningInstrument.hadsD:
        return l10n.moduleHadsIntro;
      case ScreeningInstrument.cesD:
        return l10n.moduleCesdIntro;
      case ScreeningInstrument.bdi2:
        return l10n.moduleBdiIntro;
      case ScreeningInstrument.phq2:
      case ScreeningInstrument.phq9:
        throw UnimplementedError('PHQ routes should use dedicated screens.');
    }
  }
}
