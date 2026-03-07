import 'package:vibemental_app/core/errors/app_failure.dart';

/// Purpose: Centralize map/Overpass failure creation so repository logic stays
/// focused on control flow instead of repeated literals.
class OverpassFailures {
  const OverpassFailures._();

  /// Purpose: Build failure for invalid coordinate requests.
  static ValidationFailure invalidCoordinates() {
    return const ValidationFailure(
      message: 'Invalid latitude/longitude.',
      code: 'invalid_coordinates',
    );
  }

  /// Purpose: Build failure for invalid radius requests.
  static ValidationFailure invalidRadius() {
    return const ValidationFailure(
      message: 'Invalid search radius.',
      code: 'invalid_radius',
    );
  }

  /// Purpose: Build failure for invalid endpoint configuration.
  static ValidationFailure invalidEndpoint() {
    return const ValidationFailure(
      message: 'OVERPASS_ENDPOINT must be a valid https URL.',
      code: 'invalid_endpoint',
    );
  }

  /// Purpose: Build failure for non-success HTTP responses.
  static NetworkFailure httpError(int statusCode) {
    return NetworkFailure(
      message: 'Overpass request failed.',
      code: 'overpass_http_error',
      statusCode: statusCode,
    );
  }

  /// Purpose: Build failure for invalid payload shapes.
  static NetworkFailure invalidPayload() {
    return const NetworkFailure(
      message: 'Unexpected response payload shape.',
      code: 'overpass_payload_invalid',
    );
  }

  /// Purpose: Build failure for transport/runtime failures.
  static NetworkFailure networkError() {
    return const NetworkFailure(
      message: 'Network error while querying clinics.',
      code: 'overpass_network_error',
    );
  }
}
