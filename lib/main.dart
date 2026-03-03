import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vibemental_app/app/app.dart';
import 'package:vibemental_app/core/ads/ad_providers.dart';
import 'package:vibemental_app/core/logging/app_logger.dart';
import 'package:vibemental_app/core/logging/logging_providers.dart';
import 'package:vibemental_app/core/settings/data/app_preference.dart';
import 'package:vibemental_app/core/settings/data/app_preferences_repository.dart';
import 'package:vibemental_app/features/checkin/data/daily_checkin_record.dart';
import 'package:vibemental_app/features/safety/data/safety_plan_record.dart';
import 'package:vibemental_app/features/safety/data/trusted_contact_record.dart';
import 'package:vibemental_app/infrastructure/ads/google_mobile_ads_service.dart';

/// Purpose: Initialize platform services, database, global error handlers,
/// and dependency overrides before bootstrapping the Flutter app.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final logger = const DebugPrintAppLogger();
  _configureGlobalErrorHandling(logger);
  final adService = GoogleMobileAdsService(logger);
  await adService.initialize();

  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [
      AppPreferenceSchema,
      DailyCheckInRecordSchema,
      SafetyPlanRecordSchema,
      TrustedContactRecordSchema,
    ],
    directory: dir.path,
    inspector: kDebugMode,
  );

  runZonedGuarded(
    () {
      runApp(
        ProviderScope(
          overrides: [
            isarProvider.overrideWithValue(isar),
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

  PlatformDispatcher.instance.onError = (error, stackTrace) {
    logger.error(
      'Platform dispatcher error.',
      error: error,
      stackTrace: stackTrace,
    );
    return true;
  };
}
