/// Purpose: Centralize compile-time environment configuration loaded via
/// `--dart-define` for runtime behavior without code changes.
class AppEnv {
  AppEnv._();

  /// Purpose: Set a user-visible app name for platform wrappers and debug logs.
  static const String appName = String.fromEnvironment(
    'APP_NAME',
    defaultValue: 'Mind Check',
  );

  /// Purpose: Control external clinic lookup endpoint for OSM Overpass queries.
  static const String overpassEndpoint = String.fromEnvironment(
    'OVERPASS_ENDPOINT',
    defaultValue: 'https://overpass-api.de/api/interpreter',
  );

  /// Purpose: Configure OSM tile endpoint so deployments can swap tile
  /// providers without code changes.
  static const String osmTileUrlTemplate = String.fromEnvironment(
    'OSM_TILE_URL_TEMPLATE',
    defaultValue: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  );

  /// Purpose: Configure map tile user-agent package identifier for platform
  /// compatibility and runtime overrides.
  static const String mapUserAgentPackage = String.fromEnvironment(
    'MAP_USER_AGENT_PACKAGE',
    defaultValue: 'com.example.vibemental_app',
  );

  /// Purpose: Configure network timeout to prevent long hanging HTTP calls.
  static const int clinicSearchTimeoutMs = int.fromEnvironment(
    'CLINIC_SEARCH_TIMEOUT_MS',
    defaultValue: 18000,
  );

  /// Purpose: Configure retry attempts for transient network failures.
  static const int clinicSearchMaxAttempts = int.fromEnvironment(
    'CLINIC_SEARCH_MAX_ATTEMPTS',
    defaultValue: 3,
  );

  /// Purpose: Configure exponential-backoff seed delay in milliseconds.
  static const int clinicSearchBaseBackoffMs = int.fromEnvironment(
    'CLINIC_SEARCH_BASE_BACKOFF_MS',
    defaultValue: 400,
  );

  /// Purpose: Default search radius in meters for nearby clinic lookup.
  static const int defaultClinicSearchRadiusMeters = int.fromEnvironment(
    'CLINIC_SEARCH_RADIUS_METERS',
    defaultValue: 5000,
  );

  /// Purpose: Upper bound of returned clinic records for list/map rendering.
  static const int defaultClinicSearchMaxResults = int.fromEnvironment(
    'CLINIC_SEARCH_MAX_RESULTS',
    defaultValue: 12,
  );

  /// Purpose: Emergency call number used in high-risk flows.
  static const String emergencyPhone = String.fromEnvironment(
    'EMERGENCY_PHONE',
    defaultValue: '911',
  );

  /// Purpose: Crisis support phone number used in high-risk flows.
  static const String crisisPhone = String.fromEnvironment(
    'CRISIS_PHONE',
    defaultValue: '988',
  );

  /// Purpose: Enable/disable remote clinic lookup for offline demos and tests.
  static const bool enableRemoteClinicLookup = bool.fromEnvironment(
    'ENABLE_REMOTE_CLINIC_LOOKUP',
    defaultValue: true,
  );
}
