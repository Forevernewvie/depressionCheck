import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:vibemental_app/core/config/app_env.dart';
import 'package:vibemental_app/core/errors/app_failure.dart';
import 'package:vibemental_app/core/logging/app_logger.dart';
import 'package:vibemental_app/core/network/retry_executor.dart';
import 'package:vibemental_app/core/result/app_result.dart';
import 'package:vibemental_app/core/security/input_validator.dart';
import 'package:vibemental_app/features/map/data/clinic_repository.dart';
import 'package:vibemental_app/features/map/domain/clinic.dart';

/// Purpose: Load nearby clinic/hospital data from Overpass API with robust
/// validation, timeout, retry, and typed failures.
class OverpassClinicRepository implements ClinicRepository {
  OverpassClinicRepository({
    required http.Client client,
    required AppLogger logger,
    RetryExecutor? retryExecutor,
  }) : _client = client,
       _logger = logger,
       _retryExecutor =
           retryExecutor ??
           RetryExecutor(
             maxAttempts: AppEnv.clinicSearchMaxAttempts,
             baseDelay: Duration(
               milliseconds: AppEnv.clinicSearchBaseBackoffMs,
             ),
           );

  final http.Client _client;
  final AppLogger _logger;
  final RetryExecutor _retryExecutor;

  @override
  Future<AppResult<List<Clinic>>> getNearbyClinics({
    required double latitude,
    required double longitude,
    int radiusMeters = AppEnv.defaultClinicSearchRadiusMeters,
  }) {
    /// Purpose: Validate the request arguments before reaching remote API.
    if (!InputValidator.isValidCoordinate(
      latitude: latitude,
      longitude: longitude,
    )) {
      return Future.value(
        const AppError<List<Clinic>>(
          ValidationFailure(
            message: 'Invalid latitude/longitude.',
            code: 'invalid_coordinates',
          ),
        ),
      );
    }

    /// Purpose: Ensure radius respects safe upper/lower limits.
    if (!InputValidator.isValidRadius(radiusMeters)) {
      return Future.value(
        const AppError<List<Clinic>>(
          ValidationFailure(
            message: 'Invalid search radius.',
            code: 'invalid_radius',
          ),
        ),
      );
    }

    return _retryExecutor.execute(
      () => _queryOverpass(
        latitude: latitude,
        longitude: longitude,
        radiusMeters: radiusMeters,
      ),
    );
  }

  /// Purpose: Execute one remote Overpass query with timeout and typed result.
  Future<AppResult<List<Clinic>>> _queryOverpass({
    required double latitude,
    required double longitude,
    required int radiusMeters,
  }) async {
    final endpoint = Uri.tryParse(AppEnv.overpassEndpoint);
    if (endpoint == null || endpoint.scheme != 'https') {
      return const AppError(
        ValidationFailure(
          message: 'OVERPASS_ENDPOINT must be a valid https URL.',
          code: 'invalid_endpoint',
        ),
      );
    }

    final query = _buildOverpassQuery(
      latitude: latitude,
      longitude: longitude,
      radiusMeters: radiusMeters,
    );

    try {
      final response = await _client
          .post(endpoint, body: {'data': query})
          .timeout(Duration(milliseconds: AppEnv.clinicSearchTimeoutMs));

      if (response.statusCode != 200) {
        _logger.warn(
          'Overpass request failed.',
          context: {
            'statusCode': response.statusCode,
            'radiusMeters': radiusMeters,
          },
        );
        return AppError(
          NetworkFailure(
            message: 'Overpass request failed.',
            code: 'overpass_http_error',
            statusCode: response.statusCode,
          ),
        );
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        return const AppError(
          NetworkFailure(
            message: 'Unexpected response payload shape.',
            code: 'overpass_payload_invalid',
          ),
        );
      }

      final clinics = _parseClinics(
        payload: decoded,
        latitude: latitude,
        longitude: longitude,
      );

      return AppSuccess(clinics);
    } catch (error, stackTrace) {
      _logger.error(
        'Overpass query exception.',
        error: error,
        stackTrace: stackTrace,
        context: {'radiusMeters': radiusMeters},
      );
      return const AppError(
        NetworkFailure(
          message: 'Network error while querying clinics.',
          code: 'overpass_network_error',
        ),
      );
    }
  }

  /// Purpose: Create OSM Overpass query string for hospitals and clinics.
  String _buildOverpassQuery({
    required double latitude,
    required double longitude,
    required int radiusMeters,
  }) {
    return '''
[out:json][timeout:25];
(
  node(around:$radiusMeters,$latitude,$longitude)["amenity"~"hospital|clinic"];
  way(around:$radiusMeters,$latitude,$longitude)["amenity"~"hospital|clinic"];
  relation(around:$radiusMeters,$latitude,$longitude)["amenity"~"hospital|clinic"];
);
out center 80;
''';
  }

  /// Purpose: Convert raw Overpass payload into validated, deduplicated clinic
  /// domain entities sorted by distance.
  List<Clinic> _parseClinics({
    required Map<String, dynamic> payload,
    required double latitude,
    required double longitude,
  }) {
    final elements = (payload['elements'] as List<dynamic>? ?? const []);
    final clinics = <Clinic>[];
    final seen = <String>{};

    for (final raw in elements) {
      if (raw is! Map<String, dynamic>) {
        continue;
      }

      final point = _readPoint(raw);
      if (point == null) {
        continue;
      }

      final tags = (raw['tags'] as Map<String, dynamic>? ?? const {});
      final name =
          (tags['name'] as String?) ??
          (tags['official_name'] as String?) ??
          'Unknown Clinic';
      final category =
          (tags['healthcare'] as String?) ??
          (tags['amenity'] as String?) ??
          'clinic';
      final phone =
          (tags['phone'] as String?) ?? (tags['contact:phone'] as String?);

      final dedupe =
          '$name|${point.$1.toStringAsFixed(5)}|${point.$2.toStringAsFixed(5)}';
      if (!seen.add(dedupe)) {
        continue;
      }

      final distance = Geolocator.distanceBetween(
        latitude,
        longitude,
        point.$1,
        point.$2,
      );

      clinics.add(
        Clinic(
          name: name,
          latitude: point.$1,
          longitude: point.$2,
          category: category,
          distanceMeters: distance,
          phone: phone,
          address: _composeAddress(tags),
        ),
      );
    }

    clinics.sort((a, b) => a.distanceMeters.compareTo(b.distanceMeters));
    return clinics
        .take(AppEnv.defaultClinicSearchMaxResults)
        .toList(growable: false);
  }

  /// Purpose: Extract coordinate pair from node or center geometry payload.
  (double, double)? _readPoint(Map<String, dynamic> element) {
    final lat = element['lat'];
    final lon = element['lon'];
    if (lat is num && lon is num) {
      return (lat.toDouble(), lon.toDouble());
    }

    final center = element['center'];
    if (center is Map<String, dynamic>) {
      final centerLat = center['lat'];
      final centerLon = center['lon'];
      if (centerLat is num && centerLon is num) {
        return (centerLat.toDouble(), centerLon.toDouble());
      }
    }

    return null;
  }

  /// Purpose: Assemble a human-readable address from optional OSM tag parts.
  String? _composeAddress(Map<String, dynamic> tags) {
    final street = tags['addr:street'] as String?;
    final number = tags['addr:housenumber'] as String?;
    final city = tags['addr:city'] as String?;

    final parts = <String>[];
    if (street != null && street.isNotEmpty) {
      parts.add(street);
    }
    if (number != null && number.isNotEmpty) {
      parts.add(number);
    }
    if (city != null && city.isNotEmpty) {
      parts.add(city);
    }

    if (parts.isEmpty) {
      return null;
    }
    return parts.join(', ');
  }
}
