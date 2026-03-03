import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibemental_app/core/logging/logging_providers.dart';
import 'package:vibemental_app/core/settings/data/app_preferences_repository_factory_io.dart';
import 'package:vibemental_app/features/checkin/data/checkin_repository.dart';
import 'package:vibemental_app/features/checkin/infrastructure/isar_checkin_repository.dart';

/// Purpose: Build check-in repository with native Isar-backed persistence.
CheckInRepository createCheckInRepository(Ref ref) {
  final isar = ref.watch(isarProvider);
  final logger = ref.watch(appLoggerProvider);
  return IsarCheckInRepository(isar, logger);
}
