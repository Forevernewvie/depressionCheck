import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vibemental_app/core/config/app_routes.dart';
import 'package:vibemental_app/core/config/instrument_module_config.dart';
import 'package:vibemental_app/features/instruments/application/module_question_providers.dart';
import 'package:vibemental_app/features/common/widgets/likert_question_card.dart';
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
  @override
  /// Purpose: Render a reusable non-PHQ questionnaire for module instruments.
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(
      instrumentQuestionnaireControllerProvider(widget.instrument),
    );
    final controller = ref.read(
      instrumentQuestionnaireControllerProvider(widget.instrument).notifier,
    );
    final title = state.definition.title(l10n);
    final intro = state.definition.intro(l10n);
    final content = ref
        .watch(moduleQuestionContentServiceProvider)
        .resolve(
          instrument: widget.instrument,
          locale: Localizations.localeOf(context),
        );

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(InstrumentModuleConfig.screenPadding),
        children: [
          Text(intro, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: InstrumentModuleConfig.itemGap),
          for (int index = 0; index < state.answers.length; index++)
            LikertQuestionCard(
              question: content.questions[index],
              value: state.answers[index],
              optionLabels: content.optionLabels,
              onChanged: (value) =>
                  controller.updateAnswer(index: index, value: value),
            ),
          if (state.definition.notice != null) ...[
            const SizedBox(height: InstrumentModuleConfig.itemGap),
            Text(
              state.definition.notice!(l10n),
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
    final result = ref
        .read(
          instrumentQuestionnaireControllerProvider(widget.instrument).notifier,
        )
        .submit();
    if (result == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.commonMissingAnswer)));
      return;
    }

    context.push(AppRoutes.result, extra: result);
  }
}
