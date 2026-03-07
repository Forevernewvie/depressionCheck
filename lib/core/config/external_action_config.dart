/// Purpose: Centralize external action constants to remove hardcoded values
/// from service implementations and keep platform actions maintainable.
class ExternalActionConfig {
  const ExternalActionConfig._();

  /// Purpose: Keep dialer URI scheme configurable in a single source.
  static const String dialerScheme = 'tel';

  /// Purpose: Avoid obviously invalid or maliciously short dial payloads.
  static const int minPhoneDigits = 3;

  /// Purpose: Follow E.164-compatible upper bound for sanitized phone input.
  static const int maxPhoneDigits = 15;

  /// Purpose: Limit coordinate precision for stable URLs and predictable logs.
  static const int coordinatePrecision = 6;

  /// Purpose: Restrict externally opened directions URLs to secure schemes.
  static const Set<String> allowedDirectionSchemes = <String>{'https'};

  /// Purpose: Keep query parameter names centralized and reusable.
  static const String directionsApiQueryKey = 'api';

  /// Purpose: Keep fixed provider query value out of service logic.
  static const String directionsApiQueryValue = '1';

  /// Purpose: Keep location query parameter name centralized.
  static const String directionsLocationQueryKey = 'query';
}
