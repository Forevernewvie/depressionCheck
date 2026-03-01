import 'package:vibemental_app/features/map/domain/clinic.dart';

/// Purpose: Provide deterministic fallback clinics when location/network is unavailable.
class FallbackClinics {
  const FallbackClinics._();

  /// Purpose: Return static fallback clinics that keep help-seeking paths available offline.
  static List<Clinic> build() {
    return const [
      Clinic(
        name: 'Seoul Mind Clinic',
        latitude: 37.5701,
        longitude: 126.9838,
        category: 'Psychiatry',
        distanceMeters: 1200,
        phone: '0212345678',
        address: 'Jongno-gu, Seoul',
      ),
      Clinic(
        name: 'City Mental Health Center',
        latitude: 37.5612,
        longitude: 126.9755,
        category: 'Counseling + Psychiatry',
        distanceMeters: 1900,
        phone: '0211112222',
        address: 'Jung-gu, Seoul',
      ),
      Clinic(
        name: 'Central General Hospital',
        latitude: 37.5725,
        longitude: 126.9698,
        category: 'Emergency + Psychiatry',
        distanceMeters: 2800,
        phone: '021199',
        address: 'Sejong-daero, Seoul',
      ),
    ];
  }
}
