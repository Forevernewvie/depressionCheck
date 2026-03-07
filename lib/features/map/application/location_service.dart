import 'package:geolocator/geolocator.dart';
import 'package:vibemental_app/core/errors/app_failure.dart';
import 'package:vibemental_app/core/logging/app_logger.dart';
import 'package:vibemental_app/core/result/app_result.dart';

/// Purpose: Abstract location acquisition for dependency inversion and testing.
abstract class LocationService {
  /// Purpose: Get the current position or a typed failure describing why it is
  /// unavailable.
  Future<AppResult<Position>> getCurrentPosition();

  /// Purpose: Open platform app settings so permanently denied location
  /// permission can be recovered through a real user action.
  Future<bool> openAppSettings();
}

/// Purpose: Production implementation using the `geolocator` plugin.
class GeolocatorLocationService implements LocationService {
  GeolocatorLocationService(this._logger);

  final AppLogger _logger;

  @override
  Future<AppResult<Position>> getCurrentPosition() async {
    try {
      final enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) {
        return const AppError(
          PermissionFailure(
            message: 'Location service is disabled.',
            code: 'location_unavailable',
          ),
        );
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        return const AppError(
          PermissionFailure(
            message: 'Location permission denied.',
            code: 'location_denied',
          ),
        );
      }

      if (permission == LocationPermission.deniedForever) {
        return const AppError(
          PermissionFailure(
            message: 'Location permission denied forever.',
            code: 'location_denied_forever',
          ),
        );
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      return AppSuccess(position);
    } catch (error, stackTrace) {
      _logger.error(
        'Failed to get current position.',
        error: error,
        stackTrace: stackTrace,
      );
      return const AppError(
        UnknownFailure(
          message: 'Failed to get current position.',
          code: 'location_unknown',
        ),
      );
    }
  }

  @override
  Future<bool> openAppSettings() async {
    try {
      return Geolocator.openAppSettings();
    } catch (error, stackTrace) {
      _logger.error(
        'Failed to open app settings.',
        error: error,
        stackTrace: stackTrace,
      );
      return false;
    }
  }
}
