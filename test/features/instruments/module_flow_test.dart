import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vibemental_app/app/app.dart';
import 'package:vibemental_app/core/ads/ad_providers.dart';
import 'package:vibemental_app/core/config/screening_thresholds.dart';
import 'package:vibemental_app/core/settings/app_settings.dart';
import 'package:vibemental_app/core/settings/data/app_preferences_repository.dart';
import 'package:vibemental_app/features/common/widgets/likert_question_card.dart';
import 'package:vibemental_app/features/instruments/domain/module_question_bank.dart';
import 'package:vibemental_app/features/common/widgets/severity_chip.dart';
import 'package:vibemental_app/features/onboarding/presentation/splash_screen.dart';
import 'package:vibemental_app/features/screening/domain/screening_result.dart';

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

    await tester.tap(find.byTooltip('Browse Modules'));
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

    final hadsQuestions = ModuleQuestionBank.byInstrument(
      ScreeningInstrument.hadsD,
    )!.questionsByLanguage[ModuleQuestionBank.languageEn]!;
    for (final question in hadsQuestions) {
      await _answerModuleItemByQuestionText(tester, question: question);
    }

    await tester.ensureVisible(find.text('View Result'));
    await tester.tap(find.text('View Result'));
    await tester.pumpAndSettle();

    expect(find.byType(SeverityChip), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('additional modules render non-empty questions and options', (
    tester,
  ) async {
    await _pumpApp(tester);
    await tester.tap(find.byTooltip('Browse Modules'));
    await tester.pumpAndSettle();

    await _openModuleFromCard(tester, moduleTitle: 'HADS-D');
    _expectFirstQuestionAndOptionsNotEmpty(tester);
    await _backToModules(tester);

    await _openModuleFromCard(tester, moduleTitle: 'CES-D');
    _expectFirstQuestionAndOptionsNotEmpty(tester);
    await _backToModules(tester);

    await _openModuleFromCard(tester, moduleTitle: 'BDI-II');
    _expectFirstQuestionAndOptionsNotEmpty(tester);
    expect(tester.takeException(), isNull);
  });
}

/// Purpose: Open one module card by title and tap its start button.
Future<void> _openModuleFromCard(
  WidgetTester tester, {
  required String moduleTitle,
}) async {
  while (find.text(moduleTitle).evaluate().isEmpty) {
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -500));
    await tester.pumpAndSettle();
  }

  final moduleCard = find.ancestor(
    of: find.text(moduleTitle),
    matching: find.byType(Card),
  );
  expect(moduleCard, findsOneWidget);
  final openButton = find.descendant(
    of: moduleCard,
    matching: find.byType(FilledButton),
  );
  expect(openButton, findsOneWidget);
  await tester.ensureVisible(openButton);

  for (int attempt = 0; attempt < 3; attempt++) {
    await tester.tap(openButton, warnIfMissed: false);
    await tester.pumpAndSettle();
    if (find.byType(LikertQuestionCard).evaluate().isNotEmpty) {
      return;
    }
  }

  fail('Failed to open module questionnaire for $moduleTitle.');
}

/// Purpose: Select the first Likert option for a question by visible text.
Future<void> _answerModuleItemByQuestionText(
  WidgetTester tester, {
  required String question,
}) async {
  while (find.text(question).evaluate().isEmpty) {
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -300));
    await tester.pumpAndSettle();
  }

  final cardFinder = find.ancestor(
    of: find.text(question),
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

/// Purpose: Return from module questionnaire view to module list safely.
Future<void> _backToModules(WidgetTester tester) async {
  while (find.text('Back to modules').evaluate().isEmpty) {
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -500));
    await tester.pumpAndSettle();
  }

  await tester.tap(find.text('Back to modules'));
  await tester.pumpAndSettle();
}

/// Purpose: Ensure module screens display usable question and option labels.
void _expectFirstQuestionAndOptionsNotEmpty(WidgetTester tester) {
  final cards = find.byType(LikertQuestionCard);
  expect(cards, findsAtLeastNWidgets(1));
  final firstCard = cards.first;

  final cardTexts = find.descendant(of: firstCard, matching: find.byType(Text));
  final labels = cardTexts
      .evaluate()
      .map((element) => element.widget)
      .whereType<Text>()
      .map((text) => text.data ?? text.textSpan?.toPlainText() ?? '')
      .map((value) => value.trim())
      .where((value) => value.isNotEmpty)
      .toList(growable: false);

  expect(labels, isNotEmpty);
  expect(
    labels.length,
    greaterThanOrEqualTo(
      (ScreeningThresholds.likertMax - ScreeningThresholds.likertMin) + 2,
    ),
  );
}
