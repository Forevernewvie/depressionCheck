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
  /// Purpose: Render one question card with calmer hierarchy and accessible,
  /// high-contrast selection controls.
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final options = <int, String>{
      0: l10n.answer0,
      1: l10n.answer1,
      2: l10n.answer2,
      3: l10n.answer3,
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                question,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(height: 1.35),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: options.entries.map((entry) {
                final selected = value == entry.key;
                return Semantics(
                  button: true,
                  selected: selected,
                  label: entry.value,
                  child: ChoiceChip(
                    selected: selected,
                    showCheckmark: false,
                    selectedColor: colorScheme.primary,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    side: BorderSide(
                      color: selected
                          ? colorScheme.primary
                          : colorScheme.outlineVariant,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    labelStyle: _chipLabelStyle(
                      context: context,
                      selected: selected,
                    ),
                    label: Text('${entry.key}  ${entry.value}'),
                    onSelected: (_) => onChanged(entry.key),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  /// Purpose: Provide deterministic high-contrast label style for selected and
  /// unselected choice chips.
  TextStyle _chipLabelStyle({
    required BuildContext context,
    required bool selected,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final baseStyle = theme.textTheme.bodyMedium;

    return (baseStyle ?? const TextStyle()).copyWith(
      color: selected ? colorScheme.onPrimary : colorScheme.onSurface,
      fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
    );
  }
}
