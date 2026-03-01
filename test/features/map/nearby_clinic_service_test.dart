import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:vibemental_app/core/config/app_env.dart';
import 'package:vibemental_app/core/errors/app_failure.dart';
import 'package:vibemental_app/core/result/app_result.dart';
import 'package:vibemental_app/features/map/application/location_service.dart';
import 'package:vibemental_app/features/map/application/models/nearby_clinic_load_result.dart';
import 'package:vibemental_app/features/map/application/nearby_clinic_service.dart';
import 'package:vibemental_app/features/map/data/clinic_repository.dart';
import 'package:vibemental_app/features/map/domain/clinic.dart';

import '../../fakes/test_app_logger.dart';

class _FakeLocationService implements LocationService {
  _FakeLocationService(this.result);

  final AppResult<Position> result;

  @override
  Future<AppResult<Position>> getCurrentPosition() async => result;
}

class _FakeClinicRepository implements ClinicRepository {
  _FakeClinicRepository(this.result);

  final AppResult<List<Clinic>> result;

  @override
  Future<AppResult<List<Clinic>>> getNearbyClinics({
    required double latitude,
    required double longitude,
    int radiusMeters = AppEnv.defaultClinicSearchRadiusMeters,
  }) async {
    return result;
  }
}

Position _position({double latitude = 37.5665, double longitude = 126.9780}) {
  return Position(
    longitude: longitude,
    latitude: latitude,
    timestamp: DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
    accuracy: 1,
    altitude: 0,
    altitudeAccuracy: 1,
    heading: 0,
    headingAccuracy: 1,
    speed: 0,
    speedAccuracy: 1,
  );
}

void main() {
  test(
    'returns permission fallback when location permission is denied',
    () async {
      final service = NearbyClinicService(
        locationService: _FakeLocationService(
          const AppError(
            PermissionFailure(
              message: 'Location permission denied.',
              code: 'location_denied',
            ),
          ),
        ),
        repository: _FakeClinicRepository(const AppSuccess(<Clinic>[])),
        logger: TestAppLogger(),
      );

      final result = await service.loadNearbyClinics();

      expect(result.status, NearbyClinicStatus.permissionDenied);
      expect(result.center, const LatLng(37.5665, 126.978));
      expect(result.clinics, isNotEmpty);
    },
  );

  test('returns network fallback when clinic repository fails', () async {
    final service = NearbyClinicService(
      locationService: _FakeLocationService(AppSuccess(_position())),
      repository: _FakeClinicRepository(
        const AppError(
          NetworkFailure(
            message: 'Network error while querying clinics.',
            code: 'overpass_network_error',
          ),
        ),
      ),
      logger: TestAppLogger(),
    );

    final result = await service.loadNearbyClinics();

    expect(result.status, NearbyClinicStatus.networkFallback);
    expect(result.clinics, isNotEmpty);
  });

  test('returns realtime loaded when repository returns data', () async {
    const clinic = Clinic(
      name: 'Test Clinic',
      latitude: 37.5,
      longitude: 127.0,
      category: 'Psychiatry',
      distanceMeters: 200,
    );

    final service = NearbyClinicService(
      locationService: _FakeLocationService(AppSuccess(_position())),
      repository: _FakeClinicRepository(const AppSuccess([clinic])),
      logger: TestAppLogger(),
    );

    final result = await service.loadNearbyClinics();

    expect(result.status, NearbyClinicStatus.realtimeLoaded);
    expect(result.clinics, [clinic]);
  });
}
