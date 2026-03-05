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
  /// Purpose: Render a selectable Likert question card with high-contrast chip
  /// labels for light/dark accessibility.
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
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
                  showCheckmark: false,
                  selectedColor: colorScheme.primary,
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  side: BorderSide(
                    color: selected
                        ? colorScheme.primary
                        : colorScheme.outlineVariant,
                  ),
                  labelStyle: _chipLabelStyle(
                    context: context,
                    selected: selected,
                  ),
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

  /// Purpose: Build deterministic chip label styles with explicit contrast
  /// between selected and unselected states.
  TextStyle _chipLabelStyle({
    required BuildContext context,
    required bool selected,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final baseStyle = theme.textTheme.bodyMedium;

    return (baseStyle ?? const TextStyle()).copyWith(
      color: selected ? colorScheme.onPrimary : colorScheme.onSurface,
      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
    );
  }
}
