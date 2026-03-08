import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vibemental_app/core/config/layout_config.dart';
import 'package:vibemental_app/core/config/map_config.dart';
import 'package:vibemental_app/core/platform/external_action_providers.dart';
import 'package:vibemental_app/core/result/app_result.dart';
import 'package:vibemental_app/features/map/domain/clinic.dart';
import 'package:vibemental_app/l10n/app_localizations.dart';

/// Purpose: Render one clinic card with compact metadata and one-tap actions.
class ClinicCard extends ConsumerWidget {
  const ClinicCard({required this.clinic, required this.now, super.key});

  final Clinic clinic;
  final DateTime now;

  @override
  /// Purpose: Build a responsive clinic card without leaking screen-level state.
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final openState = clinic.resolveOpenState(now);
    final hasAddress = clinic.address?.trim().isNotEmpty ?? false;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ClinicHeader(clinic: clinic, openState: openState),
            const SizedBox(height: 6),
            Text(
              '${clinic.distanceLabel} · ${clinic.category}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (clinic.address != null && clinic.address!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                clinic.address!,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SpecialistChip(availability: clinic.specialistAvailability),
                  const SizedBox(height: 10),
                  TodayHoursLine(clinic: clinic, now: now),
                  const SizedBox(height: 6),
                  WeeklyHoursSummary(clinic: clinic),
                ],
              ),
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                final textScale = MediaQuery.textScalerOf(context).scale(1);
                final useCompactLayout =
                    constraints.maxWidth <
                        LayoutConfig.compactMapActionWidthThreshold ||
                    textScale > LayoutConfig.compactTextScaleThreshold;

                if (useCompactLayout) {
                  return Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.tonal(
                          onPressed: clinic.phone == null
                              ? null
                              : () => _callClinic(context, ref, clinic.phone!),
                          child: Text(l10n.buttonCallClinic),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => _openDirections(context, ref, clinic),
                          child: Text(l10n.buttonDirections),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: hasAddress
                              ? () => _copyAddress(context, clinic.address)
                              : null,
                          child: Text(l10n.mapCopyAddress),
                        ),
                      ),
                    ],
                  );
                }

                return Row(
                  children: [
                    Expanded(
                      child: FilledButton.tonal(
                        onPressed: clinic.phone == null
                            ? null
                            : () => _callClinic(context, ref, clinic.phone!),
                        child: Text(l10n.buttonCallClinic),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _openDirections(context, ref, clinic),
                        child: Text(l10n.buttonDirections),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: hasAddress
                            ? () => _copyAddress(context, clinic.address)
                            : null,
                        child: Text(l10n.mapCopyAddress),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Purpose: Launch a sanitized phone dial action and show localized failure.
  Future<void> _callClinic(
    BuildContext context,
    WidgetRef ref,
    String rawPhone,
  ) async {
    final actions = ref.read(externalActionServiceProvider);
    final result = await actions.callPhone(rawPhone);

    if (result is AppError && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result.failure.message)));
    }
  }

  /// Purpose: Open external map directions and show localized failure feedback.
  Future<void> _openDirections(
    BuildContext context,
    WidgetRef ref,
    Clinic clinic,
  ) async {
    final actions = ref.read(externalActionServiceProvider);
    final result = await actions.openDirections(
      latitude: clinic.latitude,
      longitude: clinic.longitude,
    );

    if (result is AppError && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result.failure.message)));
    }
  }

  /// Purpose: Copy address text for follow-up sharing without screen coupling.
  Future<void> _copyAddress(BuildContext context, String? rawAddress) async {
    final l10n = AppLocalizations.of(context)!;
    final address = rawAddress?.trim();
    if (address == null || address.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.mapAddressUnavailable)));
      return;
    }

    await Clipboard.setData(ClipboardData(text: address));
    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.mapCopyAddressSuccess)));
  }
}

/// Purpose: Keep clinic title and open-state chip readable on narrow layouts.
class _ClinicHeader extends StatelessWidget {
  const _ClinicHeader({required this.clinic, required this.openState});

  final Clinic clinic;
  final ClinicOpenState openState;

  @override
  /// Purpose: Render clinic header with adaptive stacking behavior.
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textScale = MediaQuery.textScalerOf(context).scale(1);
        final useCompactHeader =
            constraints.maxWidth <
                LayoutConfig.compactMapHeaderWidthThreshold ||
            textScale > LayoutConfig.compactTextScaleThreshold;

        final title = Text(
          clinic.name,
          maxLines: useCompactHeader ? 3 : 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium,
        );
        final openStateChip = OpenStateChip(openState: openState);

        if (useCompactHeader) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [title, const SizedBox(height: 8), openStateChip],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: title),
            const SizedBox(width: 8),
            openStateChip,
          ],
        );
      },
    );
  }
}

/// Purpose: Render localized open-state chip with accessible contrast.
class OpenStateChip extends StatelessWidget {
  const OpenStateChip({required this.openState, super.key});

  final ClinicOpenState openState;

  @override
  /// Purpose: Build chip colors and labels from the resolved clinic state.
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    final (label, background, foreground) = switch (openState) {
      ClinicOpenState.open => (
        l10n.mapOpenNow,
        colorScheme.primaryContainer,
        colorScheme.onPrimaryContainer,
      ),
      ClinicOpenState.closed => (
        l10n.mapClosedNow,
        colorScheme.tertiaryContainer,
        colorScheme.onTertiaryContainer,
      ),
      ClinicOpenState.unknown => (
        l10n.mapOpenStateUnknown,
        colorScheme.surfaceContainerHighest,
        colorScheme.onSurfaceVariant,
      ),
    };

    return Chip(
      label: Text(label),
      backgroundColor: background,
      labelStyle: TextStyle(color: foreground),
      visualDensity: VisualDensity.compact,
    );
  }
}

/// Purpose: Render specialist-availability status without relying on the parent.
class SpecialistChip extends StatelessWidget {
  const SpecialistChip({required this.availability, super.key});

  final ClinicSpecialistAvailability availability;

  @override
  /// Purpose: Build specialist chip label and color from availability state.
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    final (label, background, foreground, icon) = switch (availability) {
      ClinicSpecialistAvailability.available => (
        l10n.mapSpecialistAvailable,
        colorScheme.primaryContainer,
        colorScheme.onPrimaryContainer,
        Icons.verified,
      ),
      ClinicSpecialistAvailability.unavailable => (
        l10n.mapSpecialistUnavailable,
        colorScheme.surfaceContainerHighest,
        colorScheme.onSurface,
        Icons.info_outline,
      ),
      ClinicSpecialistAvailability.unknown => (
        l10n.mapSpecialistUnknown,
        colorScheme.tertiaryContainer,
        colorScheme.onTertiaryContainer,
        Icons.help_outline,
      ),
    };

    return Chip(
      avatar: Icon(icon, size: 16, color: foreground),
      label: Text(label),
      backgroundColor: background,
      labelStyle: TextStyle(color: foreground),
      visualDensity: VisualDensity.compact,
    );
  }
}

/// Purpose: Render today's hours line using the shared `now` value.
class TodayHoursLine extends StatelessWidget {
  const TodayHoursLine({required this.clinic, required this.now, super.key});

  final Clinic clinic;
  final DateTime now;

  @override
  /// Purpose: Resolve today's label with graceful fallback when hours are absent.
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final todayHours = clinic.openingHoursForWeekday(now.weekday);
    final text = todayHours == null || todayHours.trim().isEmpty
        ? l10n.mapHoursUnavailable
        : todayHours;

    return Text('${l10n.mapHoursToday}: $text');
  }
}

/// Purpose: Render a compact weekly hours summary for one clinic.
class WeeklyHoursSummary extends StatelessWidget {
  const WeeklyHoursSummary({required this.clinic, super.key});

  final Clinic clinic;

  @override
  /// Purpose: Build an expandable weekly-hours section only when rows exist.
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final rows = _buildRows(context);
    if (rows.isEmpty) {
      return Text('${l10n.mapHoursWeekly}: ${l10n.mapHoursUnavailable}');
    }

    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      childrenPadding: EdgeInsets.zero,
      title: Text(l10n.mapHoursWeekly),
      dense: true,
      children: rows,
    );
  }

  /// Purpose: Build localized weekday/hour rows from clinic schedule data.
  List<Widget> _buildRows(BuildContext context) {
    final localeTag = Localizations.localeOf(context).toLanguageTag();
    final rows = <Widget>[];

    for (final weekday in MapConfig.weekdayOrder) {
      final hours = clinic.openingHoursForWeekday(weekday);
      if (hours == null || hours.trim().isEmpty) {
        continue;
      }

      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Text('${_weekdayLabel(localeTag, weekday)} $hours'),
        ),
      );
    }

    return rows;
  }

  /// Purpose: Build a localized short weekday label for one weekday index.
  String _weekdayLabel(String localeTag, int weekday) {
    final monday = DateTime.utc(2024, 1, 1);
    final date = monday.add(Duration(days: weekday - DateTime.monday));
    return DateFormat.E(localeTag).format(date);
  }
}
