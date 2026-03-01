import 'package:vibemental_app/core/errors/app_failure.dart';

/// Purpose: Wrap successful and failed outcomes without throwing exceptions
/// across architecture layers.
sealed class AppResult<T> {
  const AppResult();

  /// Purpose: Execute one of two callbacks depending on result type.
  R when<R>({
    required R Function(T data) success,
    required R Function(AppFailure failure) failure,
  }) {
    if (this is AppSuccess<T>) {
      return success((this as AppSuccess<T>).data);
    }
    return failure((this as AppError<T>).failure);
  }
}

/// Purpose: Represent successful result payload.
class AppSuccess<T> extends AppResult<T> {
  const AppSuccess(this.data);

  final T data;
}

/// Purpose: Represent failed result payload.
class AppError<T> extends AppResult<T> {
  const AppError(this.failure);

  final AppFailure failure;
}
