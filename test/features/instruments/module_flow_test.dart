import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vibemental_app/app/app.dart';
import 'package:vibemental_app/core/ads/ad_providers.dart';
import 'package:vibemental_app/core/config/app_routes.dart';
import 'package:vibemental_app/core/settings/app_settings.dart';
import 'package:vibemental_app/core/settings/data/app_preferences_repository.dart';
import 'package:vibemental_app/features/instruments/presentation/modules_screen.dart';
import 'package:vibemental_app/features/onboarding/presentation/splash_screen.dart';

import '../../fakes/fake_ad_service.dart';
import '../../fakes/fake_app_preferences_repository.dart';

void main() {
  /// Purpose: Pump the app with deterministic preferences to validate module
  /// routing behavior.
  Future<void> _pumpApp(WidgetTester tester) async {
    final repository = FakeAppPreferencesRepository(
      onboardingCompleted: true,
      languagePreference: LanguagePreference.en,
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appPreferencesRepositoryProvider.overrideWithValue(repository),
          adServiceProvider.overrideWithValue(FakeAdService()),
          splashDurationProvider.overrideWithValue(Duration.zero),
        ],
        child: const MindCheckApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('restricted modules are hidden from module list', (tester) async {
    await _pumpApp(tester);

    await tester.tap(find.byTooltip('Browse Modules'));
    await tester.pumpAndSettle();

    expect(find.text('PHQ-2'), findsOneWidget);
    expect(find.text('PHQ-9 / PHQ-A'), findsOneWidget);
    expect(find.text('HADS-D'), findsNothing);
    expect(find.text('CES-D'), findsNothing);
    expect(find.text('BDI-II'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('restricted direct routes show unavailable notice', (
    tester,
  ) async {
    await _pumpApp(tester);

    await tester.tap(find.byTooltip('Browse Modules'));
    await tester.pumpAndSettle();

    final modulesContext = tester.element(find.byType(ModulesScreen));
    GoRouter.of(modulesContext).go(AppRoutes.hadsD);
    await tester.pumpAndSettle();

    expect(find.text('HADS-D'), findsAtLeastNWidgets(1));
    expect(
      find.text(
        'Licensed content required: do not expose full copyrighted items without rights.',
      ),
      findsOneWidget,
    );
    expect(find.text('Back to modules'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
