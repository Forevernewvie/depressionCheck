import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:vibemental_app/features/map/domain/clinic.dart';
import 'package:vibemental_app/features/map/presentation/map_marker_factory.dart';

void main() {
  const factory = MapMarkerFactory();

  test('returns no markers when current location is unavailable', () {
    final markers = factory.build(
      currentLocation: null,
      clinics: const <Clinic>[],
    );

    expect(markers, isEmpty);
  });

  test('returns current location marker followed by clinic markers', () {
    final markers = factory.build(
      currentLocation: const LatLng(37.5665, 126.9780),
      clinics: const <Clinic>[
        Clinic(
          name: 'Calm Care Clinic',
          latitude: 37.5667,
          longitude: 126.9782,
          category: 'Mental Health Clinic',
          distanceMeters: 120,
        ),
        Clinic(
          name: 'Hope Clinic',
          latitude: 37.5670,
          longitude: 126.9785,
          category: 'Psychiatry',
          distanceMeters: 240,
        ),
      ],
    );

    expect(markers.length, 3);
    expect(markers.first.point, const LatLng(37.5665, 126.9780));
    expect(markers[1].point, const LatLng(37.5667, 126.9782));
    expect(markers[2].point, const LatLng(37.5670, 126.9785));
  });
}
