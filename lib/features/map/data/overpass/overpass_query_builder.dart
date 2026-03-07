import 'package:vibemental_app/core/config/map_config.dart';

/// Purpose: Generate Overpass queries without leaking query-shape details into
/// repository orchestration code.
class OverpassQueryBuilder {
  const OverpassQueryBuilder();

  static const List<String> _elementTypes = <String>['node', 'way', 'relation'];
  static const List<String> _filterExpressions = <String>[
    '["amenity"~"hospital|clinic"]',
    '["healthcare"~"psychiatrist|mental_health"]',
  ];

  /// Purpose: Build the nearby clinic query from validated request values.
  String buildNearbyClinicQuery({
    required double latitude,
    required double longitude,
    required int radiusMeters,
  }) {
    final buffer = StringBuffer()
      ..writeln('[out:json][timeout:${MapConfig.overpassQueryTimeoutSeconds}];')
      ..writeln('(');

    for (final elementType in _elementTypes) {
      for (final filterExpression in _filterExpressions) {
        buffer.writeln(
          '  $elementType(around:$radiusMeters,$latitude,$longitude)$filterExpression;',
        );
      }
    }

    buffer
      ..writeln(');')
      ..writeln('out center ${MapConfig.overpassOutputLimit};');

    return buffer.toString();
  }
}
