import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vibemental_app/core/logging/logging_providers.dart';
import 'package:vibemental_app/features/checkin/application/checkin_providers.dart';
import 'package:vibemental_app/features/checkin/data/checkin_repository.dart';
import 'package:vibemental_app/features/checkin/domain/daily_checkin_entry.dart';
import 'package:vibemental_app/features/checkin/presentation/checkin_screen.dart';
import 'package:vibemental_app/l10n/app_localizations.dart';

import '../../fakes/test_app_logger.dart';

class _FakeCheckInRepository implements CheckInRepository {
  final Map<String, DailyCheckInEntry> _storage = <String, DailyCheckInEntry>{};

  @override
  DailyCheckInEntry? readByDateKey(String localDateKey) =>
      _storage[localDateKey];

  @override
  List<DailyCheckInEntry> readRecentEntries({required int days}) {
    final entries = _storage.values.toList(growable: false);
    entries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return entries;
  }

  @override
  void saveEntry({
    required String localDateKey,
    required int mood,
    required int energy,
    required DateTime now,
    String? note,
  }) {
    _storage[localDateKey] = DailyCheckInEntry(
      localDateKey: localDateKey,
      mood: mood,
      energy: energy,
      createdAt: now,
      note: note ?? '',
    );
  }

  void seed(DailyCheckInEntry entry) {
    _storage[entry.localDateKey] = entry;
  }
}

void main() {
  Future<void> pumpScreen(
    WidgetTester tester, {
    required _FakeCheckInRepository repository,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appLoggerProvider.overrideWithValue(TestAppLogger()),
          checkInRepositoryProvider.overrideWithValue(repository),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const CheckInScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('saves daily check-in and shows success feedback', (
    tester,
  ) async {
    final repository = _FakeCheckInRepository();

    await pumpScreen(tester, repository: repository);

    await tester.enterText(find.byType(TextField).first, 'Had a steady day.');
    await tester.tap(find.text('Save Today'));
    await tester.pumpAndSettle();

    expect(repository.readRecentEntries(days: 7), isNotEmpty);
    expect(find.text('Check-in saved.'), findsOneWidget);
  });

  testWidgets('renders weekly trend summary from saved entries', (
    tester,
  ) async {
    final repository = _FakeCheckInRepository()
      ..seed(
        DailyCheckInEntry(
          localDateKey: '2026-02-25',
          mood: 2,
          energy: 3,
          createdAt: DateTime.parse('2026-02-25T08:00:00'),
          note: 'A',
        ),
      )
      ..seed(
        DailyCheckInEntry(
          localDateKey: '2026-02-24',
          mood: 4,
          energy: 2,
          createdAt: DateTime.parse('2026-02-24T08:00:00'),
          note: 'B',
        ),
      );

    await pumpScreen(tester, repository: repository);

    expect(find.text('7-day Trend'), findsOneWidget);
    expect(find.textContaining('Weekly average'), findsOneWidget);
    expect(find.text('Mood'), findsWidgets);
  });
}
