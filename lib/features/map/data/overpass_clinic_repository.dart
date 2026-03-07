import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vibemental_app/core/config/app_env.dart';
import 'package:vibemental_app/core/logging/app_logger.dart';
import 'package:vibemental_app/core/network/retry_executor.dart';
import 'package:vibemental_app/core/result/app_result.dart';
import 'package:vibemental_app/core/security/input_validator.dart';
import 'package:vibemental_app/features/map/data/clinic_repository.dart';
import 'package:vibemental_app/features/map/data/overpass/overpass_clinic_parser.dart';
import 'package:vibemental_app/features/map/data/overpass/overpass_failures.dart';
import 'package:vibemental_app/features/map/data/overpass/overpass_query_builder.dart';
import 'package:vibemental_app/features/map/domain/clinic.dart';

/// Purpose: Load nearby clinic/hospital data from Overpass API with robust
/// validation, timeout, retry, and typed failures.
class OverpassClinicRepository implements ClinicRepository {
  OverpassClinicRepository({
    required http.Client client,
    required AppLogger logger,
    RetryExecutor? retryExecutor,
    OverpassQueryBuilder? queryBuilder,
    OverpassClinicParser? parser,
  }) : _client = client,
       _logger = logger,
       _queryBuilder = queryBuilder ?? const OverpassQueryBuilder(),
       _parser = parser ?? OverpassClinicParser(),
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
  final OverpassQueryBuilder _queryBuilder;
  final OverpassClinicParser _parser;
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
        AppError<List<Clinic>>(OverpassFailures.invalidCoordinates()),
      );
    }

    /// Purpose: Ensure radius respects safe upper/lower limits.
    if (!InputValidator.isValidRadius(radiusMeters)) {
      return Future.value(
        AppError<List<Clinic>>(OverpassFailures.invalidRadius()),
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
    final endpoint = _readValidatedEndpoint();
    if (endpoint == null) {
      return AppError(OverpassFailures.invalidEndpoint());
    }

    final query = _queryBuilder.buildNearbyClinicQuery(
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
        return AppError(OverpassFailures.httpError(response.statusCode));
      }

      final decoded = _decodePayload(response.body);
      if (decoded == null) {
        return AppError(OverpassFailures.invalidPayload());
      }

      final clinics = _parser.parseNearbyClinics(
        payload: decoded,
        originLatitude: latitude,
        originLongitude: longitude,
        maxResults: AppEnv.defaultClinicSearchMaxResults,
      );

      return AppSuccess(clinics);
    } catch (error, stackTrace) {
      _logger.error(
        'Overpass query exception.',
        error: error,
        stackTrace: stackTrace,
        context: {'radiusMeters': radiusMeters},
      );
      return AppError(OverpassFailures.networkError());
    }
  }

  /// Purpose: Validate endpoint configuration once before hitting the network.
  Uri? _readValidatedEndpoint() {
    final endpoint = Uri.tryParse(AppEnv.overpassEndpoint);
    if (endpoint == null || endpoint.scheme != 'https') {
      return null;
    }
    return endpoint;
  }

  /// Purpose: Decode payload into a map or reject malformed response shapes.
  Map<String, dynamic>? _decodePayload(String body) {
    final decoded = jsonDecode(body);
    if (decoded is! Map<String, dynamic>) {
      return null;
    }
    return decoded;
  }
}
