import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibemental_app/core/logging/logging_providers.dart';
import 'package:vibemental_app/features/checkin/data/checkin_repository.dart';
import 'package:vibemental_app/features/checkin/infrastructure/web_checkin_repository.dart';

/// Purpose: Build check-in repository with web local-storage persistence.
CheckInRepository createCheckInRepository(Ref ref) {
  return WebCheckInRepository(ref.watch(appLoggerProvider));
}
