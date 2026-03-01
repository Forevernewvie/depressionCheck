import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibemental_app/core/settings/data/app_preferences_repository.dart';

/// Purpose: Expose onboarding completion state through Riverpod.
final onboardingControllerProvider =
    StateNotifierProvider<OnboardingController, bool>((ref) {
      final repository = ref.watch(appPreferencesRepositoryProvider);
      return OnboardingController(repository);
    });

class OnboardingController extends StateNotifier<bool> {
  OnboardingController(this._repository) : super(false) {
    state = _repository.read().onboardingCompleted;
  }

  final AppPreferencesRepository _repository;

  /// Purpose: Persist completed onboarding and update in-memory state.
  Future<void> markCompleted() {
    state = true;
    _repository.saveOnboardingCompleted(true);
    return Future<void>.value();
  }

  /// Purpose: Reset onboarding completion for test/support workflows.
  Future<void> reset() {
    state = false;
    _repository.saveOnboardingCompleted(false);
    return Future<void>.value();
  }
}
