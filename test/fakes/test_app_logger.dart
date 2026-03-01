import 'package:vibemental_app/core/logging/app_logger.dart';

class TestAppLogger implements AppLogger {
  final List<String> infos = <String>[];
  final List<String> warnings = <String>[];
  final List<String> errors = <String>[];

  @override
  void info(String message, {Map<String, Object?> context = const {}}) {
    infos.add(message);
  }

  @override
  void warn(String message, {Map<String, Object?> context = const {}}) {
    warnings.add(message);
  }

  @override
  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?> context = const {},
  }) {
    errors.add(message);
  }
}
