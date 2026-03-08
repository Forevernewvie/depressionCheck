import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vibemental_app/core/time/clock.dart';
import 'package:vibemental_app/features/map/application/models/nearby_clinic_load_result.dart';
import 'package:vibemental_app/features/map/domain/clinic.dart';
import 'package:vibemental_app/features/map/presentation/map_presentation_policy.dart';

void main() {
  late MapPresentationPolicy policy;

  setUp(() {
    policy = MapPresentationPolicy(_FakeClock(DateTime.utc(2026, 3, 8, 9)));
  });

  test('visibleClinics prioritizes specialist filter and distance fallback', () {
    final clinics = <Clinic>[
      const Clinic(
        name: 'Far Specialist',
        latitude: 37.0,
        longitude: 127.0,
        category: 'Mental Health Clinic',
        distanceMeters: 1200,
        specialistAvailability: ClinicSpecialistAvailability.available,
      ),
      const Clinic(
        name: 'Near General',
        latitude: 37.0,
        longitude: 127.0,
        category: 'Mental Health Clinic',
        distanceMeters: 150,
        specialistAvailability: ClinicSpecialistAvailability.unavailable,
      ),
    ];

    final visible = policy.visibleClinics(
      clinics: clinics,
      specialistOnly: true,
      openNowOnly: false,
      sortOption: ClinicSortOption.specialist,
    );

    expect(visible.map((clinic) => clinic.name), <String>['Far Specialist']);
  });

  test('primaryActionKind opens settings when permission is denied forever', () {
    expect(
      policy.primaryActionKind(NearbyClinicStatus.permissionDeniedForever),
      MapPrimaryActionKind.openSettings,
    );
    expect(
      policy.primaryActionIcon(MapPrimaryActionKind.openSettings),
      Icons.settings_outlined,
    );
  });
}

class _FakeClock implements Clock {
  _FakeClock(this._now);

  final DateTime _now;

  @override
  /// Purpose: Return a deterministic timestamp for map policy tests.
  DateTime now() {
    return _now;
  }
}
