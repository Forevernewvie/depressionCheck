/// Purpose: Provide a unified failure model across network, permission,
/// validation, and unknown runtime error paths.
sealed class AppFailure {
  const AppFailure({required this.message, required this.code});

  final String message;
  final String code;
}

/// Purpose: Represent invalid user or request inputs.
class ValidationFailure extends AppFailure {
  const ValidationFailure({required super.message, required super.code});
}

/// Purpose: Represent denied or unavailable permissions/services.
class PermissionFailure extends AppFailure {
  const PermissionFailure({required super.message, required super.code});
}

/// Purpose: Represent transport and HTTP-related failures.
class NetworkFailure extends AppFailure {
  const NetworkFailure({
    required super.message,
    required super.code,
    this.statusCode,
  });

  final int? statusCode;
}

/// Purpose: Represent unexpected runtime exceptions not covered by specific
/// failure classes.
class UnknownFailure extends AppFailure {
  const UnknownFailure({required super.message, required super.code});
}
