import 'package:url_launcher/url_launcher.dart';
import 'package:vibemental_app/core/config/app_env.dart';
import 'package:vibemental_app/core/config/external_action_config.dart';
import 'package:vibemental_app/core/errors/app_failure.dart';
import 'package:vibemental_app/core/logging/app_logger.dart';
import 'package:vibemental_app/core/platform/external_action_failures.dart';
import 'package:vibemental_app/core/platform/url_launcher_gateway.dart';
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
  UrlLauncherExternalActionService({
    required AppLogger logger,
    required UrlLauncherGateway launcher,
  }) : _logger = logger,
       _launcher = launcher;

  final AppLogger _logger;
  final UrlLauncherGateway _launcher;

  @override
  Future<AppResult<void>> callPhone(String rawPhone) async {
    final phoneUri = _buildPhoneUri(rawPhone);
    if (phoneUri == null) {
      return AppError(ExternalActionFailures.invalidPhone());
    }

    try {
      final launched = await _launcher.launch(phoneUri);
      if (!launched) {
        _logger.warn('Failed to launch dialer.', context: {'action': 'phone'});
        return AppError(ExternalActionFailures.dialerFailed());
      }
    } catch (error, stackTrace) {
      _logger.error(
        'Dialer action threw an exception.',
        error: error,
        stackTrace: stackTrace,
        context: {'action': 'phone'},
      );
      return AppError(ExternalActionFailures.dialerException());
    }

    return const AppSuccess<void>(null);
  }

  @override
  Future<AppResult<void>> openDirections({
    required double latitude,
    required double longitude,
  }) async {
    final directionsUri = _buildDirectionsUri(
      latitude: latitude,
      longitude: longitude,
    );
    if (directionsUri == null) {
      return AppError(_resolveDirectionsFailure(latitude, longitude));
    }

    try {
      final launched = await _launcher.launch(
        directionsUri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        _logger.warn(
          'Failed to open directions.',
          context: {'action': 'directions'},
        );
        return AppError(ExternalActionFailures.mapLaunchFailed());
      }
    } catch (error, stackTrace) {
      _logger.error(
        'Directions action threw an exception.',
        error: error,
        stackTrace: stackTrace,
        context: {'action': 'directions'},
      );
      return AppError(ExternalActionFailures.mapLaunchException());
    }

    return const AppSuccess<void>(null);
  }

  /// Purpose: Build a validated phone URI from user-visible phone input.
  Uri? _buildPhoneUri(String rawPhone) {
    final sanitized = InputValidator.sanitizePhoneNumber(rawPhone);
    if (!_isValidSanitizedPhone(sanitized)) {
      return null;
    }

    return Uri(scheme: ExternalActionConfig.dialerScheme, path: sanitized);
  }

  /// Purpose: Enforce sane phone bounds after removing non-dial-safe chars.
  bool _isValidSanitizedPhone(String sanitized) {
    final digitsOnly = sanitized.replaceAll('+', '');
    return digitsOnly.length >= ExternalActionConfig.minPhoneDigits &&
        digitsOnly.length <= ExternalActionConfig.maxPhoneDigits;
  }

  /// Purpose: Build a validated directions URI from secure configuration and
  /// sanitized coordinates.
  Uri? _buildDirectionsUri({
    required double latitude,
    required double longitude,
  }) {
    if (!InputValidator.isValidCoordinate(
      latitude: latitude,
      longitude: longitude,
    )) {
      return null;
    }

    final endpoint = Uri.tryParse(AppEnv.directionsEndpoint);
    if (endpoint == null ||
        endpoint.host.isEmpty ||
        !ExternalActionConfig.allowedDirectionSchemes.contains(
          endpoint.scheme,
        )) {
      return null;
    }

    final queryValue =
        '${latitude.toStringAsFixed(ExternalActionConfig.coordinatePrecision)},'
        '${longitude.toStringAsFixed(ExternalActionConfig.coordinatePrecision)}';

    return endpoint.replace(
      queryParameters: <String, String>{
        ...endpoint.queryParameters,
        ExternalActionConfig.directionsApiQueryKey:
            ExternalActionConfig.directionsApiQueryValue,
        ExternalActionConfig.directionsLocationQueryKey: queryValue,
      },
    );
  }

  /// Purpose: Resolve the most specific typed failure for directions requests.
  AppFailure _resolveDirectionsFailure(double latitude, double longitude) {
    if (!InputValidator.isValidCoordinate(
      latitude: latitude,
      longitude: longitude,
    )) {
      return ExternalActionFailures.invalidCoordinates();
    }
    return ExternalActionFailures.invalidDirectionsEndpoint();
  }
}
