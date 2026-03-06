import 'package:flutter/material.dart';

class FlowHeaderCard extends StatelessWidget {
  const FlowHeaderCard({
    required this.title,
    required this.stepLabel,
    required this.estimateLabel,
    required this.description,
    super.key,
  });

  final String title;
  final String stepLabel;
  final String estimateLabel;
  final String description;

  @override
  /// Purpose: Render a clearer screening flow header with trust cues and
  /// stronger step/time hierarchy.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
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
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.monitor_heart_outlined,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: theme.textTheme.titleMedium),
                      const SizedBox(height: 6),
                      Text(description, style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _FlowInfoChip(label: stepLabel, icon: Icons.alt_route_outlined),
                _FlowInfoChip(
                  label: estimateLabel,
                  icon: Icons.schedule_outlined,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FlowInfoChip extends StatelessWidget {
  const _FlowInfoChip({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  /// Purpose: Present short flow metadata without overwhelming the header.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: colorScheme.primary),
            const SizedBox(width: 6),
            Text(label, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
