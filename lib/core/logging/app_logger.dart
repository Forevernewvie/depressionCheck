import 'dart:convert';

/// Purpose: Define logger contract so infrastructure implementation can be
/// replaced without changing domain/presentation layers.
abstract class AppLogger {
  /// Purpose: Emit informational structured logs.
  void info(String message, {Map<String, Object?> context = const {}});

  /// Purpose: Emit warning structured logs.
  void warn(String message, {Map<String, Object?> context = const {}});

  /// Purpose: Emit error structured logs including optional exception details.
  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?> context = const {},
  });
}

/// Purpose: Provide default debug logger that emits structured JSON logs with
/// sensitive field redaction.
class DebugPrintAppLogger implements AppLogger {
  const DebugPrintAppLogger();

  @override
  void info(String message, {Map<String, Object?> context = const {}}) {
    _printLog('INFO', message, context: context);
  }

  @override
  void warn(String message, {Map<String, Object?> context = const {}}) {
    _printLog('WARN', message, context: context);
  }

  @override
  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?> context = const {},
  }) {
    _printLog(
      'ERROR',
      message,
      context: {
        ...context,
        if (error != null) 'error': error.toString(),
        if (stackTrace != null) 'stackTrace': stackTrace.toString(),
      },
    );
  }

  /// Purpose: Serialize and print log records in a consistent JSON format.
  void _printLog(
    String level,
    String message, {
    Map<String, Object?> context = const {},
  }) {
    final safeContext = _redact(context);
    final payload = <String, Object?>{
      'level': level,
      'message': message,
      'context': safeContext,
    };
    // ignore: avoid_print
    print(jsonEncode(payload));
  }

  /// Purpose: Remove potentially sensitive values before emitting logs.
  Map<String, Object?> _redact(Map<String, Object?> context) {
    final redacted = <String, Object?>{};
    for (final entry in context.entries) {
      final lowerKey = entry.key.toLowerCase();
      final shouldRedact =
          lowerKey.contains('phone') ||
          lowerKey.contains('address') ||
          lowerKey.contains('token') ||
          lowerKey.contains('email');
      redacted[entry.key] = shouldRedact ? '[REDACTED]' : entry.value;
    }
    return redacted;
  }
}
