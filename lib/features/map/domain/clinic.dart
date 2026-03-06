/// Purpose: Represent specialist availability confidence for clinic rendering.
enum ClinicSpecialistAvailability { available, unavailable, unknown }

/// Purpose: Represent clinic open-state confidence for current user time.
enum ClinicOpenState { open, closed, unknown }

class Clinic {
  const Clinic({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.category,
    required this.distanceMeters,
    this.phone,
    this.address,
    this.specialistAvailability = ClinicSpecialistAvailability.unknown,
    this.specialistInfoSource,
    this.specialistVerifiedAt,
    this.openingHoursByDay = const <int, String>{},
    this.openNow,
    this.timezone,
    this.dataUpdatedAt,
  });

  final String name;
  final double latitude;
  final double longitude;
  final String category;
  final double distanceMeters;
  final String? phone;
  final String? address;
  final ClinicSpecialistAvailability specialistAvailability;
  final String? specialistInfoSource;
  final DateTime? specialistVerifiedAt;
  final Map<int, String> openingHoursByDay;
  final bool? openNow;
  final String? timezone;
  final DateTime? dataUpdatedAt;

  /// Purpose: Build a user-friendly distance string in meters/kilometers.
  String get distanceLabel {
    if (distanceMeters >= 1000) {
      return '${(distanceMeters / 1000).toStringAsFixed(1)} km';
    }
    return '${distanceMeters.toStringAsFixed(0)} m';
  }

  /// Purpose: Return opening-hours label for a specific weekday value.
  String? openingHoursForWeekday(int weekday) {
    return openingHoursByDay[weekday];
  }

  /// Purpose: Resolve current open-state from explicit API value or inferred
  /// time-range value when possible.
  ClinicOpenState resolveOpenState(DateTime now) {
    if (openNow != null) {
      return openNow! ? ClinicOpenState.open : ClinicOpenState.closed;
    }
    final inferred = _inferOpenStateFromHours(
      openingHoursForWeekday(now.weekday),
      now,
    );
    return inferred ?? ClinicOpenState.unknown;
  }

  /// Purpose: Infer open-state from "HH:mm-HH:mm" hour ranges for the day.
  ClinicOpenState? _inferOpenStateFromHours(String? todayHours, DateTime now) {
    if (todayHours == null || todayHours.trim().isEmpty) {
      return null;
    }

    final normalized = todayHours.trim().toLowerCase();
    if (_isClosedToken(normalized)) {
      return ClinicOpenState.closed;
    }

    final nowMinutes = now.hour * 60 + now.minute;
    final ranges = normalized.split(',');

    for (final rawRange in ranges) {
      final range = rawRange.trim();
      final parts = range.split('-');
      if (parts.length != 2) {
        continue;
      }

      final start = _parseClockMinutes(parts.first);
      final end = _parseClockMinutes(parts.last);
      if (start == null || end == null) {
        continue;
      }

      if (start <= end) {
        if (nowMinutes >= start && nowMinutes <= end) {
          return ClinicOpenState.open;
        }
      } else {
        if (nowMinutes >= start || nowMinutes <= end) {
          return ClinicOpenState.open;
        }
      }
    }

    return ClinicOpenState.closed;
  }

  /// Purpose: Parse "HH:mm" text into minute index for range checks.
  int? _parseClockMinutes(String input) {
    final match = RegExp(r'^(\d{1,2}):(\d{2})$').firstMatch(input.trim());
    if (match == null) {
      return null;
    }

    final hour = int.tryParse(match.group(1)!);
    final minute = int.tryParse(match.group(2)!);
    if (hour == null || minute == null) {
      return null;
    }
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
      return null;
    }

    return hour * 60 + minute;
  }

  /// Purpose: Detect known closed/off-day tokens in localized hour strings.
  bool _isClosedToken(String normalizedHours) {
    return normalizedHours.contains('closed') ||
        normalizedHours.contains('off') ||
        normalizedHours.contains('휴무') ||
        normalizedHours.contains('없음');
  }
}
