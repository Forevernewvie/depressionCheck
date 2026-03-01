import 'package:vibemental_app/core/config/map_config.dart';

/// Purpose: Offer reusable validation helpers for user and network input.
class InputValidator {
  const InputValidator._();

  /// Purpose: Validate geographic coordinates before external calls.
  static bool isValidCoordinate({
    required double latitude,
    required double longitude,
  }) {
    final validLat =
        latitude >= MapConfig.validMinLatitude &&
        latitude <= MapConfig.validMaxLatitude;
    final validLng =
        longitude >= MapConfig.validMinLongitude &&
        longitude <= MapConfig.validMaxLongitude;
    return validLat && validLng;
  }

  /// Purpose: Validate clinic search radius bounds.
  static bool isValidRadius(int radiusMeters) {
    return radiusMeters >= MapConfig.minSearchRadiusMeters &&
        radiusMeters <= MapConfig.maxSearchRadiusMeters;
  }

  /// Purpose: Normalize phone numbers by allowing only dial-safe characters.
  static String sanitizePhoneNumber(String raw) {
    return raw.replaceAll(RegExp(r'[^0-9+]'), '');
  }
}
