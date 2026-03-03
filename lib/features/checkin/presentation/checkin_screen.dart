import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibemental_app/core/config/checkin_config.dart';
import 'package:vibemental_app/features/checkin/application/checkin_providers.dart';
import 'package:vibemental_app/features/checkin/domain/daily_checkin_entry.dart';
import 'package:vibemental_app/features/common/widgets/page_content_container.dart';
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
  /// Purpose: Render check-in inputs and weekly trend in a scrollable layout.
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(checkInControllerProvider);
    final controller = ref.read(checkInControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.checkInTitle)),
      body: PageContentContainer(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              l10n.checkInSubtitle,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ScoreSlider(
                      label: l10n.checkInMoodLabel,
                      value: state.mood,
                      onChanged: controller.updateMood,
                    ),
                    const SizedBox(height: 8),
                    _ScoreSlider(
                      label: l10n.checkInEnergyLabel,
                      value: state.energy,
                      onChanged: controller.updateEnergy,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _noteController,
                      maxLength: CheckInConfig.maxNoteLength,
                      decoration: InputDecoration(
                        labelText: l10n.checkInNoteLabel,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: controller.updateNote,
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: state.isSaving
                            ? null
                            : () => _save(context, ref),
                        child: Text(l10n.checkInSaveButton),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.checkInWeeklyTrendTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: state.trend.entries.isEmpty
                    ? Text(l10n.checkInNoTrendData)
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.checkInWeeklyAverage(
                              state.trend.averageMood.toStringAsFixed(1),
                              state.trend.averageEnergy.toStringAsFixed(1),
                            ),
                          ),
                          const SizedBox(height: 12),
                          for (final entry in state.trend.entries)
                            _TrendRow(entry: entry),
                        ],
                      ),
              ),
            ),
          ],
        ),
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

class _ScoreSlider extends StatelessWidget {
  const _ScoreSlider({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  /// Purpose: Render one bounded score slider row for mood/energy input.
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: $value'),
        Slider(
          value: value.toDouble(),
          min: CheckInConfig.scoreMin.toDouble(),
          max: CheckInConfig.scoreMax.toDouble(),
          divisions: CheckInConfig.scoreMax - CheckInConfig.scoreMin,
          label: '$value',
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_displayDate(entry.localDateKey)),
          const SizedBox(height: 4),
          _TrendBar(
            label: l10n.checkInMoodShort,
            value: entry.mood,
            color: Colors.blue,
          ),
          const SizedBox(height: 4),
          _TrendBar(
            label: l10n.checkInEnergyShort,
            value: entry.energy,
            color: Colors.green,
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
  /// Purpose: Render adaptive trend bar without fixed-width overflow.
  Widget build(BuildContext context) {
    final ratio = (value / CheckInConfig.scoreMax).clamp(0.0, 1.0);

    return Row(
      children: [
        Flexible(
          flex: 2,
          child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 5,
          child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: ratio,
              child: Container(
                height: 10,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(6),
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
