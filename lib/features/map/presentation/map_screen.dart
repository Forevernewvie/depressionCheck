import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:vibemental_app/core/config/app_env.dart';
import 'package:vibemental_app/core/config/layout_config.dart';
import 'package:vibemental_app/core/config/map_config.dart';
import 'package:vibemental_app/core/platform/external_action_providers.dart';
import 'package:vibemental_app/core/result/app_result.dart';
import 'package:vibemental_app/core/theme/app_semantic_colors.dart';
import 'package:vibemental_app/features/map/application/map_providers.dart';
import 'package:vibemental_app/features/map/application/models/nearby_clinic_load_result.dart';
import 'package:vibemental_app/features/map/domain/clinic.dart';
import 'package:vibemental_app/l10n/app_localizations.dart';

/// Purpose: Represent sort choices for nearby-clinic UX without changing
/// repository/business behavior.
enum _ClinicSortOption { distance, openNow, specialist }

/// Purpose: Represent content layout mode for map/list presentation.
enum _MapContentMode { mapAndList, listOnly }

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  bool _isLoading = false;
  String? _statusMessage;
  LatLng? _currentLocation;
  List<Clinic> _clinics = const [];
  bool _filterSpecialistOnly = false;
  bool _filterOpenNowOnly = false;
  _ClinicSortOption _sortOption = _ClinicSortOption.distance;
  _MapContentMode _contentMode = _MapContentMode.mapAndList;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _loadNearby();
    });
  }

  @override
  /// Purpose: Render nearby clinic map, trusted metadata, and action cards.
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final visibleClinics = _visibleClinics();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.mapTitle)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildLoadCard(context, l10n),
          const SizedBox(height: 12),
          _buildDataDisclaimer(context, l10n),
          const SizedBox(height: 12),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(child: CircularProgressIndicator()),
            ),
          if (_clinics.isNotEmpty) _buildFilterAndSortSection(context, l10n),
          if (_clinics.isNotEmpty) const SizedBox(height: 12),
          if (_currentLocation != null &&
              _contentMode == _MapContentMode.mapAndList) ...[
            SizedBox(
              height: MapConfig.mapWidgetHeight,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: _currentLocation!,
                    initialZoom: MapConfig.defaultMapZoom,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: AppEnv.osmTileUrlTemplate,
                      userAgentPackageName: AppEnv.mapUserAgentPackage,
                    ),
                    MarkerLayer(markers: _buildMarkers(visibleClinics)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          if (visibleClinics.isEmpty && !_isLoading)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(l10n.mapNoResultFallback),
              ),
            ),
          ...visibleClinics.map(
            (clinic) => _ClinicCard(
              key: ValueKey('${clinic.name}-${clinic.distanceMeters}'),
              clinic: clinic,
            ),
          ),
        ],
      ),
    );
  }

  /// Purpose: Render location load section with status and primary CTA.
  Widget _buildLoadCard(BuildContext context, AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;

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
            Text(l10n.mapNoLocation),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isLoading ? null : _loadNearby,
                icon: const Icon(Icons.my_location),
                label: Text(l10n.mapUseMyLocation),
              ),
            ),
            if (_statusMessage != null) ...[
              const SizedBox(height: 10),
              _StatusBanner(message: _statusMessage!, isLoading: _isLoading),
            ],
          ],
        ),
      ),
    );
  }

  /// Purpose: Render trust disclaimer that specialist/hours data may change.
  Widget _buildDataDisclaimer(BuildContext context, AppLocalizations l10n) {
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

  /// Purpose: Render UX controls for content mode, filtering, and sorting.
  Widget _buildFilterAndSortSection(
    BuildContext context,
    AppLocalizations l10n,
  ) {
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
            SegmentedButton<_MapContentMode>(
              showSelectedIcon: false,
              segments: <ButtonSegment<_MapContentMode>>[
                ButtonSegment<_MapContentMode>(
                  value: _MapContentMode.mapAndList,
                  label: Text(l10n.mapModeMapAndList),
                  icon: const Icon(Icons.map_outlined),
                ),
                ButtonSegment<_MapContentMode>(
                  value: _MapContentMode.listOnly,
                  label: Text(l10n.mapModeListOnly),
                  icon: const Icon(Icons.list_alt_outlined),
                ),
              ],
              selected: <_MapContentMode>{_contentMode},
              onSelectionChanged: (selected) {
                if (selected.isEmpty) {
                  return;
                }
                setState(() {
                  _contentMode = selected.first;
                });
              },
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilterChip(
                  label: Text(l10n.mapFilterSpecialistOnly),
                  selected: _filterSpecialistOnly,
                  onSelected: (value) {
                    setState(() {
                      _filterSpecialistOnly = value;
                    });
                  },
                ),
                FilterChip(
                  label: Text(l10n.mapFilterOpenNow),
                  selected: _filterOpenNowOnly,
                  onSelected: (value) {
                    setState(() {
                      _filterOpenNowOnly = value;
                    });
                  },
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
                  selected: _sortOption == _ClinicSortOption.distance,
                  onSelected: (_) {
                    setState(() {
                      _sortOption = _ClinicSortOption.distance;
                    });
                  },
                ),
                ChoiceChip(
                  label: Text(l10n.mapSortOpenNow),
                  selected: _sortOption == _ClinicSortOption.openNow,
                  onSelected: (_) {
                    setState(() {
                      _sortOption = _ClinicSortOption.openNow;
                    });
                  },
                ),
                ChoiceChip(
                  label: Text(l10n.mapSortSpecialist),
                  selected: _sortOption == _ClinicSortOption.specialist,
                  onSelected: (_) {
                    setState(() {
                      _sortOption = _ClinicSortOption.specialist;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Purpose: Apply UI filters and sort policy without mutating source list.
  List<Clinic> _visibleClinics() {
    final now = DateTime.now();

    final filtered = _clinics
        .where((clinic) {
          if (_filterSpecialistOnly &&
              clinic.specialistAvailability !=
                  ClinicSpecialistAvailability.available) {
            return false;
          }

          if (_filterOpenNowOnly &&
              clinic.resolveOpenState(now) != ClinicOpenState.open) {
            return false;
          }

          return true;
        })
        .toList(growable: false);

    final sorted = List<Clinic>.from(filtered);
    sorted.sort((a, b) {
      return switch (_sortOption) {
        _ClinicSortOption.distance => a.distanceMeters.compareTo(
          b.distanceMeters,
        ),
        _ClinicSortOption.openNow =>
          _openNowSortRank(a, now)
              .compareTo(_openNowSortRank(b, now))
              .thenWith(() => a.distanceMeters.compareTo(b.distanceMeters)),
        _ClinicSortOption.specialist =>
          _specialistSortRank(a)
              .compareTo(_specialistSortRank(b))
              .thenWith(() => a.distanceMeters.compareTo(b.distanceMeters)),
      };
    });

    return sorted;
  }

  /// Purpose: Rank clinics so open locations appear first in sorted list.
  int _openNowSortRank(Clinic clinic, DateTime now) {
    return switch (clinic.resolveOpenState(now)) {
      ClinicOpenState.open => 0,
      ClinicOpenState.unknown => 1,
      ClinicOpenState.closed => 2,
    };
  }

  /// Purpose: Rank clinics so specialist-confirmed locations appear first.
  int _specialistSortRank(Clinic clinic) {
    return switch (clinic.specialistAvailability) {
      ClinicSpecialistAvailability.available => 0,
      ClinicSpecialistAvailability.unknown => 1,
      ClinicSpecialistAvailability.unavailable => 2,
    };
  }

  /// Purpose: Trigger nearby clinic loading and map state updates.
  Future<void> _loadNearby({bool showLoadingIndicator = true}) async {
    if (showLoadingIndicator) {
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        _isLoading = true;
        _statusMessage = l10n.mapLocating;
      });
    }

    final service = ref.read(nearbyClinicServiceProvider);
    final result = await service.loadNearbyClinics();

    if (!mounted) {
      return;
    }

    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _currentLocation = result.center;
      _clinics = result.clinics;
      _statusMessage = _statusMessageFor(l10n, result.status);
      _isLoading = false;
    });
  }

  /// Purpose: Translate service status values into localized messages.
  String _statusMessageFor(AppLocalizations l10n, NearbyClinicStatus status) {
    return switch (status) {
      NearbyClinicStatus.realtimeLoaded => l10n.mapRealtimeLoaded,
      NearbyClinicStatus.noResultFallback => l10n.mapNoResultFallback,
      NearbyClinicStatus.networkFallback => l10n.mapNetworkFallback,
      NearbyClinicStatus.permissionDenied => l10n.mapPermissionDenied,
      NearbyClinicStatus.permissionDeniedForever =>
        l10n.mapPermissionDeniedForever,
      NearbyClinicStatus.unavailable => l10n.mapUnavailable,
    };
  }

  /// Purpose: Build map markers for current location and clinic points.
  List<Marker> _buildMarkers(List<Clinic> clinics) {
    if (_currentLocation == null) {
      return const [];
    }

    final currentMarker = Marker(
      point: _currentLocation!,
      width: MapConfig.markerSize,
      height: MapConfig.markerSize,
      child: const Icon(
        Icons.my_location,
        color: Colors.blue,
        size: MapConfig.markerIconSize,
      ),
    );

    final clinicMarkers = clinics
        .map(
          (clinic) => Marker(
            point: LatLng(clinic.latitude, clinic.longitude),
            width: MapConfig.markerSize,
            height: MapConfig.markerSize,
            child: const Icon(
              Icons.location_on,
              color: Colors.red,
              size: MapConfig.markerIconSize,
            ),
          ),
        )
        .toList(growable: false);

    return [currentMarker, ...clinicMarkers];
  }
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.message, required this.isLoading});

  final String message;
  final bool isLoading;

  @override
  /// Purpose: Present location/load status in a distinct trust-oriented banner
  /// instead of plain body text.
  Widget build(BuildContext context) {
    final semanticColors = context.semanticColors;
    final color = isLoading
        ? Theme.of(context).colorScheme.primary
        : semanticColors.warning;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(isLoading ? Icons.sync : Icons.info_outline, color: color),
          const SizedBox(width: 8),
          Expanded(child: Text(message)),
        ],
      ),
    );
  }
}

class _ClinicCard extends ConsumerWidget {
  const _ClinicCard({required this.clinic, super.key});

  final Clinic clinic;

  @override
  /// Purpose: Render clinic summary card with specialist/hours/action sections.
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final openState = clinic.resolveOpenState(now);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    clinic.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const SizedBox(width: 8),
                _OpenStateChip(openState: openState),
              ],
            ),
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
                  _SpecialistChip(availability: clinic.specialistAvailability),
                  const SizedBox(height: 10),
                  _TodayHoursLine(clinic: clinic),
                  const SizedBox(height: 6),
                  _WeeklyHoursSummary(clinic: clinic),
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
                          onPressed: () =>
                              _openDirections(context, ref, clinic),
                          child: Text(l10n.buttonDirections),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () =>
                              _copyAddress(context, clinic.address),
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
                        onPressed: () => _copyAddress(context, clinic.address),
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

  /// Purpose: Launch a sanitized phone dial action and display failure feedback.
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

  /// Purpose: Launch external map directions and display failure feedback.
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

  /// Purpose: Copy address text for external sharing and show localized feedback.
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

class _OpenStateChip extends StatelessWidget {
  const _OpenStateChip({required this.openState});

  final ClinicOpenState openState;

  @override
  /// Purpose: Render localized open-state chip with high-contrast semantic color.
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

class _SpecialistChip extends StatelessWidget {
  const _SpecialistChip({required this.availability});

  final ClinicSpecialistAvailability availability;

  @override
  /// Purpose: Render specialist-availability chip with safe fallback wording.
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

class _TodayHoursLine extends StatelessWidget {
  const _TodayHoursLine({required this.clinic});

  final Clinic clinic;

  @override
  /// Purpose: Render today's operating-hours row with localized fallback label.
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final todayHours = clinic.openingHoursForWeekday(now.weekday);
    final text = todayHours == null || todayHours.trim().isEmpty
        ? l10n.mapHoursUnavailable
        : todayHours;

    return Text('${l10n.mapHoursToday}: $text');
  }
}

class _WeeklyHoursSummary extends StatelessWidget {
  const _WeeklyHoursSummary({required this.clinic});

  final Clinic clinic;

  @override
  /// Purpose: Render compact weekly schedule summary for available weekday rows.
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

  /// Purpose: Build localized weekday/hour rows from clinic schedule map.
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

  /// Purpose: Build localized short weekday labels for schedule rendering.
  String _weekdayLabel(String localeTag, int weekday) {
    final monday = DateTime.utc(2024, 1, 1);
    final date = monday.add(Duration(days: weekday - DateTime.monday));
    return DateFormat.E(localeTag).format(date);
  }
}

extension on int {
  /// Purpose: Provide deterministic `then` behavior for comparator chaining.
  int thenWith(int Function() next) {
    if (this != 0) {
      return this;
    }
    return next();
  }
}
