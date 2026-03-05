import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vibemental_app/core/theme/app_theme.dart';
import 'package:vibemental_app/features/common/widgets/likert_question_card.dart';
import 'package:vibemental_app/l10n/app_localizations.dart';

void main() {
  testWidgets('selected likert chip uses high-contrast text in light mode', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: LikertQuestionCard(
            question: 'Question',
            value: 1,
            onChanged: (_) {},
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final theme = tester.widget<MaterialApp>(find.byType(MaterialApp)).theme!;
    final selectedChip = tester.widget<ChoiceChip>(
      find.byType(ChoiceChip).at(1),
    );
    final unselectedChip = tester.widget<ChoiceChip>(
      find.byType(ChoiceChip).first,
    );

    expect(selectedChip.selected, isTrue);
    expect(selectedChip.labelStyle?.color, theme.colorScheme.onPrimary);
    expect(selectedChip.selectedColor, theme.colorScheme.primary);

    expect(unselectedChip.selected, isFalse);
    expect(unselectedChip.labelStyle?.color, theme.colorScheme.onSurface);
  });
}
