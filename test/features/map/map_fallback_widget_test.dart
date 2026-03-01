import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vibemental_app/core/config/app_env.dart';
import 'package:vibemental_app/core/errors/app_failure.dart';
import 'package:vibemental_app/core/logging/app_logger.dart';
import 'package:vibemental_app/core/logging/logging_providers.dart';
import 'package:vibemental_app/core/result/app_result.dart';
import 'package:vibemental_app/features/map/application/location_service.dart';
import 'package:vibemental_app/features/map/application/map_providers.dart';
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
}
