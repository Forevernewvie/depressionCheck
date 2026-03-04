import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vibemental_app/core/settings/data/app_preference.dart';
import 'package:vibemental_app/core/settings/data/app_preferences_repository_factory_io.dart';
import 'package:vibemental_app/features/checkin/data/daily_checkin_record.dart';
import 'package:vibemental_app/features/safety/data/safety_plan_record.dart';
import 'package:vibemental_app/features/safety/data/trusted_contact_record.dart';

/// Purpose: Build startup overrides for native platforms with Isar storage.
Future<List<Override>> createBootstrapOverrides() async {
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

  return <Override>[isarProvider.overrideWithValue(isar)];
}
