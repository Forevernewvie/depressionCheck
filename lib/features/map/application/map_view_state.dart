import 'package:latlong2/latlong.dart';
import 'package:vibemental_app/features/map/application/models/nearby_clinic_load_result.dart';
import 'package:vibemental_app/features/map/domain/clinic.dart';
import 'package:vibemental_app/features/map/presentation/map_presentation_policy.dart';

/// Purpose: Represent content layout mode for nearby-clinic presentation.
enum MapContentMode { mapAndList, listOnly }

/// Purpose: Hold immutable UI state for the nearby-clinic map experience.
class MapViewState {
  const MapViewState({
    this.isLoading = false,
    this.lastStatus,
    this.currentLocation,
    this.clinics = const [],
    this.filterSpecialistOnly = false,
    this.filterOpenNowOnly = false,
    this.sortOption = ClinicSortOption.distance,
    this.contentMode = MapContentMode.mapAndList,
    this.shouldReloadAfterSettingsReturn = false,
  });

  final bool isLoading;
  final NearbyClinicStatus? lastStatus;
  final LatLng? currentLocation;
  final List<Clinic> clinics;
  final bool filterSpecialistOnly;
  final bool filterOpenNowOnly;
  final ClinicSortOption sortOption;
  final MapContentMode contentMode;
  final bool shouldReloadAfterSettingsReturn;

  /// Purpose: Tell the presentation layer whether any user filter is active.
  bool get hasActiveFilters => filterSpecialistOnly || filterOpenNowOnly;

  /// Purpose: Tell the presentation layer whether the current state should
  /// guide the user into system settings recovery.
  bool get requiresSettingsRecovery =>
      lastStatus == NearbyClinicStatus.permissionDeniedForever;

  /// Purpose: Create immutable next state while keeping defaults centralized.
  MapViewState copyWith({
    bool? isLoading,
    NearbyClinicStatus? lastStatus,
    bool clearLastStatus = false,
    LatLng? currentLocation,
    bool clearCurrentLocation = false,
    List<Clinic>? clinics,
    bool? filterSpecialistOnly,
    bool? filterOpenNowOnly,
    ClinicSortOption? sortOption,
    MapContentMode? contentMode,
    bool? shouldReloadAfterSettingsReturn,
  }) {
    return MapViewState(
      isLoading: isLoading ?? this.isLoading,
      lastStatus: clearLastStatus ? null : lastStatus ?? this.lastStatus,
      currentLocation: clearCurrentLocation
          ? null
          : currentLocation ?? this.currentLocation,
      clinics: clinics ?? this.clinics,
      filterSpecialistOnly: filterSpecialistOnly ?? this.filterSpecialistOnly,
      filterOpenNowOnly: filterOpenNowOnly ?? this.filterOpenNowOnly,
      sortOption: sortOption ?? this.sortOption,
      contentMode: contentMode ?? this.contentMode,
      shouldReloadAfterSettingsReturn:
          shouldReloadAfterSettingsReturn ??
          this.shouldReloadAfterSettingsReturn,
    );
  }
}
