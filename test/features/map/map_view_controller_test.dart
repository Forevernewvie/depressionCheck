import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:vibemental_app/core/config/app_env.dart';
import 'package:vibemental_app/core/errors/app_failure.dart';
import 'package:vibemental_app/core/logging/app_logger.dart';
import 'package:vibemental_app/core/result/app_result.dart';
import 'package:vibemental_app/features/map/application/location_service.dart';
import 'package:vibemental_app/features/map/application/map_view_controller.dart';
import 'package:vibemental_app/features/map/application/map_view_state.dart';
import 'package:vibemental_app/features/map/application/models/nearby_clinic_load_result.dart';
import 'package:vibemental_app/features/map/application/nearby_clinic_service.dart';
import 'package:vibemental_app/features/map/data/clinic_repository.dart';
import 'package:vibemental_app/features/map/domain/clinic.dart';
import 'package:vibemental_app/features/map/presentation/map_presentation_policy.dart';

class _SilentLogger implements AppLogger {
  @override
  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?> context = const {},
  }) {}

  @override
  void info(String message, {Map<String, Object?> context = const {}}) {}

  @override
  void warn(String message, {Map<String, Object?> context = const {}}) {}
}

class _UnusedClinicRepository implements ClinicRepository {
  @override
  Future<AppResult<List<Clinic>>> getNearbyClinics({
    required double latitude,
    required double longitude,
    int radiusMeters = AppEnv.defaultClinicSearchRadiusMeters,
  }) async {
    return const AppSuccess(<Clinic>[]);
  }
}

class _StubLocationService implements LocationService {
  _StubLocationService({this.openSettingsResult = true});

  final bool openSettingsResult;
  int openSettingsCalls = 0;

  @override
  Future<AppResult<Position>> getCurrentPosition() async {
    return const AppError(
      PermissionFailure(
        message: 'Location permission denied.',
        code: 'location_denied',
      ),
    );
  }

  @override
  Future<bool> openAppSettings() async {
    openSettingsCalls += 1;
    return openSettingsResult;
  }
}

class _SequencedNearbyClinicService extends NearbyClinicService {
  _SequencedNearbyClinicService(this._results)
    : super(
        locationService: _StubLocationService(),
        repository: _UnusedClinicRepository(),
        logger: _SilentLogger(),
      );

  final List<NearbyClinicLoadResult> _results;
  int loadCalls = 0;

  @override
  Future<NearbyClinicLoadResult> loadNearbyClinics() async {
    final currentIndex = loadCalls < _results.length
        ? loadCalls
        : _results.length - 1;
    loadCalls += 1;
    return _results[currentIndex];
  }
}

void main() {
  test('loadNearby stores normalized clinic payload in view state', () async {
    const clinic = Clinic(
      name: 'Calm Care Clinic',
      latitude: 37.5665,
      longitude: 126.9780,
      category: 'Mental Health Clinic',
      distanceMeters: 320,
      specialistAvailability: ClinicSpecialistAvailability.available,
      openNow: true,
    );

    final controller = MapViewController(
      _SequencedNearbyClinicService(const [
        NearbyClinicLoadResult(
          center: LatLng(37.5665, 126.9780),
          clinics: <Clinic>[clinic],
          status: NearbyClinicStatus.realtimeLoaded,
        ),
      ]),
      _StubLocationService(),
      _SilentLogger(),
    );

    await controller.loadNearby();

    expect(controller.state.isLoading, isFalse);
    expect(controller.state.currentLocation, const LatLng(37.5665, 126.9780));
    expect(controller.state.clinics, const <Clinic>[clinic]);
    expect(controller.state.lastStatus, NearbyClinicStatus.realtimeLoaded);
  });

  test(
    'handlePrimaryAction opens settings when permission is denied forever',
    () async {
      final locationService = _StubLocationService(openSettingsResult: true);
      final service = _SequencedNearbyClinicService(const [
        NearbyClinicLoadResult(
          center: LatLng(37.5665, 126.9780),
          clinics: <Clinic>[],
          status: NearbyClinicStatus.permissionDeniedForever,
        ),
      ]);
      final controller = MapViewController(
        service,
        locationService,
        _SilentLogger(),
      );

      controller.setSortOption(ClinicSortOption.specialist);
      controller.setContentMode(MapContentMode.listOnly);
      controller.setFilterOpenNowOnly(true);
      controller.setFilterSpecialistOnly(true);
      await controller.loadNearby();

      final didSucceed = await controller.handlePrimaryAction();

      expect(didSucceed, isTrue);
      expect(locationService.openSettingsCalls, 1);
      expect(controller.state.shouldReloadAfterSettingsReturn, isTrue);
      expect(controller.state.sortOption, ClinicSortOption.specialist);
      expect(controller.state.contentMode, MapContentMode.listOnly);
      expect(controller.state.hasActiveFilters, isTrue);
    },
  );

  test('handleAppResumed reloads once after returning from settings', () async {
    final locationService = _StubLocationService(openSettingsResult: true);
    final service = _SequencedNearbyClinicService(const [
      NearbyClinicLoadResult(
        center: LatLng(37.5665, 126.9780),
        clinics: <Clinic>[],
        status: NearbyClinicStatus.permissionDeniedForever,
      ),
      NearbyClinicLoadResult(
        center: LatLng(37.5665, 126.9780),
        clinics: <Clinic>[],
        status: NearbyClinicStatus.realtimeLoaded,
      ),
    ]);
    final controller = MapViewController(
      service,
      locationService,
      _SilentLogger(),
    );

    await controller.loadNearby();
    await controller.openLocationSettings();
    await controller.handleAppResumed();

    expect(service.loadCalls, 2);
    expect(controller.state.shouldReloadAfterSettingsReturn, isFalse);
    expect(controller.state.lastStatus, NearbyClinicStatus.realtimeLoaded);
  });
}
