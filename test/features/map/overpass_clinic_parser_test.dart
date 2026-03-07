import 'package:flutter_test/flutter_test.dart';
import 'package:vibemental_app/core/time/clock.dart';
import 'package:vibemental_app/features/map/data/overpass/overpass_clinic_parser.dart';
import 'package:vibemental_app/features/map/domain/clinic.dart';

void main() {
  late OverpassClinicParser parser;

  setUp(() {
    parser = OverpassClinicParser(
      clock: _FakeClock(DateTime.utc(2026, 3, 7, 9)),
    );
  });

  test('deduplicates clinics and sorts them by distance', () {
    final clinics = parser.parseNearbyClinics(
      payload: <String, dynamic>{
        'elements': <Map<String, dynamic>>[
          {
            'lat': 37.5665,
            'lon': 126.9780,
            'tags': <String, dynamic>{'name': 'A Clinic', 'amenity': 'clinic'},
          },
          {
            'lat': 37.5665,
            'lon': 126.9780,
            'tags': <String, dynamic>{'name': 'A Clinic', 'amenity': 'clinic'},
          },
          {
            'lat': 37.5765,
            'lon': 126.9880,
            'tags': <String, dynamic>{'name': 'B Clinic', 'amenity': 'clinic'},
          },
        ],
      },
      originLatitude: 37.5665,
      originLongitude: 126.9780,
      maxResults: 10,
    );

    expect(clinics, hasLength(2));
    expect(clinics.first.name, 'A Clinic');
    expect(clinics.last.name, 'B Clinic');
  });

  test('parses specialist availability and 24/7 opening hours', () {
    final clinics = parser.parseNearbyClinics(
      payload: <String, dynamic>{
        'elements': <Map<String, dynamic>>[
          {
            'lat': 37.5665,
            'lon': 126.9780,
            'tags': <String, dynamic>{
              'name': 'Mind Psychiatry',
              'healthcare:specialty': 'psychiatry',
              'opening_hours': '24/7',
            },
          },
        ],
      },
      originLatitude: 37.5665,
      originLongitude: 126.9780,
      maxResults: 10,
    );

    expect(clinics, hasLength(1));
    expect(
      clinics.single.specialistAvailability,
      ClinicSpecialistAvailability.available,
    );
    expect(clinics.single.openingHoursByDay[DateTime.monday], '00:00-23:59');
    expect(clinics.single.dataUpdatedAt, DateTime.utc(2026, 3, 7, 9));
  });
}

/// Purpose: Freeze parser time-dependent behavior for deterministic tests.
class _FakeClock implements Clock {
  _FakeClock(this._now);

  final DateTime _now;

  @override
  DateTime now() {
    return _now;
  }
}
