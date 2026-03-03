import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vibemental_app/core/ads/ad_providers.dart';
import 'package:vibemental_app/core/errors/app_failure.dart';
import 'package:vibemental_app/core/logging/app_logger.dart';
import 'package:vibemental_app/core/logging/logging_providers.dart';
import 'package:vibemental_app/core/platform/external_action_providers.dart';
import 'package:vibemental_app/core/platform/external_action_service.dart';
import 'package:vibemental_app/core/result/app_result.dart';
import 'package:vibemental_app/core/theme/app_theme.dart';
import 'package:vibemental_app/features/home/presentation/home_screen.dart';
import 'package:vibemental_app/features/instruments/presentation/modules_screen.dart';
import 'package:vibemental_app/features/map/application/location_service.dart';
import 'package:vibemental_app/features/map/application/map_providers.dart';
import 'package:vibemental_app/features/map/data/clinic_repository.dart';
import 'package:vibemental_app/features/map/domain/clinic.dart';
import 'package:vibemental_app/features/map/presentation/map_screen.dart';
import 'package:vibemental_app/features/results/presentation/result_screen.dart';
import 'package:vibemental_app/features/safety/application/safety_providers.dart';
import 'package:vibemental_app/features/safety/data/safety_repository.dart';
import 'package:vibemental_app/features/safety/domain/safety_plan_data.dart';
import 'package:vibemental_app/features/safety/domain/trusted_contact.dart';
import 'package:vibemental_app/features/safety/presentation/safety_plan_screen.dart';
import 'package:vibemental_app/features/screening/domain/screening_result.dart';
import 'package:vibemental_app/features/screening/domain/severity.dart';
import 'package:vibemental_app/features/screening/presentation/phq2_screen.dart';
import 'package:vibemental_app/features/screening/presentation/phq9_screen.dart';
import 'package:vibemental_app/l10n/app_localizations.dart';

import '../../fakes/fake_ad_service.dart';

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

class _NoopExternalActionService implements ExternalActionService {
  @override
  Future<AppResult<void>> callPhone(String rawPhone) async {
    return const AppSuccess<void>(null);
  }

  @override
  Future<AppResult<void>> openDirections({
    required double latitude,
    required double longitude,
  }) async {
    return const AppSuccess<void>(null);
  }
}

class _FakeSafetyRepository implements SafetyRepository {
  SafetyPlanData _plan = const SafetyPlanData();
  final List<TrustedContact> _contacts = const <TrustedContact>[];

  @override
  void deleteContact(int id) {}

  @override
  SafetySnapshot readSnapshot() {
    return SafetySnapshot(plan: _plan, contacts: _contacts);
  }

  @override
  void savePlan(SafetyPlanData plan) {
    _plan = plan;
  }

  @override
  void upsertContact(TrustedContact contact) {}
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
    int radiusMeters = 5000,
  }) async {
    return const AppSuccess(<Clinic>[]);
  }
}

/// Purpose: Pump one screen with deterministic localization and provider
/// overrides.
Future<void> _pump(
  WidgetTester tester,
  Widget home, {
  List<Override> overrides = const <Override>[],
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: home,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

/// Purpose: Scroll through long screens so lazy-built bottom widgets can render.
Future<void> _scrollDownToBuildBottom(WidgetTester tester) async {
  final scrollable = find.byType(Scrollable);
  if (scrollable.evaluate().isEmpty) {
    return;
  }
  for (int attempt = 0; attempt < 8; attempt++) {
    await tester.drag(scrollable.first, const Offset(0, -500));
    await tester.pumpAndSettle();
  }
}

void main() {
  const homeAdKey = Key('fake_ad_homeBottomBanner');
  const modulesAdKey = Key('fake_ad_modulesBottomBanner');

  testWidgets('home screen renders ad placement', (tester) async {
    await _pump(
      tester,
      const HomeScreen(),
      overrides: <Override>[
        adServiceProvider.overrideWithValue(FakeAdService()),
      ],
    );

    await _scrollDownToBuildBottom(tester);
    expect(find.byKey(homeAdKey), findsOneWidget);
  });

  testWidgets('modules screen renders ad placement', (tester) async {
    await _pump(
      tester,
      const ModulesScreen(),
      overrides: <Override>[
        adServiceProvider.overrideWithValue(FakeAdService()),
      ],
    );

    await _scrollDownToBuildBottom(tester);
    expect(find.byKey(modulesAdKey), findsOneWidget);
  });

  testWidgets(
    'critical screening and safety screens do not render ad placement',
    (tester) async {
      final overrides = <Override>[
        adServiceProvider.overrideWithValue(FakeAdService()),
        appLoggerProvider.overrideWithValue(_SilentLogger()),
        externalActionServiceProvider.overrideWithValue(
          _NoopExternalActionService(),
        ),
        safetyRepositoryProvider.overrideWithValue(_FakeSafetyRepository()),
        locationServiceProvider.overrideWithValue(_DeniedLocationService()),
        clinicRepositoryProvider.overrideWithValue(_UnusedClinicRepository()),
      ];

      final screens = <Widget>[
        const Phq2Screen(),
        const Phq9Screen(),
        const ResultScreen(
          result: ScreeningResult(
            instrument: ScreeningInstrument.phq9,
            totalScore: 12,
            severity: SeverityLevel.moderate,
            urgentCare: false,
          ),
        ),
        const MapScreen(),
        const SafetyPlanScreen(),
      ];

      for (final screen in screens) {
        await _pump(tester, screen, overrides: overrides);
        expect(find.byKey(homeAdKey), findsNothing);
        expect(find.byKey(modulesAdKey), findsNothing);
      }
    },
  );
}
