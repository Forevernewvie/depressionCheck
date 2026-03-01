import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibemental_app/core/logging/app_logger.dart';

/// Purpose: Expose a logger dependency through DI for testability.
final appLoggerProvider = Provider<AppLogger>((ref) {
  return const DebugPrintAppLogger();
});
