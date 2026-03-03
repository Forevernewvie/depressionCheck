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
  /// Purpose: Render a standardized flow guidance card for first-time users.
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(label: Text(stepLabel)),
                Chip(label: Text(estimateLabel)),
              ],
            ),
            const SizedBox(height: 10),
            Text(description, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
