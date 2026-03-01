import 'package:vibemental_app/core/config/safety_plan_config.dart';
import 'package:vibemental_app/core/security/input_validator.dart';

/// Purpose: Clamp section length to avoid oversized payload and UI overflow.
String normalizeSafetySection(String raw) {
  final trimmed = raw.trim();
  if (trimmed.length <= SafetyPlanConfig.maxSectionLength) {
    return trimmed;
  }
  return trimmed.substring(0, SafetyPlanConfig.maxSectionLength);
}

/// Purpose: Validate contact name constraints.
bool isValidContactName(String raw) {
  final trimmed = raw.trim();
  return trimmed.isNotEmpty &&
      trimmed.length <= SafetyPlanConfig.maxContactNameLength;
}

/// Purpose: Validate contact relation constraints.
bool isValidContactRelation(String raw) {
  final trimmed = raw.trim();
  return trimmed.isNotEmpty &&
      trimmed.length <= SafetyPlanConfig.maxContactRelationLength;
}

/// Purpose: Normalize phone for safe dial action and persistence.
String normalizeContactPhone(String raw) {
  return InputValidator.sanitizePhoneNumber(raw);
}

/// Purpose: Validate sanitized phone contains dialable digits.
bool isValidContactPhone(String sanitized) {
  return sanitized.length >= 7;
}
