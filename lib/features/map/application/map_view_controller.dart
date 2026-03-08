import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibemental_app/core/logging/app_logger.dart';
import 'package:vibemental_app/features/map/application/location_service.dart';
import 'package:vibemental_app/features/map/application/map_view_state.dart';
import 'package:vibemental_app/features/map/application/models/nearby_clinic_load_result.dart';
import 'package:vibemental_app/features/map/application/nearby_clinic_service.dart';
import 'package:vibemental_app/features/map/presentation/map_presentation_policy.dart';

/// Purpose: Coordinate nearby-clinic screen state transitions outside the
/// widget tree so lifecycle recovery and filters stay unit-testable.
class MapViewController extends StateNotifier<MapViewState> {
  MapViewController(
    this._nearbyClinicService,
    this._locationService,
    this._logger,
  ) : super(const MapViewState());

  final NearbyClinicService _nearbyClinicService;
  final LocationService _locationService;
  final AppLogger _logger;

  /// Purpose: Load nearby clinics and store a fully normalized next view state.
  Future<void> loadNearby({bool showLoadingIndicator = true}) async {
    if (state.isLoading) {
      return;
    }

    if (showLoadingIndicator) {
      state = state.copyWith(isLoading: true);
    }

    final result = await _nearbyClinicService.loadNearbyClinics();
    state = state.copyWith(
      isLoading: false,
      currentLocation: result.center,
      clinics: result.clinics,
      lastStatus: result.status,
    );

    _logger.info(
      'Nearby clinics loaded into map view.',
      context: {
        'status': result.status.name,
        'clinicCount': result.clinics.length,
      },
    );
  }

  /// Purpose: Route the primary CTA either to refresh nearby results or to
  /// permission recovery in system settings.
  Future<bool> handlePrimaryAction() async {
    if (state.lastStatus == NearbyClinicStatus.permissionDeniedForever) {
      return openLocationSettings();
    }

    await loadNearby();
    return true;
  }

  /// Purpose: Mark settings recovery intent only when the platform accepts the
  /// request to open app settings.
  Future<bool> openLocationSettings() async {
    final didOpen = await _locationService.openAppSettings();
    if (!didOpen) {
      _logger.warn('Failed to open app settings for map recovery.');
      return false;
    }

    state = state.copyWith(shouldReloadAfterSettingsReturn: true);
    _logger.info('Opened app settings for map permission recovery.');
    return true;
  }

  /// Purpose: Retry nearby-clinic loading once the app resumes from settings.
  Future<void> handleAppResumed() async {
    if (!state.shouldReloadAfterSettingsReturn || state.isLoading) {
      return;
    }

    state = state.copyWith(shouldReloadAfterSettingsReturn: false);
    await loadNearby();
  }

  /// Purpose: Toggle the specialist-only filter without mutating unrelated UI.
  void setFilterSpecialistOnly(bool value) {
    state = state.copyWith(filterSpecialistOnly: value);
  }

  /// Purpose: Toggle the open-now filter without mutating unrelated UI.
  void setFilterOpenNowOnly(bool value) {
    state = state.copyWith(filterOpenNowOnly: value);
  }

  /// Purpose: Update clinic sorting preference for the map results list.
  void setSortOption(ClinicSortOption value) {
    state = state.copyWith(sortOption: value);
  }

  /// Purpose: Switch between map-plus-list and list-only presentation modes.
  void setContentMode(MapContentMode value) {
    state = state.copyWith(contentMode: value);
  }
}
