import 'package:url_launcher/url_launcher.dart';
import 'package:vibemental_app/core/errors/app_failure.dart';
import 'package:vibemental_app/core/logging/app_logger.dart';
import 'package:vibemental_app/core/result/app_result.dart';
import 'package:vibemental_app/core/security/input_validator.dart';

/// Purpose: Abstract platform-dependent external actions for testability.
abstract class ExternalActionService {
  /// Purpose: Open device dialer with a sanitized phone number.
  Future<AppResult<void>> callPhone(String rawPhone);

  /// Purpose: Open external map app using coordinates.
  Future<AppResult<void>> openDirections({
    required double latitude,
    required double longitude,
  });
}

/// Purpose: Implement external actions using `url_launcher`.
class UrlLauncherExternalActionService implements ExternalActionService {
  UrlLauncherExternalActionService(this._logger);

  final AppLogger _logger;

  @override
  Future<AppResult<void>> callPhone(String rawPhone) async {
    final sanitized = InputValidator.sanitizePhoneNumber(rawPhone);
    if (sanitized.isEmpty) {
      return const AppError(
        ValidationFailure(
          message: 'Invalid phone number.',
          code: 'invalid_phone',
        ),
      );
    }

    try {
      final uri = Uri(scheme: 'tel', path: sanitized);
      final launched = await launchUrl(uri);
      if (!launched) {
        _logger.warn('Failed to launch dialer.', context: {'phone': sanitized});
        return const AppError(
          UnknownFailure(
            message: 'Unable to open phone dialer.',
            code: 'dialer_failed',
          ),
        );
      }
    } catch (error, stackTrace) {
      _logger.error(
        'Dialer action threw an exception.',
        error: error,
        stackTrace: stackTrace,
      );
      return const AppError(
        UnknownFailure(
          message: 'Unable to open phone dialer.',
          code: 'dialer_exception',
        ),
      );
    }

    return const AppSuccess<void>(null);
  }

  @override
  Future<AppResult<void>> openDirections({
    required double latitude,
    required double longitude,
  }) async {
    if (!InputValidator.isValidCoordinate(
      latitude: latitude,
      longitude: longitude,
    )) {
      return const AppError(
        ValidationFailure(
          message: 'Invalid coordinate values.',
          code: 'invalid_coordinates',
        ),
      );
    }

    try {
      final query = Uri.encodeComponent('$latitude,$longitude');
      final uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$query',
      );
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        _logger.warn(
          'Failed to open directions.',
          context: {'latitude': latitude, 'longitude': longitude},
        );
        return const AppError(
          UnknownFailure(
            message: 'Unable to open map application.',
            code: 'map_launch_failed',
          ),
        );
      }
    } catch (error, stackTrace) {
      _logger.error(
        'Directions action threw an exception.',
        error: error,
        stackTrace: stackTrace,
        context: {'latitude': latitude, 'longitude': longitude},
      );
      return const AppError(
        UnknownFailure(
          message: 'Unable to open map application.',
          code: 'map_launch_exception',
        ),
      );
    }

    return const AppSuccess<void>(null);
  }
}
