import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibemental_app/core/logging/logging_providers.dart';
import 'package:vibemental_app/core/time/clock_providers.dart';
import 'package:vibemental_app/features/checkin/application/checkin_controller.dart';
import 'package:vibemental_app/features/checkin/application/checkin_repository_factory.dart';
import 'package:vibemental_app/features/checkin/application/checkin_state.dart';
import 'package:vibemental_app/features/checkin/data/checkin_repository.dart';

/// Purpose: Provide check-in repository implementation through dependency
/// inversion.
final checkInRepositoryProvider = Provider<CheckInRepository>((ref) {
  return createCheckInRepository(ref);
});

/// Purpose: Provide check-in controller state for presentation layer.
final checkInControllerProvider =
    StateNotifierProvider<CheckInController, CheckInState>((ref) {
      return CheckInController(
        ref.watch(checkInRepositoryProvider),
        ref.watch(appLoggerProvider),
        ref.watch(clockProvider),
      );
    });
