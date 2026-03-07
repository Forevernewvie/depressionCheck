import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vibemental_app/core/config/app_routes.dart';
import 'package:vibemental_app/features/common/widgets/flow_header_card.dart';
import 'package:vibemental_app/features/common/widgets/likert_question_card.dart';
import 'package:vibemental_app/features/screening/domain/scoring.dart';
import 'package:vibemental_app/l10n/app_localizations.dart';

class Phq2Screen extends StatefulWidget {
  const Phq2Screen({super.key});

  @override
  State<Phq2Screen> createState() => _Phq2ScreenState();
}

class _Phq2ScreenState extends State<Phq2Screen> {
  final List<int?> _answers = [null, null];

  @override
  /// Purpose: Render stage-1 screening questionnaire with clear flow guidance.
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final answeredCount = _answers.where((item) => item != null).length;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.phq2Title)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          FlowHeaderCard(
            title: l10n.phq2FlowTitle,
            stepLabel: l10n.phq2FlowStepLabel,
            estimateLabel: l10n.phq2FlowEstimate,
            description: l10n.phq2FlowDescription,
          ),
          _ProgressSummaryCard(
            answeredCount: answeredCount,
            totalCount: _answers.length,
          ),
          LikertQuestionCard(
            question: l10n.phq2Question1,
            value: _answers[0],
            onChanged: (value) => setState(() => _answers[0] = value),
          ),
          LikertQuestionCard(
            question: l10n.phq2Question2,
            value: _answers[1],
            onChanged: (value) => setState(() => _answers[1] = value),
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

  /// Purpose: Validate answers and route to stage-2 or result screen.
  void _onSubmit() {
    final l10n = AppLocalizations.of(context)!;
    if (_answers.any((item) => item == null)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.commonMissingAnswer)));
      return;
    }

    final result = scorePhq2(q1: _answers[0]!, q2: _answers[1]!);
    if (result.shouldEscalateToStage2) {
      context.push(AppRoutes.phq9);
      return;
    }

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
