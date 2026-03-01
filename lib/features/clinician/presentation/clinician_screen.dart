import 'package:flutter/material.dart';
import 'package:vibemental_app/l10n/app_localizations.dart';

class ClinicianScreen extends StatelessWidget {
  const ClinicianScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.clinicianTitle)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(l10n.clinicianBody),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            color: Theme.of(context).colorScheme.errorContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(l10n.clinicianEmergencyPath),
            ),
          ),
        ],
      ),
    );
  }
}
