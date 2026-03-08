import 'package:flutter/material.dart';
import 'package:vibemental_app/features/map/application/map_view_state.dart';
import 'package:vibemental_app/features/map/presentation/map_presentation_policy.dart';
import 'package:vibemental_app/l10n/app_localizations.dart';

/// Purpose: Render the top map load card outside the screen widget so the main
/// screen stays focused on section ordering.
class MapLoadCard extends StatelessWidget {
  const MapLoadCard({
    required this.state,
    required this.policy,
    required this.onPrimaryAction,
    super.key,
  });

  final MapViewState state;
  final MapPresentationPolicy policy;
  final VoidCallback onPrimaryAction;

  @override
  /// Purpose: Build the load/recovery card with truthful CTA copy.
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final actionKind = policy.primaryActionKind(state.lastStatus);

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
                  child: Icon(Icons.map_outlined, color: colorScheme.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.mapSubtitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              policy.loadCardBodyText(
                l10n: l10n,
                isLoading: state.isLoading,
                status: state.lastStatus,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: state.isLoading ? null : onPrimaryAction,
                icon: Icon(policy.primaryActionIcon(actionKind)),
                label: Text(policy.primaryActionLabel(l10n, actionKind)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Purpose: Render the operational data disclaimer without repeating layout in
/// the main screen.
class MapDataDisclaimerCard extends StatelessWidget {
  const MapDataDisclaimerCard({super.key});

  @override
  /// Purpose: Build the data disclaimer card for hours and specialist info.
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 20,
            color: theme.colorScheme.onErrorContainer,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.mapDataDisclaimer,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Purpose: Render filter and sort controls outside the screen widget to keep
/// the main build method readable.
class MapControlsCard extends StatelessWidget {
  const MapControlsCard({
    required this.state,
    required this.onContentModeChanged,
    required this.onSpecialistFilterChanged,
    required this.onOpenNowFilterChanged,
    required this.onSortOptionChanged,
    super.key,
  });

  final MapViewState state;
  final ValueChanged<MapContentMode> onContentModeChanged;
  final ValueChanged<bool> onSpecialistFilterChanged;
  final ValueChanged<bool> onOpenNowFilterChanged;
  final ValueChanged<ClinicSortOption> onSortOptionChanged;

  @override
  /// Purpose: Build presentation controls for view mode, filters, and sorting.
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.mapControlsTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            SegmentedButton<MapContentMode>(
              showSelectedIcon: false,
              segments: <ButtonSegment<MapContentMode>>[
                ButtonSegment<MapContentMode>(
                  value: MapContentMode.mapAndList,
                  label: Text(l10n.mapModeMapAndList),
                  icon: const Icon(Icons.map_outlined),
                ),
                ButtonSegment<MapContentMode>(
                  value: MapContentMode.listOnly,
                  label: Text(l10n.mapModeListOnly),
                  icon: const Icon(Icons.list_alt_outlined),
                ),
              ],
              selected: <MapContentMode>{state.contentMode},
              onSelectionChanged: (selected) {
                if (selected.isEmpty) {
                  return;
                }
                onContentModeChanged(selected.first);
              },
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilterChip(
                  label: Text(l10n.mapFilterSpecialistOnly),
                  selected: state.filterSpecialistOnly,
                  onSelected: onSpecialistFilterChanged,
                ),
                FilterChip(
                  label: Text(l10n.mapFilterOpenNow),
                  selected: state.filterOpenNowOnly,
                  onSelected: onOpenNowFilterChanged,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  label: Text(l10n.mapSortDistance),
                  selected: state.sortOption == ClinicSortOption.distance,
                  onSelected: (_) =>
                      onSortOptionChanged(ClinicSortOption.distance),
                ),
                ChoiceChip(
                  label: Text(l10n.mapSortOpenNow),
                  selected: state.sortOption == ClinicSortOption.openNow,
                  onSelected: (_) =>
                      onSortOptionChanged(ClinicSortOption.openNow),
                ),
                ChoiceChip(
                  label: Text(l10n.mapSortSpecialist),
                  selected: state.sortOption == ClinicSortOption.specialist,
                  onSelected: (_) =>
                      onSortOptionChanged(ClinicSortOption.specialist),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Purpose: Render the empty-state card outside the main screen widget for
/// easier scanning of the screen structure.
class MapEmptyStateCard extends StatelessWidget {
  const MapEmptyStateCard({required this.message, super.key});

  final String message;

  @override
  /// Purpose: Build a simple empty-state card with consistent padding.
  Widget build(BuildContext context) {
    return Card(
      child: Padding(padding: const EdgeInsets.all(16), child: Text(message)),
    );
  }
}
