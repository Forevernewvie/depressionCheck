import 'package:geolocator/geolocator.dart';
import 'package:vibemental_app/core/config/map_config.dart';
import 'package:vibemental_app/core/time/clock.dart';
import 'package:vibemental_app/features/map/domain/clinic.dart';

/// Purpose: Convert Overpass payloads into validated clinic entities while
/// keeping parsing rules independently testable from HTTP concerns.
class OverpassClinicParser {
  OverpassClinicParser({Clock? clock}) : _clock = clock ?? const SystemClock();

  final Clock _clock;
  static const List<String> _specialistTagKeys = <String>[
    'healthcare:speciality',
    'healthcare:specialty',
    'speciality',
    'specialty',
    'department',
  ];
  static const List<String> _openingHoursTagKeys = <String>[
    'opening_hours',
    'contact:opening_hours',
  ];
  static const List<String> _psychiatryKeywords = <String>[
    'psychiatry',
    'psychiatrist',
    'mental_health',
    '정신건강',
    '정신의학',
  ];

  /// Purpose: Parse, deduplicate, sort, and limit clinics from an Overpass
  /// response payload.
  List<Clinic> parseNearbyClinics({
    required Map<String, dynamic> payload,
    required double originLatitude,
    required double originLongitude,
    required int maxResults,
  }) {
    final elements = (payload['elements'] as List<dynamic>? ?? const []);
    final clinics = <Clinic>[];
    final seen = <String>{};
    final fetchedAt = _clock.now().toUtc();

    for (final raw in elements) {
      if (raw is! Map<String, dynamic>) {
        continue;
      }

      final clinic = _buildClinic(
        element: raw,
        originLatitude: originLatitude,
        originLongitude: originLongitude,
        fetchedAt: fetchedAt,
      );
      if (clinic == null) {
        continue;
      }

      final dedupeKey = _createDedupeKey(clinic);
      if (!seen.add(dedupeKey)) {
        continue;
      }

      clinics.add(clinic);
    }

    clinics.sort((a, b) => a.distanceMeters.compareTo(b.distanceMeters));
    return clinics.take(maxResults).toList(growable: false);
  }

  /// Purpose: Build one clinic entity from a raw Overpass element when the
  /// payload contains enough valid data.
  Clinic? _buildClinic({
    required Map<String, dynamic> element,
    required double originLatitude,
    required double originLongitude,
    required DateTime fetchedAt,
  }) {
    final point = _readPoint(element);
    if (point == null) {
      return null;
    }

    final tags = (element['tags'] as Map<String, dynamic>? ?? const {});
    final name =
        (tags['name'] as String?) ??
        (tags['official_name'] as String?) ??
        MapConfig.unknownClinicName;
    final category =
        (tags['healthcare'] as String?) ??
        (tags['amenity'] as String?) ??
        MapConfig.defaultClinicCategory;
    final specialist = _parseSpecialist(tags: tags, clinicName: name);

    return Clinic(
      name: name,
      latitude: point.$1,
      longitude: point.$2,
      category: category,
      distanceMeters: Geolocator.distanceBetween(
        originLatitude,
        originLongitude,
        point.$1,
        point.$2,
      ),
      phone: (tags['phone'] as String?) ?? (tags['contact:phone'] as String?),
      address: _composeAddress(tags),
      specialistAvailability: specialist.$1,
      specialistInfoSource: specialist.$2,
      specialistVerifiedAt: specialist.$2 == null ? null : fetchedAt,
      openingHoursByDay: _parseOpeningHoursByDay(tags),
      openNow: _parseOpenNow(tags),
      timezone: tags['timezone'] as String?,
      dataUpdatedAt: fetchedAt,
    );
  }

  /// Purpose: Create a stable dedupe key without repeatedly scattering
  /// precision constants around parsing code.
  String _createDedupeKey(Clinic clinic) {
    return '${clinic.name}|'
        '${clinic.latitude.toStringAsFixed(MapConfig.clinicDedupePrecision)}|'
        '${clinic.longitude.toStringAsFixed(MapConfig.clinicDedupePrecision)}';
  }

  /// Purpose: Extract coordinate pair from node or center geometry payload.
  (double, double)? _readPoint(Map<String, dynamic> element) {
    final lat = element['lat'];
    final lon = element['lon'];
    if (lat is num && lon is num) {
      return (lat.toDouble(), lon.toDouble());
    }

    final center = element['center'];
    if (center is Map<String, dynamic>) {
      final centerLat = center['lat'];
      final centerLon = center['lon'];
      if (centerLat is num && centerLon is num) {
        return (centerLat.toDouble(), centerLon.toDouble());
      }
    }

    return null;
  }

  /// Purpose: Assemble a human-readable address from optional OSM tag parts.
  String? _composeAddress(Map<String, dynamic> tags) {
    final street = tags['addr:street'] as String?;
    final number = tags['addr:housenumber'] as String?;
    final city = tags['addr:city'] as String?;

    final parts = <String>[];
    if (street != null && street.isNotEmpty) {
      parts.add(street);
    }
    if (number != null && number.isNotEmpty) {
      parts.add(number);
    }
    if (city != null && city.isNotEmpty) {
      parts.add(city);
    }

    if (parts.isEmpty) {
      return null;
    }
    return parts.join(', ');
  }

  /// Purpose: Parse psychiatry specialist availability with explicit source
  /// trace for trust messaging and UI fallbacks.
  (ClinicSpecialistAvailability, String?) _parseSpecialist({
    required Map<String, dynamic> tags,
    required String clinicName,
  }) {
    for (final key in _specialistTagKeys) {
      final value = tags[key] as String?;
      if (value == null || value.trim().isEmpty) {
        continue;
      }
      if (_containsPsychiatryKeyword(value)) {
        return (ClinicSpecialistAvailability.available, key);
      }
      return (ClinicSpecialistAvailability.unavailable, key);
    }

    if (_containsPsychiatryKeyword(clinicName)) {
      return (ClinicSpecialistAvailability.available, 'name');
    }

    return (ClinicSpecialistAvailability.unknown, null);
  }

  /// Purpose: Parse `opening_hours` text into weekday/hour map when format is
  /// compatible with UI rendering.
  Map<int, String> _parseOpeningHoursByDay(Map<String, dynamic> tags) {
    final rawHours = _openingHoursTagKeys
        .map((key) => tags[key] as String?)
        .firstWhere(
          (value) => value != null && value.trim().isNotEmpty,
          orElse: () => null,
        );

    if (rawHours == null) {
      return const <int, String>{};
    }

    final normalized = rawHours.trim();
    if (normalized.toLowerCase() == '24/7') {
      return _buildAlwaysOpenWeek();
    }

    final byDay = <int, String>{};
    final segments = normalized.split(';');
    for (final rawSegment in segments) {
      final segment = rawSegment.trim();
      if (segment.isEmpty) {
        continue;
      }

      final splitIndex = segment.indexOf(' ');
      if (splitIndex < 0) {
        continue;
      }

      final dayPart = segment.substring(0, splitIndex).trim();
      final hoursPart = segment.substring(splitIndex + 1).trim();
      if (hoursPart.isEmpty) {
        continue;
      }

      final weekdays = _expandWeekdays(dayPart);
      for (final weekday in weekdays) {
        byDay[weekday] = hoursPart;
      }
    }

    if (byDay.isEmpty &&
        RegExp(r'^\d{1,2}:\d{2}\s*-\s*\d{1,2}:\d{2}$').hasMatch(normalized)) {
      return _buildWholeWeek(normalized);
    }

    return byDay;
  }

  /// Purpose: Create a reusable full-week schedule map for fixed hour labels.
  Map<int, String> _buildWholeWeek(String hoursLabel) {
    final byDay = <int, String>{};
    for (final weekday in MapConfig.weekdayOrder) {
      byDay[weekday] = hoursLabel;
    }
    return byDay;
  }

  /// Purpose: Create a reusable full-week schedule map for always-open cases.
  Map<int, String> _buildAlwaysOpenWeek() {
    return _buildWholeWeek(MapConfig.alwaysOpenHoursLabel);
  }

  /// Purpose: Parse open/closed state when response provides direct tag.
  bool? _parseOpenNow(Map<String, dynamic> tags) {
    final raw =
        (tags['opening_hours:state'] as String?) ?? (tags['open'] as String?);
    if (raw == null || raw.trim().isEmpty) {
      return null;
    }

    final normalized = raw.trim().toLowerCase();
    if (normalized == 'open' || normalized == 'yes' || normalized == 'true') {
      return true;
    }
    if (normalized == 'closed' || normalized == 'no' || normalized == 'false') {
      return false;
    }
    return null;
  }

  /// Purpose: Expand OSM weekday token patterns like `Mo-Fr` and `Sa,Su`.
  List<int> _expandWeekdays(String dayToken) {
    final result = <int>[];
    final segments = dayToken.split(',');

    for (final segment in segments) {
      final cleaned = segment.trim().toLowerCase();
      if (cleaned.isEmpty) {
        continue;
      }

      if (cleaned.contains('-')) {
        final rangeParts = cleaned.split('-');
        if (rangeParts.length != 2) {
          continue;
        }
        final start = _weekdayFromToken(rangeParts.first);
        final end = _weekdayFromToken(rangeParts.last);
        if (start == null || end == null) {
          continue;
        }
        if (start <= end) {
          for (var day = start; day <= end; day++) {
            result.add(day);
          }
        } else {
          for (var day = start; day <= DateTime.sunday; day++) {
            result.add(day);
          }
          for (var day = DateTime.monday; day <= end; day++) {
            result.add(day);
          }
        }
        continue;
      }

      final day = _weekdayFromToken(cleaned);
      if (day != null) {
        result.add(day);
      }
    }

    return result.toSet().toList(growable: false);
  }

  /// Purpose: Convert OSM weekday tokens into `DateTime.weekday` values.
  int? _weekdayFromToken(String rawToken) {
    return switch (rawToken.trim().toLowerCase()) {
      'mo' => DateTime.monday,
      'tu' => DateTime.tuesday,
      'we' => DateTime.wednesday,
      'th' => DateTime.thursday,
      'fr' => DateTime.friday,
      'sa' => DateTime.saturday,
      'su' => DateTime.sunday,
      _ => null,
    };
  }

  /// Purpose: Check keyword presence for psychiatry-specialist inference.
  bool _containsPsychiatryKeyword(String input) {
    final normalized = input.toLowerCase();
    for (final keyword in _psychiatryKeywords) {
      if (normalized.contains(keyword)) {
        return true;
      }
    }
    return false;
  }
}
