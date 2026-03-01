import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:vibemental_app/core/errors/app_failure.dart';
import 'package:vibemental_app/core/network/retry_executor.dart';
import 'package:vibemental_app/core/result/app_result.dart';
import 'package:vibemental_app/features/map/data/overpass_clinic_repository.dart';
import 'package:vibemental_app/features/map/domain/clinic.dart';

import '../../fakes/test_app_logger.dart';

void main() {
  RetryExecutor retryOnce() {
    return const RetryExecutor(maxAttempts: 1, baseDelay: Duration.zero);
  }

  test('returns validation error for invalid coordinates', () async {
    final repository = OverpassClinicRepository(
      client: MockClient((_) async => http.Response('{}', 200)),
      logger: TestAppLogger(),
      retryExecutor: retryOnce(),
    );

    final result = await repository.getNearbyClinics(
      latitude: 99,
      longitude: 127,
    );

    expect(result, isA<AppError<List<Clinic>>>());
    final failure = (result as AppError<List<Clinic>>).failure;
    expect(failure, isA<ValidationFailure>());
    expect(failure.code, 'invalid_coordinates');
  });

  test('returns validation error for invalid search radius', () async {
    final repository = OverpassClinicRepository(
      client: MockClient((_) async => http.Response('{}', 200)),
      logger: TestAppLogger(),
      retryExecutor: retryOnce(),
    );

    final result = await repository.getNearbyClinics(
      latitude: 37.56,
      longitude: 126.97,
      radiusMeters: 10,
    );

    expect(result, isA<AppError<List<Clinic>>>());
    final failure = (result as AppError<List<Clinic>>).failure;
    expect(failure, isA<ValidationFailure>());
    expect(failure.code, 'invalid_radius');
  });

  test('returns network failure on non-200 response', () async {
    final repository = OverpassClinicRepository(
      client: MockClient((_) async => http.Response('server error', 500)),
      logger: TestAppLogger(),
      retryExecutor: retryOnce(),
    );

    final result = await repository.getNearbyClinics(
      latitude: 37.56,
      longitude: 126.97,
    );

    expect(result, isA<AppError<List<Clinic>>>());
    final failure = (result as AppError<List<Clinic>>).failure;
    expect(failure, isA<NetworkFailure>());
    expect(failure.code, 'overpass_http_error');
  });

  test('returns payload failure on malformed JSON shape', () async {
    final repository = OverpassClinicRepository(
      client: MockClient((_) async => http.Response('[]', 200)),
      logger: TestAppLogger(),
      retryExecutor: retryOnce(),
    );

    final result = await repository.getNearbyClinics(
      latitude: 37.56,
      longitude: 126.97,
    );

    expect(result, isA<AppError<List<Clinic>>>());
    final failure = (result as AppError<List<Clinic>>).failure;
    expect(failure, isA<NetworkFailure>());
    expect(failure.code, 'overpass_payload_invalid');
  });
}
