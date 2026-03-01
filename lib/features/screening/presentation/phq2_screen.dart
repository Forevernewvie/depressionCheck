import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vibemental_app/core/config/app_routes.dart';
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
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.phq2Title)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
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
          FilledButton(
            onPressed: _onSubmit,
            child: Text(l10n.buttonViewResult),
          ),
        ],
      ),
    );
  }

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
      context.go(AppRoutes.phq9);
      return;
    }

    context.go(AppRoutes.result, extra: result);
  }
}
