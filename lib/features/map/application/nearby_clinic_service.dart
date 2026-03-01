import 'package:latlong2/latlong.dart';
import 'package:vibemental_app/core/config/app_env.dart';
import 'package:vibemental_app/core/config/map_config.dart';
import 'package:vibemental_app/core/errors/app_failure.dart';
import 'package:vibemental_app/core/logging/app_logger.dart';
import 'package:vibemental_app/core/result/app_result.dart';
import 'package:vibemental_app/features/map/application/location_service.dart';
import 'package:vibemental_app/features/map/application/models/nearby_clinic_load_result.dart';
import 'package:vibemental_app/features/map/data/clinic_repository.dart';
import 'package:vibemental_app/features/map/data/fallback_clinics.dart';
import 'package:vibemental_app/features/map/domain/clinic.dart';
import 'package:geolocator/geolocator.dart';

/// Purpose: Coordinate location lookup and clinic repository access while
/// keeping fallback behavior consistent and testable.
class NearbyClinicService {
  NearbyClinicService({
    required this.locationService,
    required this.repository,
    required this.logger,
  });

  final LocationService locationService;
  final ClinicRepository repository;
  final AppLogger logger;

  /// Purpose: Load nearby clinics with deterministic fallback for all known
  /// permission/network failures.
  Future<NearbyClinicLoadResult> loadNearbyClinics() async {
    final locationResult = await locationService.getCurrentPosition();

    if (locationResult is AppError<Position>) {
      final fallback = _fallbackData();
      final failure = locationResult.failure;
      logger.warn('Location lookup failed.', context: {'code': failure.code});

      return NearbyClinicLoadResult(
        center: fallback.$1,
        clinics: fallback.$2,
        status: switch (failure.code) {
          'location_denied' => NearbyClinicStatus.permissionDenied,
          'location_denied_forever' =>
            NearbyClinicStatus.permissionDeniedForever,
          _ => NearbyClinicStatus.unavailable,
        },
      );
    }

    final position = (locationResult as AppSuccess<Position>).data;
    final center = LatLng(position.latitude, position.longitude);

    if (!AppEnv.enableRemoteClinicLookup) {
      logger.info('Remote clinic lookup disabled by environment.');
      return NearbyClinicLoadResult(
        center: center,
        clinics: _fallbackData().$2,
        status: NearbyClinicStatus.networkFallback,
      );
    }

    final clinicResult = await repository.getNearbyClinics(
      latitude: center.latitude,
      longitude: center.longitude,
      radiusMeters: AppEnv.defaultClinicSearchRadiusMeters,
    );

    return clinicResult.when(
      success: (clinics) {
        if (clinics.isEmpty) {
          return NearbyClinicLoadResult(
            center: center,
            clinics: _fallbackData().$2,
            status: NearbyClinicStatus.noResultFallback,
          );
        }

        return NearbyClinicLoadResult(
          center: center,
          clinics: clinics,
          status: NearbyClinicStatus.realtimeLoaded,
        );
      },
      failure: (failure) {
        logger.warn(
          'Clinic repository failed.',
          context: {'code': failure.code},
        );
        return NearbyClinicLoadResult(
          center: center,
          clinics: _fallbackData().$2,
          status: _statusForFailure(failure),
        );
      },
    );
  }

  /// Purpose: Map low-level failures to user-facing map status.
  NearbyClinicStatus _statusForFailure(AppFailure failure) {
    if (failure is PermissionFailure) {
      return NearbyClinicStatus.permissionDenied;
    }
    if (failure is NetworkFailure) {
      return NearbyClinicStatus.networkFallback;
    }
    return NearbyClinicStatus.unavailable;
  }

  /// Purpose: Build fallback data tuple (center + clinics) used by all
  /// failure paths.
  (LatLng, List<Clinic>) _fallbackData() {
    return (
      const LatLng(MapConfig.fallbackCenterLat, MapConfig.fallbackCenterLng),
      FallbackClinics.build(),
    );
  }
}
