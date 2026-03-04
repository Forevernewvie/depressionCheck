import 'package:flutter/material.dart';
import 'package:vibemental_app/core/config/screening_thresholds.dart';
import 'package:vibemental_app/l10n/app_localizations.dart';

class LikertQuestionCard extends StatelessWidget {
  const LikertQuestionCard({
    required this.question,
    required this.value,
    required this.onChanged,
    this.optionLabels,
    super.key,
  });

  final String question;
  final int? value;
  final ValueChanged<int> onChanged;
  final Map<int, String>? optionLabels;

  @override
  /// Purpose: Render a selectable Likert question card with safe label fallback.
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final options = _resolveOptions(l10n);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: options.entries.map((entry) {
                final selected = value == entry.key;
                return ChoiceChip(
                  selected: selected,
                  label: Text('${entry.key}  ${entry.value}'),
                  onSelected: (_) => onChanged(entry.key),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  /// Purpose: Return a complete options map and fallback if caller data is invalid.
  Map<int, String> _resolveOptions(AppLocalizations l10n) {
    final fallback = <int, String>{
      0: l10n.answer0,
      1: l10n.answer1,
      2: l10n.answer2,
      3: l10n.answer3,
    };

    if (optionLabels == null) {
      return fallback;
    }

    for (
      int value = ScreeningThresholds.likertMin;
      value <= ScreeningThresholds.likertMax;
      value++
    ) {
      final label = optionLabels![value];
      if (label == null || label.trim().isEmpty) {
        return fallback;
      }
    }

    return optionLabels!;
  }
}
