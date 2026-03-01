import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibemental_app/core/logging/logging_providers.dart';
import 'package:vibemental_app/core/platform/external_action_service.dart';

/// Purpose: Expose platform external action service through DI.
final externalActionServiceProvider = Provider<ExternalActionService>((ref) {
  final logger = ref.watch(appLoggerProvider);
  return UrlLauncherExternalActionService(logger);
});
