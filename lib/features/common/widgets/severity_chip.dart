import 'package:flutter/material.dart';
import 'package:vibemental_app/l10n/app_localizations.dart';
import 'package:vibemental_app/core/theme/app_semantic_colors.dart';
import 'package:vibemental_app/features/screening/domain/severity.dart';

class SeverityChip extends StatelessWidget {
  const SeverityChip({required this.severity, super.key});

  final SeverityLevel severity;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final semantic = context.semanticColors;

    final Color color;
    final String label;
    switch (severity) {
      case SeverityLevel.normal:
        color = semantic.success;
        label = l10n.levelNormal;
      case SeverityLevel.mild:
        color = semantic.warning;
        label = l10n.levelMild;
      case SeverityLevel.moderate:
        color = semantic.warning;
        label = l10n.levelModerate;
      case SeverityLevel.highRisk:
        color = semantic.danger;
        label = l10n.levelHighRisk;
    }

    return Chip(
      side: BorderSide.none,
      backgroundColor: color.withValues(alpha: 0.15),
      label: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}
