import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibemental_app/core/logging/logging_providers.dart';
import 'package:vibemental_app/features/safety/application/safety_controller.dart';
import 'package:vibemental_app/features/safety/application/safety_repository_factory.dart';
import 'package:vibemental_app/features/safety/application/safety_state.dart';
import 'package:vibemental_app/features/safety/data/safety_repository.dart';

/// Purpose: Provide safety repository implementation through dependency
/// inversion.
final safetyRepositoryProvider = Provider<SafetyRepository>((ref) {
  return createSafetyRepository(ref);
});

/// Purpose: Provide safety-plan state controller for presentation layer.
final safetyControllerProvider =
    StateNotifierProvider<SafetyController, SafetyState>((ref) {
      return SafetyController(
        ref.watch(safetyRepositoryProvider),
        ref.watch(appLoggerProvider),
      );
    });
