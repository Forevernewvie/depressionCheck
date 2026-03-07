import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vibemental_app/core/config/app_routes.dart';
import 'package:vibemental_app/core/config/instrument_module_config.dart';
import 'package:vibemental_app/core/logging/logging_providers.dart';
import 'package:vibemental_app/features/common/widgets/likert_question_card.dart';
import 'package:vibemental_app/features/screening/domain/scoring.dart';
import 'package:vibemental_app/features/screening/domain/screening_result.dart';
import 'package:vibemental_app/l10n/app_localizations.dart';

class InstrumentQuestionnaireScreen extends ConsumerStatefulWidget {
  const InstrumentQuestionnaireScreen({required this.instrument, super.key});

  final ScreeningInstrument instrument;

  @override
  /// Purpose: Create mutable state for instrument questionnaire interactions.
  ConsumerState<InstrumentQuestionnaireScreen> createState() =>
      _InstrumentQuestionnaireScreenState();
}

class _InstrumentQuestionnaireScreenState
    extends ConsumerState<InstrumentQuestionnaireScreen> {
  late final List<int?> _answers;

  @override
  /// Purpose: Initialize answer slots based on selected instrument length.
  void initState() {
    super.initState();
    if (!_supportsInstrument(widget.instrument)) {
      throw ArgumentError('Unsupported instrument for module questionnaire.');
    }
    _answers = List<int?>.filled(
      _questionCountForInstrument(widget.instrument),
      null,
    );
  }

  @override
  /// Purpose: Render a reusable non-PHQ questionnaire for module instruments.
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final title = _titleForInstrument(l10n, widget.instrument);
    final intro = _introForInstrument(l10n, widget.instrument);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(InstrumentModuleConfig.screenPadding),
        children: [
          Text(intro, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: InstrumentModuleConfig.itemGap),
          for (int index = 0; index < _answers.length; index++)
            LikertQuestionCard(
              question: l10n.moduleQuestionLabel(title, index + 1),
              value: _answers[index],
              onChanged: (value) => setState(() => _answers[index] = value),
            ),
          if (widget.instrument == ScreeningInstrument.bdi2) ...[
            const SizedBox(height: InstrumentModuleConfig.itemGap),
            Text(
              l10n.moduleBdiInAppNotice,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          const SizedBox(height: InstrumentModuleConfig.sectionGap),
          FilledButton(
            onPressed: _onSubmit,
            child: Text(l10n.buttonViewResult),
          ),
          const SizedBox(height: InstrumentModuleConfig.itemGap),
          TextButton(
            onPressed: () => context.go(AppRoutes.modules),
            child: Text(l10n.moduleBackToModules),
          ),
        ],
      ),
    );
  }

  /// Purpose: Validate completion and route to shared result screen.
  void _onSubmit() {
    final l10n = AppLocalizations.of(context)!;
    final logger = ref.read(appLoggerProvider);
    if (_answers.any((item) => item == null)) {
      logger.warn(
        'instrument_submit_blocked_missing_answer',
        context: {'instrument': widget.instrument.name},
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.commonMissingAnswer)));
      return;
    }

    try {
      final result = _scoreForInstrument(
        widget.instrument,
        _answers.cast<int>(),
      );
      logger.info(
        'instrument_submit_success',
        context: {
          'instrument': widget.instrument.name,
          'totalScore': result.totalScore,
          'severity': result.severity.name,
        },
      );
      context.push(AppRoutes.result, extra: result);
    } on ArgumentError catch (error, stackTrace) {
      logger.error(
        'instrument_submit_failed_validation',
        error: error,
        stackTrace: stackTrace,
        context: {'instrument': widget.instrument.name},
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.commonMissingAnswer)));
    }
  }

  /// Purpose: Resolve localized instrument title for selected module.
  String _titleForInstrument(
    AppLocalizations l10n,
    ScreeningInstrument instrument,
  ) {
    switch (instrument) {
      case ScreeningInstrument.hadsD:
        return l10n.moduleHadsTitle;
      case ScreeningInstrument.cesD:
        return l10n.moduleCesdTitle;
      case ScreeningInstrument.bdi2:
        return l10n.moduleBdiTitle;
      case ScreeningInstrument.phq2:
      case ScreeningInstrument.phq9:
        throw ArgumentError('Unsupported instrument for module questionnaire.');
    }
  }

  /// Purpose: Resolve localized module introduction copy.
  String _introForInstrument(
    AppLocalizations l10n,
    ScreeningInstrument instrument,
  ) {
    switch (instrument) {
      case ScreeningInstrument.hadsD:
        return l10n.moduleHadsIntro;
      case ScreeningInstrument.cesD:
        return l10n.moduleCesdIntro;
      case ScreeningInstrument.bdi2:
        return l10n.moduleBdiIntro;
      case ScreeningInstrument.phq2:
      case ScreeningInstrument.phq9:
        throw ArgumentError('Unsupported instrument for module questionnaire.');
    }
  }

  /// Purpose: Return fixed question count by instrument to avoid magic numbers.
  int _questionCountForInstrument(ScreeningInstrument instrument) {
    switch (instrument) {
      case ScreeningInstrument.hadsD:
        return InstrumentModuleConfig.hadsDQuestionCount;
      case ScreeningInstrument.cesD:
        return InstrumentModuleConfig.cesDQuestionCount;
      case ScreeningInstrument.bdi2:
        return InstrumentModuleConfig.bdi2QuestionCount;
      case ScreeningInstrument.phq2:
      case ScreeningInstrument.phq9:
        throw ArgumentError('Unsupported instrument for module questionnaire.');
    }
  }

  /// Purpose: Dispatch selected instrument answers into its scoring function.
  ScreeningResult _scoreForInstrument(
    ScreeningInstrument instrument,
    List<int> answers,
  ) {
    switch (instrument) {
      case ScreeningInstrument.hadsD:
        return scoreHadsD(answers);
      case ScreeningInstrument.cesD:
        return scoreCesD(answers);
      case ScreeningInstrument.bdi2:
        return scoreBdi2(answers);
      case ScreeningInstrument.phq2:
      case ScreeningInstrument.phq9:
        throw ArgumentError('Unsupported instrument for this screen.');
    }
  }

  /// Purpose: Explicitly define which instruments this reusable screen accepts.
  bool _supportsInstrument(ScreeningInstrument instrument) {
    return instrument == ScreeningInstrument.hadsD ||
        instrument == ScreeningInstrument.cesD ||
        instrument == ScreeningInstrument.bdi2;
  }
}
