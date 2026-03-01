import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vibemental_app/core/config/app_routes.dart';
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
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
          Text(l10n.phq9Intro, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 8),
          for (int i = 0; i < questions.length; i++)
            LikertQuestionCard(
              question: questions[i],
              value: _answers[i],
              onChanged: (value) => setState(() => _answers[i] = value),
            ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _onSubmit,
            child: Text(l10n.buttonViewResult),
          ),
        ],
      ),
    );
  }

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
    context.go(AppRoutes.result, extra: result);
  }
}
