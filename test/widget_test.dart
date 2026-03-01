import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vibemental_app/app/app.dart';
import 'package:vibemental_app/core/settings/app_settings.dart';
import 'package:vibemental_app/core/settings/data/app_preferences_repository.dart';
import 'package:vibemental_app/features/onboarding/presentation/splash_screen.dart';
import 'fakes/fake_app_preferences_repository.dart';

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
          splashDurationProvider.overrideWithValue(Duration.zero),
        ],
        child: const MindCheckApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('home to PHQ-2 flow works', (tester) async {
    await pumpApp(tester);

    expect(find.text('Mind Check'), findsOneWidget);
    await tester.tap(find.text('Start Mild Screen'));
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

  testWidgets('korean modules screen renders without overflow', (tester) async {
    await pumpApp(tester, initialPrefs: {'language_preference': 'ko'});

    await tester.tap(find.byIcon(Icons.library_books_outlined));
    await tester.pumpAndSettle();

    expect(find.text('설문 모듈'), findsOneWidget);
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
