import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibemental_app/core/config/app_env.dart';
import 'package:vibemental_app/core/config/map_config.dart';
import 'package:vibemental_app/core/time/clock_providers.dart';
import 'package:vibemental_app/features/map/application/map_providers.dart';
import 'package:vibemental_app/features/map/application/map_view_state.dart';
import 'package:vibemental_app/features/map/presentation/map_marker_factory.dart';
import 'package:vibemental_app/features/map/presentation/map_presentation_policy.dart';
import 'package:vibemental_app/features/map/presentation/widgets/clinic_card.dart';
import 'package:vibemental_app/features/map/presentation/widgets/map_screen_sections.dart';
import 'package:vibemental_app/l10n/app_localizations.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen>
    with WidgetsBindingObserver {
  static const _markerFactory = MapMarkerFactory();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      ref.read(mapViewControllerProvider.notifier).loadNearby();
    });
  }

  @override
  /// Purpose: Re-check nearby clinics after users return from system settings
  /// so granted permissions can immediately recover the nearby-care flow.
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      return;
    }

    ref.read(mapViewControllerProvider.notifier).handleAppResumed();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  /// Purpose: Render nearby clinic map, trusted metadata, and action cards.
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final policy = MapPresentationPolicy(ref.read(clockProvider));
    final state = ref.watch(mapViewControllerProvider);
    final now = policy.now();
    final visibleClinics = policy.visibleClinics(
      clinics: state.clinics,
      specialistOnly: state.filterSpecialistOnly,
      openNowOnly: state.filterOpenNowOnly,
      sortOption: state.sortOption,
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.mapTitle)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          MapLoadCard(
            state: state,
            policy: policy,
            onPrimaryAction: () => _handlePrimaryLocationAction(context, state),
          ),
          const SizedBox(height: 12),
          const MapDataDisclaimerCard(),
          const SizedBox(height: 12),
          if (state.isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(child: CircularProgressIndicator()),
            ),
          if (state.clinics.isNotEmpty) _buildControlsSection(state),
          if (state.clinics.isNotEmpty) const SizedBox(height: 12),
          if (state.currentLocation != null &&
              state.contentMode == MapContentMode.mapAndList) ...[
            SizedBox(
              height: MapConfig.mapWidgetHeight,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: state.currentLocation!,
                    initialZoom: MapConfig.defaultMapZoom,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: AppEnv.osmTileUrlTemplate,
                      userAgentPackageName: AppEnv.mapUserAgentPackage,
                    ),
                    MarkerLayer(
                      markers: _markerFactory.build(
                        currentLocation: state.currentLocation,
                        clinics: visibleClinics,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          if (visibleClinics.isEmpty && !state.isLoading)
            MapEmptyStateCard(
              message: policy.emptyStateMessage(
                l10n: l10n,
                hasAnyClinics: state.clinics.isNotEmpty,
                hasActiveFilters: state.hasActiveFilters,
              ),
            ),
          ...visibleClinics.map(
            (clinic) => ClinicCard(
              key: ValueKey('${clinic.name}-${clinic.distanceMeters}'),
              clinic: clinic,
              now: now,
            ),
          ),
        ],
      ),
    );
  }

  /// Purpose: Render filter and sort controls while keeping build readable.
  Widget _buildControlsSection(MapViewState state) {
    final controller = ref.read(mapViewControllerProvider.notifier);

    return MapControlsCard(
      state: state,
      onContentModeChanged: controller.setContentMode,
      onSpecialistFilterChanged: controller.setFilterSpecialistOnly,
      onOpenNowFilterChanged: controller.setFilterOpenNowOnly,
      onSortOptionChanged: controller.setSortOption,
    );
  }

  /// Purpose: Execute the load-card primary action so permanently denied
  /// permission states lead to settings recovery instead of a dead retry.
  Future<void> _handlePrimaryLocationAction(
    BuildContext context,
    MapViewState state,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final didSucceed = await ref
        .read(mapViewControllerProvider.notifier)
        .handlePrimaryAction();
    if (!mounted) {
      return;
    }

    if (didSucceed || !state.requiresSettingsRecovery) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.mapOpenSettingsFailed)));
  }
}
