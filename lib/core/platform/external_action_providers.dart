import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibemental_app/core/logging/logging_providers.dart';
import 'package:vibemental_app/core/platform/external_action_service.dart';
import 'package:vibemental_app/core/platform/url_launcher_gateway.dart';

/// Purpose: Expose URL launcher gateway through DI for test-friendly platform
/// integration boundaries.
final urlLauncherGatewayProvider = Provider<UrlLauncherGateway>((ref) {
  return const SystemUrlLauncherGateway();
});

/// Purpose: Expose platform external action service through DI.
final externalActionServiceProvider = Provider<ExternalActionService>((ref) {
  final logger = ref.watch(appLoggerProvider);
  final launcher = ref.watch(urlLauncherGatewayProvider);
  return UrlLauncherExternalActionService(logger: logger, launcher: launcher);
});
