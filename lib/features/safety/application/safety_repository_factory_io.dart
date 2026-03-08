import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibemental_app/core/logging/logging_providers.dart';
import 'package:vibemental_app/core/settings/data/app_preferences_repository_factory_io.dart';
import 'package:vibemental_app/core/time/clock_providers.dart';
import 'package:vibemental_app/features/safety/data/safety_repository.dart';
import 'package:vibemental_app/features/safety/infrastructure/isar_safety_repository.dart';

/// Purpose: Build safety repository with native Isar-backed persistence.
SafetyRepository createSafetyRepository(Ref ref) {
  final isar = ref.watch(isarProvider);
  final logger = ref.watch(appLoggerProvider);
  final clock = ref.watch(clockProvider);
  return IsarSafetyRepository(isar, logger, clock);
}
