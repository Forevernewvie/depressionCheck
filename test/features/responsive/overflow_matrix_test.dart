import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vibemental_app/core/config/app_env.dart';
import 'package:vibemental_app/core/errors/app_failure.dart';
import 'package:vibemental_app/core/logging/app_logger.dart';
import 'package:vibemental_app/core/logging/logging_providers.dart';
import 'package:vibemental_app/core/platform/external_action_providers.dart';
import 'package:vibemental_app/core/platform/external_action_service.dart';
import 'package:vibemental_app/core/result/app_result.dart';
import 'package:vibemental_app/core/settings/data/app_preferences_repository.dart';
import 'package:vibemental_app/core/theme/app_theme.dart';
import 'package:vibemental_app/features/checkin/data/checkin_repository.dart';
import 'package:vibemental_app/features/checkin/domain/daily_checkin_entry.dart';
import 'package:vibemental_app/features/checkin/presentation/checkin_screen.dart';
import 'package:vibemental_app/features/checkin/application/checkin_providers.dart';
import 'package:vibemental_app/features/map/application/location_service.dart';
import 'package:vibemental_app/features/map/application/map_providers.dart';
import 'package:vibemental_app/features/map/data/clinic_repository.dart';
import 'package:vibemental_app/features/map/domain/clinic.dart';
import 'package:vibemental_app/features/map/presentation/map_screen.dart';
import 'package:vibemental_app/features/safety/application/safety_providers.dart';
import 'package:vibemental_app/features/safety/data/safety_repository.dart';
import 'package:vibemental_app/features/safety/domain/safety_plan_data.dart';
import 'package:vibemental_app/features/safety/domain/trusted_contact.dart';
import 'package:vibemental_app/features/safety/presentation/safety_plan_screen.dart';
import 'package:vibemental_app/features/onboarding/presentation/onboarding_screen.dart';
import 'package:vibemental_app/features/results/presentation/result_screen.dart';
import 'package:vibemental_app/features/settings/presentation/settings_screen.dart';
import 'package:vibemental_app/features/screening/domain/screening_result.dart';
import 'package:vibemental_app/features/screening/domain/severity.dart';
import 'package:vibemental_app/l10n/app_localizations.dart';

import '../../fakes/fake_app_preferences_repository.dart';

const List<Size> _screenSizes = <Size>[
  Size(320, 568),
  Size(360, 800),
  Size(390, 844),
  Size(412, 915),
  Size(768, 1024),
  Size(1024, 768),
];

const List<double> _textScales = <double>[1.0, 1.3, 1.6];
const List<Locale> _locales = <Locale>[Locale('ko'), Locale('en')];

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

class _FakeCheckInRepository implements CheckInRepository {
  @override
  DailyCheckInEntry? readByDateKey(String localDateKey) => null;

  @override
  List<DailyCheckInEntry> readRecentEntries({required int days}) {
    return const <DailyCheckInEntry>[];
  }

  @override
  void saveEntry({
    required String localDateKey,
    required int mood,
    required int energy,
    required DateTime now,
    String? note,
  }) {}
}

class _FakeSafetyRepository implements SafetyRepository {
  _FakeSafetyRepository()
    : _contacts = <TrustedContact>[
        const TrustedContact(
          id: 1,
          name: 'Primary Person',
          relation: 'Family',
          phone: '+821012345678',
          isPrimary: true,
          sortOrder: 0,
        ),
      ];

  SafetyPlanData _plan = const SafetyPlanData();
  final List<TrustedContact> _contacts;

  @override
  void deleteContact(int id) {
    _contacts.removeWhere((item) => item.id == id);
  }

  @override
  SafetySnapshot readSnapshot() {
    return SafetySnapshot(
      plan: _plan,
      contacts: List<TrustedContact>.from(_contacts),
    );
  }

  @override
  void savePlan(SafetyPlanData plan) {
    _plan = plan;
  }

  @override
  void upsertContact(TrustedContact contact) {
    final index = _contacts.indexWhere((item) => item.id == contact.id);
    if (index >= 0) {
      _contacts[index] = contact;
      return;
    }
    _contacts.add(contact);
  }
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

ThemeData _themeForBrightness(Brightness brightness) {
  return brightness == Brightness.dark
      ? AppTheme.darkTheme
      : AppTheme.lightTheme;
}

String _scenarioLabel({
  required Size size,
  required Locale locale,
  required Brightness brightness,
  required double textScale,
}) {
  final theme = brightness == Brightness.dark ? 'dark' : 'light';
  return '${size.width.toInt()}x${size.height.toInt()} '
      '${locale.languageCode} $theme textScale=$textScale';
}

/// Purpose: Pump one screen in a deterministic responsive test configuration.
Future<void> _pumpScreenScenario(
  WidgetTester tester, {
  required Widget home,
  required Size size,
  required Locale locale,
  required Brightness brightness,
  required double textScale,
  double keyboardInsetBottom = 0,
  List<Override> overrides = const <Override>[],
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;

  await tester.pumpWidget(
    ProviderScope(
      key: UniqueKey(),
      overrides: overrides,
      child: MaterialApp(
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: _themeForBrightness(brightness),
        builder: (context, child) {
          final media = MediaQuery.of(context);
          return MediaQuery(
            data: media.copyWith(
              textScaler: TextScaler.linear(textScale),
              viewInsets: EdgeInsets.only(bottom: keyboardInsetBottom),
            ),
            child: child!,
          );
        },
        home: home,
      ),
    ),
  );

  await tester.pumpAndSettle();
}

/// Purpose: Assert that current frame contains no framework overflow exception.
void _expectNoFrameException(WidgetTester tester, String scenario) {
  final exception = tester.takeException();
  expect(
    exception,
    isNull,
    reason: 'Unexpected exception in scenario: $scenario',
  );
}

/// Purpose: Scroll long list content to validate off-screen sections safely.
Future<void> _scrollAndRecheck(WidgetTester tester, String scenario) async {
  final scrollableFinder = find.byType(Scrollable);
  if (scrollableFinder.evaluate().isEmpty) {
    return;
  }

  await tester.drag(scrollableFinder.first, const Offset(0, -700));
  await tester.pumpAndSettle();
  _expectNoFrameException(tester, '$scenario (after scroll)');
}

void main() {
  testWidgets('settings screen is overflow-safe across responsive matrix', (
    tester,
  ) async {
    final fakePrefs = FakeAppPreferencesRepository(onboardingCompleted: true);

    for (final size in _screenSizes) {
      for (final locale in _locales) {
        for (final brightness in Brightness.values) {
          for (final textScale in _textScales) {
            final scenario = _scenarioLabel(
              size: size,
              locale: locale,
              brightness: brightness,
              textScale: textScale,
            );

            await _pumpScreenScenario(
              tester,
              home: const SettingsScreen(),
              size: size,
              locale: locale,
              brightness: brightness,
              textScale: textScale,
              overrides: <Override>[
                appPreferencesRepositoryProvider.overrideWithValue(fakePrefs),
              ],
            );
            _expectNoFrameException(tester, scenario);
          }
        }
      }
    }
  });

  testWidgets('map screen is overflow-safe across responsive matrix', (
    tester,
  ) async {
    for (final size in _screenSizes) {
      for (final locale in _locales) {
        for (final brightness in Brightness.values) {
          for (final textScale in _textScales) {
            final scenario = _scenarioLabel(
              size: size,
              locale: locale,
              brightness: brightness,
              textScale: textScale,
            );

            await _pumpScreenScenario(
              tester,
              home: const MapScreen(),
              size: size,
              locale: locale,
              brightness: brightness,
              textScale: textScale,
              overrides: <Override>[
                appLoggerProvider.overrideWithValue(_SilentLogger()),
                locationServiceProvider.overrideWithValue(
                  _DeniedLocationService(),
                ),
                clinicRepositoryProvider.overrideWithValue(
                  _UnusedClinicRepository(),
                ),
              ],
            );
            _expectNoFrameException(tester, scenario);
            await _scrollAndRecheck(tester, scenario);
          }
        }
      }
    }
  });

  testWidgets('onboarding and result screens are overflow-safe in matrix', (
    tester,
  ) async {
    final fakePrefs = FakeAppPreferencesRepository(onboardingCompleted: false);
    const highRiskResult = ScreeningResult(
      instrument: ScreeningInstrument.phq9,
      totalScore: 20,
      severity: SeverityLevel.highRisk,
      selfHarmPositive: true,
      urgentCare: true,
    );

    for (final size in _screenSizes) {
      for (final locale in _locales) {
        for (final brightness in Brightness.values) {
          for (final textScale in _textScales) {
            final scenario = _scenarioLabel(
              size: size,
              locale: locale,
              brightness: brightness,
              textScale: textScale,
            );

            await _pumpScreenScenario(
              tester,
              home: const OnboardingScreen(),
              size: size,
              locale: locale,
              brightness: brightness,
              textScale: textScale,
              overrides: <Override>[
                appPreferencesRepositoryProvider.overrideWithValue(fakePrefs),
              ],
            );
            _expectNoFrameException(tester, '$scenario onboarding');
            await _scrollAndRecheck(tester, '$scenario onboarding');

            await _pumpScreenScenario(
              tester,
              home: const ResultScreen(result: highRiskResult),
              size: size,
              locale: locale,
              brightness: brightness,
              textScale: textScale,
            );
            _expectNoFrameException(tester, '$scenario result');
            await _scrollAndRecheck(tester, '$scenario result');
          }
        }
      }
    }
  });

  testWidgets('check-in and safety-plan screens are overflow-safe in matrix', (
    tester,
  ) async {
    for (final size in _screenSizes) {
      for (final locale in _locales) {
        for (final brightness in Brightness.values) {
          for (final textScale in _textScales) {
            final scenario = _scenarioLabel(
              size: size,
              locale: locale,
              brightness: brightness,
              textScale: textScale,
            );

            await _pumpScreenScenario(
              tester,
              home: const CheckInScreen(),
              size: size,
              locale: locale,
              brightness: brightness,
              textScale: textScale,
              keyboardInsetBottom: 280,
              overrides: <Override>[
                appLoggerProvider.overrideWithValue(_SilentLogger()),
                checkInRepositoryProvider.overrideWithValue(
                  _FakeCheckInRepository(),
                ),
              ],
            );
            await _focusFirstTextFieldIfPresent(tester);
            _expectNoFrameException(tester, '$scenario check-in');
            await _scrollAndRecheck(tester, '$scenario check-in');

            await _pumpScreenScenario(
              tester,
              home: const SafetyPlanScreen(),
              size: size,
              locale: locale,
              brightness: brightness,
              textScale: textScale,
              keyboardInsetBottom: 280,
              overrides: <Override>[
                appLoggerProvider.overrideWithValue(_SilentLogger()),
                safetyRepositoryProvider.overrideWithValue(
                  _FakeSafetyRepository(),
                ),
                externalActionServiceProvider.overrideWithValue(
                  _NoopExternalActionService(),
                ),
              ],
            );
            await _focusFirstTextFieldIfPresent(tester);
            _expectNoFrameException(tester, '$scenario safety');
            await _scrollAndRecheck(tester, '$scenario safety');
          }
        }
      }
    }
  });
}

/// Purpose: Focus input safely when present to emulate keyboard-open layout.
Future<void> _focusFirstTextFieldIfPresent(WidgetTester tester) async {
  final textFieldFinder = find.byType(TextField);
  if (textFieldFinder.evaluate().isEmpty) {
    return;
  }
  await tester.tap(textFieldFinder.first, warnIfMissed: false);
  await tester.pumpAndSettle();
}
