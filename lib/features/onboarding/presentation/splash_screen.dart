import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vibemental_app/core/config/app_routes.dart';
import 'package:vibemental_app/core/settings/onboarding_controller.dart';
import 'package:vibemental_app/l10n/app_localizations.dart';

/// Purpose: Configure splash screen delay to support test determinism.
final splashDurationProvider = Provider<Duration>(
  (ref) => const Duration(milliseconds: 1200),
);

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _navigate());
  }

  /// Purpose: Route from splash to onboarding/home based on persisted status.
  Future<void> _navigate() async {
    final duration = ref.read(splashDurationProvider);
    await Future<void>.delayed(duration);
    if (!mounted) {
      return;
    }

    final onboardingDone = ref.read(onboardingControllerProvider);
    context.go(onboardingDone ? AppRoutes.home : AppRoutes.onboarding);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        color: Theme.of(context).colorScheme.surface,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.appTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.notDiagnosis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            const LinearProgressIndicator(),
            const SizedBox(height: 10),
            Text(
              l10n.splashLoading,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
