import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:vibemental_app/core/config/app_env.dart';
import 'package:vibemental_app/core/config/layout_config.dart';
import 'package:vibemental_app/core/config/map_config.dart';
import 'package:vibemental_app/core/platform/external_action_providers.dart';
import 'package:vibemental_app/core/result/app_result.dart';
import 'package:vibemental_app/features/common/widgets/page_content_container.dart';
import 'package:vibemental_app/features/map/application/map_providers.dart';
import 'package:vibemental_app/features/map/application/models/nearby_clinic_load_result.dart';
import 'package:vibemental_app/features/map/domain/clinic.dart';
import 'package:vibemental_app/l10n/app_localizations.dart';

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
  /// Purpose: Render nearby clinic map, status, and fallback cards.
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.mapTitle)),
      body: PageContentContainer(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.mapSubtitle,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(l10n.mapNoLocation),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: _isLoading ? null : _loadNearby,
                      icon: const Icon(Icons.my_location),
                      label: Text(l10n.mapUseMyLocation),
                    ),
                    if (_statusMessage != null) ...[
                      const SizedBox(height: 10),
                      Text(_statusMessage!),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(child: CircularProgressIndicator()),
              ),
            if (_currentLocation != null) ...[
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
                      MarkerLayer(markers: _buildMarkers()),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
            ..._clinics.map((clinic) => _ClinicCard(clinic: clinic)),
          ],
        ),
      ),
    );
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
  List<Marker> _buildMarkers() {
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

    final clinicMarkers = _clinics
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

class _ClinicCard extends ConsumerWidget {
  const _ClinicCard({required this.clinic});

  final Clinic clinic;

  @override
  /// Purpose: Render clinic summary card with adaptive action layout.
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              clinic.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium,
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
}
