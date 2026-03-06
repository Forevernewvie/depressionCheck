import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vibemental_app/core/config/app_routes.dart';
import 'package:vibemental_app/features/clinician/presentation/clinician_screen.dart';
import 'package:vibemental_app/features/home/presentation/home_screen.dart';
import 'package:vibemental_app/features/instruments/presentation/modules_screen.dart';
import 'package:vibemental_app/features/instruments/presentation/instrument_unavailable_screen.dart';
import 'package:vibemental_app/features/map/presentation/map_screen.dart';
import 'package:vibemental_app/features/onboarding/presentation/onboarding_screen.dart';
import 'package:vibemental_app/features/onboarding/presentation/splash_screen.dart';
import 'package:vibemental_app/features/results/presentation/result_screen.dart';
import 'package:vibemental_app/features/safety/presentation/safety_plan_screen.dart';
import 'package:vibemental_app/features/screening/domain/screening_result.dart';
import 'package:vibemental_app/features/screening/presentation/phq2_screen.dart';
import 'package:vibemental_app/features/screening/presentation/phq9_screen.dart';
import 'package:vibemental_app/features/settings/presentation/settings_screen.dart';
import 'package:vibemental_app/features/checkin/presentation/checkin_screen.dart';

/// Purpose: Build centralized router configuration for all app flows.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.phq2,
        builder: (context, state) => const Phq2Screen(),
      ),
      GoRoute(
        path: AppRoutes.phq9,
        builder: (context, state) => const Phq9Screen(),
      ),
      GoRoute(
        path: AppRoutes.result,
        builder: (context, state) {
          final result = state.extra is ScreeningResult
              ? state.extra! as ScreeningResult
              : ScreeningResult.fallback();
          return ResultScreen(result: result);
        },
      ),
      GoRoute(
        path: AppRoutes.map,
        builder: (context, state) => const MapScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.modules,
        builder: (context, state) => const ModulesScreen(),
      ),
      GoRoute(
        path: AppRoutes.hadsD,
        builder: (context, state) => const InstrumentUnavailableScreen(
          instrument: ScreeningInstrument.hadsD,
        ),
      ),
      GoRoute(
        path: AppRoutes.cesD,
        builder: (context, state) => const InstrumentUnavailableScreen(
          instrument: ScreeningInstrument.cesD,
        ),
      ),
      GoRoute(
        path: AppRoutes.bdi2,
        builder: (context, state) => const InstrumentUnavailableScreen(
          instrument: ScreeningInstrument.bdi2,
        ),
      ),
      GoRoute(
        path: AppRoutes.clinician,
        builder: (context, state) => const ClinicianScreen(),
      ),
      GoRoute(
        path: AppRoutes.checkIn,
        builder: (context, state) => const CheckInScreen(),
      ),
      GoRoute(
        path: AppRoutes.safetyPlan,
        builder: (context, state) => const SafetyPlanScreen(),
      ),
    ],
  );
});
