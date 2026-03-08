import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vibemental_app/app/app.dart';
import 'package:vibemental_app/core/config/app_routes.dart';
import 'package:vibemental_app/core/ads/ad_providers.dart';
import 'package:vibemental_app/core/settings/app_settings.dart';
import 'package:vibemental_app/core/settings/data/app_preferences_repository.dart';
import 'package:vibemental_app/features/onboarding/presentation/splash_screen.dart';
import 'fakes/fake_app_preferences_repository.dart';
import 'fakes/fake_ad_service.dart';

void main() {
  late FakeAppPreferencesRepository repository;

  Future<void> pumpApp(
    WidgetTester tester, {
    Map<String, Object> initialPrefs = const {},
  }) async {
    repository = FakeAppPreferencesRepository(
      themePreference: initialPrefs['theme_preference'] == 'dark'
          ? ThemePreference.dark
          : initialPrefs['theme_preference'] == 'light'
          ? ThemePreference.light
          : ThemePreference.system,
      languagePreference: initialPrefs['language_preference'] == 'ko'
          ? LanguagePreference.ko
          : initialPrefs['language_preference'] == 'en'
          ? LanguagePreference.en
          : LanguagePreference.system,
      onboardingCompleted: initialPrefs['onboarding_completed'] != false,
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

  testWidgets('home to PHQ-2 flow works', (tester) async {
    await pumpApp(tester);

    final startButton = find.widgetWithText(FilledButton, 'Start Mild Screen');

    expect(find.text('Mind Check'), findsOneWidget);
    await tester.ensureVisible(startButton);
    await tester.pumpAndSettle();
    await tester.tap(startButton, warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(find.text('PHQ-2 Mild Screen'), findsOneWidget);
    expect(find.byType(BackButton), findsOneWidget);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    expect(find.text('Mind Check'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('home guide card tap also starts PHQ-2 flow', (tester) async {
    await pumpApp(tester);

    final guideTitle = find.text('Quick guide for first-time users');

    await tester.ensureVisible(guideTitle);
    await tester.tap(guideTitle, warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(find.text('PHQ-2 Mild Screen'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('settings changes are persisted', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('한국어'));
    await tester.pumpAndSettle();

    expect(repository.snapshot.themePreference, ThemePreference.dark);
    expect(repository.snapshot.languagePreference, LanguagePreference.ko);
  });

  testWidgets('settings opens privacy policy screen', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Privacy Policy'));
    await tester.pumpAndSettle();

    expect(find.text('Privacy Policy'), findsWidgets);
    expect(
      find.textContaining('current app implementation processes'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('korean modules screen renders without overflow', (tester) async {
    await pumpApp(tester, initialPrefs: {'language_preference': 'ko'});

    await tester.tap(find.byIcon(Icons.library_books_outlined));
    await tester.pumpAndSettle();

    expect(find.text('설문 모듈'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('modules screen hides restricted modules', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.byIcon(Icons.library_books_outlined));
    await tester.pumpAndSettle();

    expect(find.text('PHQ-2'), findsOneWidget);
    expect(find.text('PHQ-9 / PHQ-A'), findsOneWidget);
    expect(find.text('HADS-D'), findsNothing);
    expect(find.text('CES-D'), findsNothing);
    expect(find.text('BDI-II'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('restricted module routes show unavailable notice', (
    tester,
  ) async {
    await pumpApp(tester);

    final context = tester.element(find.byType(Scaffold).first);
    GoRouter.of(context).go(AppRoutes.hadsD);
    await tester.pumpAndSettle();

    expect(find.text('HADS-D'), findsWidgets);
    expect(find.textContaining('Licensed content required'), findsOneWidget);
    expect(find.text('Back to Modules'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('direct result route shows unavailable state without payload', (
    tester,
  ) async {
    await pumpApp(tester);

    final context = tester.element(find.byType(Scaffold).first);
    GoRouter.of(context).go(AppRoutes.result);
    await tester.pumpAndSettle();

    expect(find.text('No screening result available'), findsOneWidget);
    expect(find.text('Start Screening Again'), findsOneWidget);
    expect(find.text('0'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('first launch shows onboarding', (tester) async {
    await pumpApp(
      tester,
      initialPrefs: {
        'onboarding_completed': false,
        'language_preference': 'ko',
      },
    );

    expect(find.textContaining('온보딩'), findsOneWidget);
    await tester.tap(find.text('건너뛰기'));
    await tester.pumpAndSettle();

    expect(find.text('마음체크'), findsOneWidget);
  });
}
