import 'package:vibemental_app/core/errors/app_failure.dart';

/// Purpose: Centralize failure construction for external platform actions so
/// codes/messages stay consistent and testable.
class ExternalActionFailures {
  const ExternalActionFailures._();

  /// Purpose: Build validation failure for malformed phone numbers.
  static ValidationFailure invalidPhone() {
    return const ValidationFailure(
      message: 'Invalid phone number.',
      code: 'invalid_phone',
    );
  }

  /// Purpose: Build validation failure for invalid coordinates.
  static ValidationFailure invalidCoordinates() {
    return const ValidationFailure(
      message: 'Invalid coordinate values.',
      code: 'invalid_coordinates',
    );
  }

  /// Purpose: Build validation failure for invalid directions endpoint setup.
  static ValidationFailure invalidDirectionsEndpoint() {
    return const ValidationFailure(
      message: 'Invalid directions endpoint configuration.',
      code: 'invalid_directions_endpoint',
    );
  }

  /// Purpose: Build unknown failure when dialer launch returns false.
  static UnknownFailure dialerFailed() {
    return const UnknownFailure(
      message: 'Unable to open phone dialer.',
      code: 'dialer_failed',
    );
  }

  /// Purpose: Build unknown failure when dialer action throws.
  static UnknownFailure dialerException() {
    return const UnknownFailure(
      message: 'Unable to open phone dialer.',
      code: 'dialer_exception',
    );
  }

  /// Purpose: Build unknown failure when map launch returns false.
  static UnknownFailure mapLaunchFailed() {
    return const UnknownFailure(
      message: 'Unable to open map application.',
      code: 'map_launch_failed',
    );
  }

  /// Purpose: Build unknown failure when map action throws.
  static UnknownFailure mapLaunchException() {
    return const UnknownFailure(
      message: 'Unable to open map application.',
      code: 'map_launch_exception',
    );
  }
}
