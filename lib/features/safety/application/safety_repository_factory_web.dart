import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibemental_app/core/logging/logging_providers.dart';
import 'package:vibemental_app/features/safety/data/safety_repository.dart';
import 'package:vibemental_app/features/safety/infrastructure/web_safety_repository.dart';

/// Purpose: Build safety repository with web local-storage persistence.
SafetyRepository createSafetyRepository(Ref ref) {
  return WebSafetyRepository(ref.watch(appLoggerProvider));
}
