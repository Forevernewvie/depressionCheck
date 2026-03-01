import 'package:flutter/material.dart';
import 'package:vibemental_app/l10n/app_localizations.dart';

class LikertQuestionCard extends StatelessWidget {
  const LikertQuestionCard({
    required this.question,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String question;
  final int? value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final options = <int, String>{
      0: l10n.answer0,
      1: l10n.answer1,
      2: l10n.answer2,
      3: l10n.answer3,
    };

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
}
