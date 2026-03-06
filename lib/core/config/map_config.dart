/// Purpose: Group map-related constants, validation ranges, and fallback
/// coordinates to remove map magic numbers.
class MapConfig {
  MapConfig._();

  static const double validMinLatitude = -90;
  static const double validMaxLatitude = 90;
  static const double validMinLongitude = -180;
  static const double validMaxLongitude = 180;

  static const int minSearchRadiusMeters = 500;
  static const int maxSearchRadiusMeters = 15000;

  static const double defaultMapZoom = 13;
  static const double markerIconSize = 30;
  static const double markerSize = 34;
  static const double mapWidgetHeight = 260;

  static const double fallbackCenterLat = 37.5665;
  static const double fallbackCenterLng = 126.9780;

  static const List<int> weekdayOrder = <int>[
    DateTime.monday,
    DateTime.tuesday,
    DateTime.wednesday,
    DateTime.thursday,
    DateTime.friday,
    DateTime.saturday,
    DateTime.sunday,
  ];
}
