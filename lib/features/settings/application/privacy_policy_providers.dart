import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibemental_app/core/config/app_env.dart';
import 'package:vibemental_app/core/logging/logging_providers.dart';
import 'package:vibemental_app/core/platform/external_action_providers.dart';
import 'package:vibemental_app/features/settings/application/privacy_policy_launcher.dart';

/// Purpose: Expose privacy-policy launcher through DI for test-friendly legal
/// document navigation.
final privacyPolicyLauncherProvider = Provider<PrivacyPolicyLauncher>((ref) {
  final logger = ref.watch(appLoggerProvider);
  final launcher = ref.watch(urlLauncherGatewayProvider);
  return ExternalPrivacyPolicyLauncher(
    privacyPolicyUrl: AppEnv.privacyPolicyUrl,
    logger: logger,
    launcher: launcher,
  );
});
