import 'package:flutter_test/flutter_test.dart';
import 'package:vibemental_app/core/settings/onboarding_controller.dart';
import 'fakes/fake_app_preferences_repository.dart';

void main() {
  test('onboarding completion is restored and persisted', () async {
    final repository = FakeAppPreferencesRepository(onboardingCompleted: false);
    final controller = OnboardingController(repository);
    expect(controller.state, isFalse);

    await controller.markCompleted();
    expect(controller.state, isTrue);
    expect(repository.snapshot.onboardingCompleted, isTrue);

    await controller.reset();
    expect(controller.state, isFalse);
    expect(repository.snapshot.onboardingCompleted, isFalse);
  });
}
