import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibemental_app/core/config/checkin_config.dart';
import 'package:vibemental_app/core/theme/app_semantic_colors.dart';
import 'package:vibemental_app/core/theme/app_ui_tokens.dart';
import 'package:vibemental_app/features/checkin/application/checkin_providers.dart';
import 'package:vibemental_app/features/checkin/domain/daily_checkin_entry.dart';
import 'package:vibemental_app/l10n/app_localizations.dart';

class CheckInScreen extends ConsumerStatefulWidget {
  const CheckInScreen({super.key});

  @override
  ConsumerState<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends ConsumerState<CheckInScreen> {
  late final TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(
      text: ref.read(checkInControllerProvider).note,
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  /// Purpose: Render check-in inputs and weekly trend with clearer support
  /// framing and theme-consistent visual hierarchy.
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(checkInControllerProvider);
    final controller = ref.read(checkInControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.checkInTitle)),
      body: ListView(
        padding: AppInsets.screen,
        children: [
          Card(
            child: Padding(
              padding: AppInsets.card,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.favorite_border_rounded,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.medium),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.checkInSubtitle,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: AppSpacing.small),
                            _SecondarySupportPill(text: l10n.notDiagnosis),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.largePlus),
                  _ScoreSlider(
                    label: l10n.checkInMoodLabel,
                    value: state.mood,
                    color: Theme.of(context).colorScheme.primary,
                    onChanged: controller.updateMood,
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  _ScoreSlider(
                    label: l10n.checkInEnergyLabel,
                    value: state.energy,
                    color: context.semanticColors.success,
                    onChanged: controller.updateEnergy,
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  TextField(
                    controller: _noteController,
                    maxLength: CheckInConfig.maxNoteLength,
                    decoration: InputDecoration(
                      labelText: l10n.checkInNoteLabel,
                    ),
                    onChanged: controller.updateNote,
                  ),
                  const SizedBox(height: AppSpacing.xSmall),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: state.isSaving
                          ? null
                          : () => _save(context, ref),
                      icon: const Icon(Icons.check_rounded),
                      label: Text(l10n.checkInSaveButton),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.small),
          Text(
            l10n.checkInWeeklyTrendTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.small),
          Card(
            child: Padding(
              padding: AppInsets.section,
              child: state.trend.entries.isEmpty
                  ? Text(l10n.checkInNoTrendData)
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: AppInsets.inset,
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Text(
                            l10n.checkInWeeklyAverage(
                              state.trend.averageMood.toStringAsFixed(1),
                              state.trend.averageEnergy.toStringAsFixed(1),
                            ),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.medium),
                        for (final entry in state.trend.entries)
                          _TrendRow(entry: entry),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  /// Purpose: Save today's check-in and show success/failure feedback.
  Future<void> _save(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final success = await ref
        .read(checkInControllerProvider.notifier)
        .saveToday();
    if (!context.mounted) {
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          success ? l10n.checkInSavedSuccess : l10n.checkInSavedFail,
        ),
      ),
    );
  }
}

class _SecondarySupportPill extends StatelessWidget {
  const _SecondarySupportPill({required this.text});

  final String text;

  @override
  /// Purpose: Reinforce that check-in is a support tool rather than a primary
  /// clinical action.
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: AppInsets.chip,
        child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
      ),
    );
  }
}

class _ScoreSlider extends StatelessWidget {
  const _ScoreSlider({
    required this.label,
    required this.value,
    required this.color,
    required this.onChanged,
  });

  final String label;
  final int value;
  final Color color;
  final ValueChanged<int> onChanged;

  @override
  /// Purpose: Render one bounded score slider row with a clear current value.
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Container(
              padding: AppInsets.compactChip,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '$value',
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(color: color),
              ),
            ),
          ],
        ),
        Slider(
          value: value.toDouble(),
          min: CheckInConfig.scoreMin.toDouble(),
          max: CheckInConfig.scoreMax.toDouble(),
          divisions: CheckInConfig.scoreMax - CheckInConfig.scoreMin,
          label: '$value',
          activeColor: color,
          onChanged: (raw) => onChanged(raw.round()),
        ),
      ],
    );
  }
}

class _TrendRow extends StatelessWidget {
  const _TrendRow({required this.entry});

  final DailyCheckInEntry entry;

  @override
  /// Purpose: Render one date row with mood/energy mini trend bars.
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final semanticColors = context.semanticColors;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _displayDate(entry.localDateKey),
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 6),
          _TrendBar(
            label: l10n.checkInMoodShort,
            value: entry.mood,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 6),
          _TrendBar(
            label: l10n.checkInEnergyShort,
            value: entry.energy,
            color: semanticColors.success,
          ),
        ],
      ),
    );
  }

  /// Purpose: Convert local date key to compact readable text.
  String _displayDate(String key) {
    if (key.length >= 10) {
      return key.substring(5);
    }
    return key;
  }
}

class _TrendBar extends StatelessWidget {
  const _TrendBar({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final int value;
  final Color color;

  @override
  /// Purpose: Render adaptive trend bars with a visible track and consistent
  /// theme colors.
  Widget build(BuildContext context) {
    final ratio = (value / CheckInConfig.scoreMax).clamp(0.0, 1.0);
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Flexible(
          flex: 2,
          child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 5,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: Container(
              height: 12,
              color: colorScheme.surfaceContainerHighest,
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: ratio,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: color),
                    child: const SizedBox.expand(),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text('$value'),
      ],
    );
  }
}
