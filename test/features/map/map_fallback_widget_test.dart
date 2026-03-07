import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:vibemental_app/core/config/app_env.dart';
import 'package:vibemental_app/core/errors/app_failure.dart';
import 'package:vibemental_app/core/logging/app_logger.dart';
import 'package:vibemental_app/core/logging/logging_providers.dart';
import 'package:vibemental_app/core/result/app_result.dart';
import 'package:vibemental_app/features/map/application/location_service.dart';
import 'package:vibemental_app/features/map/application/models/nearby_clinic_load_result.dart';
import 'package:vibemental_app/features/map/application/map_providers.dart';
import 'package:vibemental_app/features/map/application/nearby_clinic_service.dart';
import 'package:vibemental_app/features/map/data/clinic_repository.dart';
import 'package:vibemental_app/features/map/domain/clinic.dart';
import 'package:vibemental_app/features/map/presentation/map_screen.dart';
import 'package:vibemental_app/l10n/app_localizations.dart';

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

class _DeniedLocationService implements LocationService {
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
  Future<bool> openAppSettings() async => true;
}

class _DeniedForeverLocationService implements LocationService {
  int openSettingsCalls = 0;

  @override
  Future<AppResult<Position>> getCurrentPosition() async {
    return const AppError(
      PermissionFailure(
        message: 'Location permission denied forever.',
        code: 'location_denied_forever',
      ),
    );
  }

  @override
  Future<bool> openAppSettings() async {
    openSettingsCalls += 1;
    return true;
  }
}

class _SettingsRecoveryLocationService implements LocationService {
  int openSettingsCalls = 0;

  @override
  Future<AppResult<Position>> getCurrentPosition() async {
    return const AppError(
      PermissionFailure(
        message: 'Location permission denied forever.',
        code: 'location_denied_forever',
      ),
    );
  }

  @override
  Future<bool> openAppSettings() async {
    openSettingsCalls += 1;
    return true;
  }
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

class _FakeNearbyClinicService extends NearbyClinicService {
  _FakeNearbyClinicService(this._result)
    : super(
        locationService: _DeniedLocationService(),
        repository: _UnusedClinicRepository(),
        logger: _SilentLogger(),
      );

  final NearbyClinicLoadResult _result;

  @override
  Future<NearbyClinicLoadResult> loadNearbyClinics() async {
    return _result;
  }
}

class _SequencedNearbyClinicService extends NearbyClinicService {
  _SequencedNearbyClinicService(this._results)
    : super(
        locationService: _DeniedLocationService(),
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
  testWidgets(
    'map screen shows fallback status and clinics when location denied',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appLoggerProvider.overrideWithValue(_SilentLogger()),
            locationServiceProvider.overrideWithValue(_DeniedLocationService()),
            clinicRepositoryProvider.overrideWithValue(
              _UnusedClinicRepository(),
            ),
          ],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const MapScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('Location permission denied. Showing fallback clinic list.'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('map screen explains when filters hide all loaded clinics', (
    tester,
  ) async {
    const clinic = Clinic(
      name: 'Calm Care Clinic',
      latitude: 37.5665,
      longitude: 126.9780,
      category: 'Mental Health Clinic',
      distanceMeters: 320,
      specialistAvailability: ClinicSpecialistAvailability.unavailable,
      openNow: true,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appLoggerProvider.overrideWithValue(_SilentLogger()),
          nearbyClinicServiceProvider.overrideWithValue(
            _FakeNearbyClinicService(
              const NearbyClinicLoadResult(
                center: LatLng(37.5665, 126.9780),
                clinics: <Clinic>[clinic],
                status: NearbyClinicStatus.realtimeLoaded,
              ),
            ),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const MapScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Specialist only'), findsOneWidget);

    await tester.tap(find.text('Specialist only'));
    await tester.pumpAndSettle();

    final emptyStateMessage = find.text(
      'No clinics match the current filters. Try removing a filter.',
    );
    await tester.scrollUntilVisible(
      emptyStateMessage,
      300,
      scrollable: find.byType(Scrollable).first,
    );

    expect(emptyStateMessage, findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'map screen offers system settings recovery when permission is denied forever',
    (tester) async {
      final locationService = _DeniedForeverLocationService();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appLoggerProvider.overrideWithValue(_SilentLogger()),
            locationServiceProvider.overrideWithValue(locationService),
            clinicRepositoryProvider.overrideWithValue(
              _UnusedClinicRepository(),
            ),
          ],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const MapScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Open System Settings'), findsOneWidget);
      expect(
        find.text(
          'Location permission permanently denied. Enable it in system settings.',
        ),
        findsWidgets,
      );

      await tester.tap(find.text('Open System Settings'));
      await tester.pumpAndSettle();

      expect(locationService.openSettingsCalls, 1);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'map screen reloads nearby clinics after returning from system settings',
    (tester) async {
      const recoveredClinic = Clinic(
        name: 'Recovery Mind Clinic',
        latitude: 37.5665,
        longitude: 126.9780,
        category: 'Mental Health Clinic',
        distanceMeters: 180,
        specialistAvailability: ClinicSpecialistAvailability.available,
        openNow: true,
      );
      final locationService = _SettingsRecoveryLocationService();
      final nearbyService = _SequencedNearbyClinicService(
        const <NearbyClinicLoadResult>[
          NearbyClinicLoadResult(
            center: LatLng(37.5665, 126.9780),
            clinics: <Clinic>[],
            status: NearbyClinicStatus.permissionDeniedForever,
          ),
          NearbyClinicLoadResult(
            center: LatLng(37.5665, 126.9780),
            clinics: <Clinic>[recoveredClinic],
            status: NearbyClinicStatus.realtimeLoaded,
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appLoggerProvider.overrideWithValue(_SilentLogger()),
            locationServiceProvider.overrideWithValue(locationService),
            nearbyClinicServiceProvider.overrideWithValue(nearbyService),
          ],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const MapScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Open System Settings'), findsOneWidget);
      expect(nearbyService.loadCalls, 1);

      await tester.tap(find.text('Open System Settings'));
      await tester.pumpAndSettle();

      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      await tester.pump();
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();

      expect(locationService.openSettingsCalls, 1);
      expect(nearbyService.loadCalls, 2);
      expect(find.text('Real-time nearby clinics loaded.'), findsOneWidget);
      expect(find.text('Refresh Nearby Results'), findsOneWidget);
      final recoveredClinicFinder = find.text('Recovery Mind Clinic');
      await tester.scrollUntilVisible(
        recoveredClinicFinder,
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(recoveredClinicFinder, findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
