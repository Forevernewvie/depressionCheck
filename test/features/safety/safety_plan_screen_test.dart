import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vibemental_app/core/config/app_env.dart';
import 'package:vibemental_app/core/logging/logging_providers.dart';
import 'package:vibemental_app/core/platform/external_action_providers.dart';
import 'package:vibemental_app/core/platform/external_action_service.dart';
import 'package:vibemental_app/core/result/app_result.dart';
import 'package:vibemental_app/core/theme/app_theme.dart';
import 'package:vibemental_app/features/safety/application/safety_providers.dart';
import 'package:vibemental_app/features/safety/data/safety_repository.dart';
import 'package:vibemental_app/features/safety/domain/safety_plan_data.dart';
import 'package:vibemental_app/features/safety/domain/trusted_contact.dart';
import 'package:vibemental_app/features/safety/presentation/safety_plan_screen.dart';
import 'package:vibemental_app/l10n/app_localizations.dart';

import '../../fakes/test_app_logger.dart';

class _FakeSafetyRepository implements SafetyRepository {
  _FakeSafetyRepository({SafetyPlanData? plan, List<TrustedContact>? contacts})
    : _plan = plan ?? const SafetyPlanData(),
      _contacts = List<TrustedContact>.from(contacts ?? const []);

  SafetyPlanData _plan;
  final List<TrustedContact> _contacts;
  int _idSeed = 100;

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
    if (contact.isPrimary) {
      for (var index = 0; index < _contacts.length; index++) {
        final current = _contacts[index];
        if (current.id != contact.id && current.isPrimary) {
          _contacts[index] = TrustedContact(
            id: current.id,
            name: current.name,
            relation: current.relation,
            phone: current.phone,
            isPrimary: false,
            sortOrder: current.sortOrder,
          );
        }
      }
    }

    final stored = TrustedContact(
      id: contact.id > 0 ? contact.id : _idSeed++,
      name: contact.name,
      relation: contact.relation,
      phone: contact.phone,
      isPrimary: contact.isPrimary,
      sortOrder: contact.sortOrder,
    );

    final index = _contacts.indexWhere((item) => item.id == stored.id);
    if (index >= 0) {
      _contacts[index] = stored;
    } else {
      _contacts.add(stored);
    }
  }
}

class _SpyExternalActionService implements ExternalActionService {
  final List<String> calledPhones = <String>[];

  @override
  Future<AppResult<void>> callPhone(String rawPhone) async {
    calledPhones.add(rawPhone);
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

void main() {
  Future<void> pumpScreen(
    WidgetTester tester, {
    required _FakeSafetyRepository repository,
    required _SpyExternalActionService actions,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appLoggerProvider.overrideWithValue(TestAppLogger()),
          safetyRepositoryProvider.overrideWithValue(repository),
          externalActionServiceProvider.overrideWithValue(actions),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const SafetyPlanScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('emergency CTA triggers emergency call action', (tester) async {
    final repository = _FakeSafetyRepository();
    final actions = _SpyExternalActionService();

    await pumpScreen(tester, repository: repository, actions: actions);

    expect(
      find.text(
        'Call emergency services, a crisis line, or your primary contact now. Use the steps below only if it is safe to do so.',
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('Call Emergency'));
    await tester.pumpAndSettle();

    expect(actions.calledPhones, contains(AppEnv.emergencyPhone));
  });

  testWidgets('primary contact CTA triggers one-tap call', (tester) async {
    final repository = _FakeSafetyRepository(
      contacts: const [
        TrustedContact(
          id: 1,
          name: 'Sam',
          relation: 'Friend',
          phone: '+821012345678',
          isPrimary: true,
          sortOrder: 0,
        ),
      ],
    );
    final actions = _SpyExternalActionService();

    await pumpScreen(tester, repository: repository, actions: actions);

    await tester.tap(find.text('Call Primary Contact'));
    await tester.pumpAndSettle();

    expect(actions.calledPhones, contains('+821012345678'));
  });

  testWidgets(
    'invalid contact input keeps dialog open and preserves entered values',
    (tester) async {
      final repository = _FakeSafetyRepository();
      final actions = _SpyExternalActionService();

      await pumpScreen(tester, repository: repository, actions: actions);

      final addContactButton = find.widgetWithText(
        OutlinedButton,
        'Add Contact',
      );
      await tester.scrollUntilVisible(
        addContactButton,
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(addContactButton);
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextField, 'Name'),
        'Alex Example',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Relationship'),
        'Friend',
      );
      await tester.enterText(find.widgetWithText(TextField, 'Phone'), '12');

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(
        find.text('Please check contact inputs and try again.'),
        findsOneWidget,
      );
      expect(find.text('Alex Example'), findsOneWidget);
      expect(repository.readSnapshot().contacts, isEmpty);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('contact dialog ignores accidental dismiss gestures', (
    tester,
  ) async {
    final repository = _FakeSafetyRepository();
    final actions = _SpyExternalActionService();

    await pumpScreen(tester, repository: repository, actions: actions);

    final addContactButton = find.widgetWithText(OutlinedButton, 'Add Contact');
    await tester.scrollUntilVisible(
      addContactButton,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(addContactButton);
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, 'Name'), 'Jamie');
    await tester.pumpAndSettle();

    await tester.tapAt(const Offset(5, 5));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Jamie'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Jamie'), findsOneWidget);
    expect(repository.readSnapshot().contacts, isEmpty);
    expect(tester.takeException(), isNull);
  });
}
