import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibemental_app/app/app.dart';
import 'package:vibemental_app/bootstrap/bootstrap_overrides.dart';
import 'package:vibemental_app/core/ads/ad_providers.dart';
import 'package:vibemental_app/core/ads/noop_ad_service.dart';
import 'package:vibemental_app/core/logging/app_logger.dart';
import 'package:vibemental_app/core/logging/logging_providers.dart';
import 'package:vibemental_app/infrastructure/ads/google_mobile_ads_service.dart';

/// Purpose: Initialize platform services, database, global error handlers,
/// and dependency overrides before bootstrapping the Flutter app.
Future<void> main() async {
  final logger = const DebugPrintAppLogger();
  await runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      _configureGlobalErrorHandling(logger);
      final adService = kIsWeb
          ? const NoopAdService()
          : GoogleMobileAdsService(logger);
      await adService.initialize();
      final bootstrapOverrides = await createBootstrapOverrides();

      runApp(
        ProviderScope(
          overrides: [
            ...bootstrapOverrides,
            appLoggerProvider.overrideWithValue(logger),
            adServiceProvider.overrideWithValue(adService),
          ],
          child: const MindCheckApp(),
        ),
      );
    },
    (error, stackTrace) {
      logger.error(
        'Uncaught zone error.',
        error: error,
        stackTrace: stackTrace,
      );
    },
  );
}

/// Purpose: Capture framework and platform errors for structured logging.
void _configureGlobalErrorHandling(AppLogger logger) {
  FlutterError.onError = (details) {
    logger.error(
      'Flutter framework error.',
      error: details.exception,
      stackTrace: details.stack,
    );
    FlutterError.presentError(details);
  };

  WidgetsBinding.instance.platformDispatcher.onError = (error, stackTrace) {
    logger.error(
      'Platform dispatcher error.',
      error: error,
      stackTrace: stackTrace,
    );
    return true;
  };
}
