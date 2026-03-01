import 'dart:async';

import 'package:vibemental_app/core/errors/app_failure.dart';
import 'package:vibemental_app/core/result/app_result.dart';

/// Purpose: Provide reusable retry-with-backoff execution for transient
/// operations.
class RetryExecutor {
  const RetryExecutor({required this.maxAttempts, required this.baseDelay});

  final int maxAttempts;
  final Duration baseDelay;

  /// Purpose: Retry an operation on transient network failures until attempts
  /// are exhausted.
  Future<AppResult<T>> execute<T>(
    Future<AppResult<T>> Function() operation,
  ) async {
    AppResult<T> lastResult = await operation();

    for (int attempt = 2; attempt <= maxAttempts; attempt++) {
      if (lastResult is AppSuccess<T>) {
        return lastResult;
      }

      final failure = (lastResult as AppError<T>).failure;
      if (!_shouldRetry(failure)) {
        return lastResult;
      }

      final delay = baseDelay * (attempt - 1);
      await Future<void>.delayed(delay);
      lastResult = await operation();
    }

    return lastResult;
  }

  /// Purpose: Determine whether a failure is retryable.
  bool _shouldRetry(AppFailure failure) {
    return failure is NetworkFailure;
  }
}
