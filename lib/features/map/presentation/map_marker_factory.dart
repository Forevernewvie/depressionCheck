import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:vibemental_app/core/config/map_config.dart';
import 'package:vibemental_app/features/map/domain/clinic.dart';

/// Purpose: Build deterministic map markers outside the screen widget so
/// marker generation stays readable and testable.
class MapMarkerFactory {
  const MapMarkerFactory();

  /// Purpose: Create current-location and clinic markers in a stable order.
  List<Marker> build({
    required LatLng? currentLocation,
    required List<Clinic> clinics,
  }) {
    if (currentLocation == null) {
      return const [];
    }

    final currentMarker = Marker(
      point: currentLocation,
      width: MapConfig.markerSize,
      height: MapConfig.markerSize,
      child: const Icon(
        Icons.my_location,
        color: Colors.blue,
        size: MapConfig.markerIconSize,
      ),
    );

    final clinicMarkers = clinics
        .map(
          (clinic) => Marker(
            point: LatLng(clinic.latitude, clinic.longitude),
            width: MapConfig.markerSize,
            height: MapConfig.markerSize,
            child: const Icon(
              Icons.location_on,
              color: Colors.red,
              size: MapConfig.markerIconSize,
            ),
          ),
        )
        .toList(growable: false);

    return [currentMarker, ...clinicMarkers];
  }
}
