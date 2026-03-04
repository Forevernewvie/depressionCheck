import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vibemental_app/app/app.dart';
import 'package:vibemental_app/core/ads/ad_providers.dart';
import 'package:vibemental_app/core/settings/app_settings.dart';
import 'package:vibemental_app/core/settings/data/app_preferences_repository.dart';
import 'package:vibemental_app/features/common/widgets/likert_question_card.dart';
import 'package:vibemental_app/features/common/widgets/severity_chip.dart';
import 'package:vibemental_app/features/onboarding/presentation/splash_screen.dart';

import '../../fakes/fake_ad_service.dart';
import '../../fakes/fake_app_preferences_repository.dart';

void main() {
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

  testWidgets('hads module opens and can submit to result screen', (
    tester,
  ) async {
    await _pumpApp(tester);

    await tester.tap(find.byIcon(Icons.library_books_outlined));
    await tester.pumpAndSettle();

    while (find.text('HADS-D').evaluate().isEmpty) {
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -500));
      await tester.pumpAndSettle();
    }

    final hadsCard = find.ancestor(
      of: find.text('HADS-D'),
      matching: find.byType(Card),
    );
    expect(hadsCard, findsOneWidget);

    final hadsOpenButton = find.descendant(
      of: hadsCard,
      matching: find.byType(FilledButton),
    );
    expect(hadsOpenButton, findsOneWidget);
    await tester.tap(hadsOpenButton);
    await tester.pumpAndSettle();

    expect(find.text('HADS-D'), findsOneWidget);

    for (int i = 0; i < 7; i++) {
      await _answerModuleItem(tester, moduleTitle: 'HADS-D', index: i + 1);
    }

    await tester.ensureVisible(find.text('View Result'));
    await tester.tap(find.text('View Result'));
    await tester.pumpAndSettle();

    expect(find.byType(SeverityChip), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

/// Purpose: Select the first Likert option for one module item by scrolling to it.
Future<void> _answerModuleItem(
  WidgetTester tester, {
  required String moduleTitle,
  required int index,
}) async {
  final label = '$moduleTitle Item $index';
  int scrollGuard = 0;
  while (find.text(label).evaluate().isEmpty && scrollGuard < 20) {
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -300));
    await tester.pumpAndSettle();
    scrollGuard++;
  }

  expect(find.text(label), findsOneWidget);
  final cardFinder = find.ancestor(
    of: find.text(label),
    matching: find.byType(LikertQuestionCard),
  );
  final firstChoice = find.descendant(
    of: cardFinder,
    matching: find.byType(ChoiceChip),
  );
  await tester.ensureVisible(firstChoice.first);
  await tester.tap(firstChoice.first, warnIfMissed: false);
  await tester.pumpAndSettle();
}
