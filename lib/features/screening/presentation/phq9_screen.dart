import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vibemental_app/core/config/app_routes.dart';
import 'package:vibemental_app/features/common/widgets/flow_header_card.dart';
import 'package:vibemental_app/features/common/widgets/likert_question_card.dart';
import 'package:vibemental_app/features/screening/domain/scoring.dart';
import 'package:vibemental_app/l10n/app_localizations.dart';

class Phq9Screen extends StatefulWidget {
  const Phq9Screen({super.key});

  @override
  State<Phq9Screen> createState() => _Phq9ScreenState();
}

class _Phq9ScreenState extends State<Phq9Screen> {
  final List<int?> _answers = List<int?>.filled(9, null);

  @override
  /// Purpose: Render stage-2 screening questionnaire with clear flow guidance.
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final answeredCount = _answers.where((item) => item != null).length;
    final questions = [
      l10n.phq9Question1,
      l10n.phq9Question2,
      l10n.phq9Question3,
      l10n.phq9Question4,
      l10n.phq9Question5,
      l10n.phq9Question6,
      l10n.phq9Question7,
      l10n.phq9Question8,
      l10n.phq9Question9,
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.phq9Title)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          FlowHeaderCard(
            title: l10n.phq9FlowTitle,
            stepLabel: l10n.phq9FlowStepLabel,
            estimateLabel: l10n.phq9FlowEstimate,
            description: l10n.phq9FlowDescription,
          ),
          _ProgressSummaryCard(
            answeredCount: answeredCount,
            totalCount: _answers.length,
          ),
          const SizedBox(height: 8),
          Text(l10n.phq9Intro, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 8),
          for (int i = 0; i < questions.length; i++)
            LikertQuestionCard(
              question: questions[i],
              value: _answers[i],
              onChanged: (value) => setState(() => _answers[i] = value),
            ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _allAnswered ? _onSubmit : null,
            icon: const Icon(Icons.arrow_forward_rounded),
            label: Text(l10n.buttonViewResult),
          ),
        ],
      ),
    );
  }

  /// Purpose: Expose whether the screen can safely advance with complete
  /// answers only.
  bool get _allAnswered => _answers.every((item) => item != null);

  /// Purpose: Validate stage-2 answers, compute score, and navigate to result.
  void _onSubmit() {
    final l10n = AppLocalizations.of(context)!;
    if (_answers.any((item) => item == null)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.commonMissingAnswer)));
      return;
    }

    final result = scorePhq9(_answers.cast<int>());
    context.push(AppRoutes.result, extra: result);
  }
}

class _ProgressSummaryCard extends StatelessWidget {
  const _ProgressSummaryCard({
    required this.answeredCount,
    required this.totalCount,
  });

  final int answeredCount;
  final int totalCount;

  @override
  /// Purpose: Show screening completion progress before the submit CTA so users
  /// understand why advancement may still be disabled.
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final progress = totalCount == 0 ? 0.0 : answeredCount / totalCount;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$answeredCount/$totalCount',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 10,
              value: progress,
              backgroundColor: colorScheme.surfaceContainerLow,
            ),
          ),
        ],
      ),
    );
  }
}
