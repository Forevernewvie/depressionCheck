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
        specialistAvailability: ClinicSpecialistAvailability.available,
        specialistInfoSource: 'fallback_seed',
        openingHoursByDay: <int, String>{
          DateTime.monday: '09:00-18:00',
          DateTime.tuesday: '09:00-18:00',
          DateTime.wednesday: '09:00-18:00',
          DateTime.thursday: '09:00-18:00',
          DateTime.friday: '09:00-18:00',
        },
        timezone: 'Asia/Seoul',
      ),
      Clinic(
        name: 'City Mental Health Center',
        latitude: 37.5612,
        longitude: 126.9755,
        category: 'Counseling + Psychiatry',
        distanceMeters: 1900,
        phone: '0211112222',
        address: 'Jung-gu, Seoul',
        specialistAvailability: ClinicSpecialistAvailability.unknown,
        specialistInfoSource: 'fallback_seed',
        openingHoursByDay: <int, String>{
          DateTime.monday: '09:30-17:30',
          DateTime.tuesday: '09:30-17:30',
          DateTime.wednesday: '09:30-17:30',
          DateTime.thursday: '09:30-17:30',
          DateTime.friday: '09:30-17:30',
        },
        timezone: 'Asia/Seoul',
      ),
      Clinic(
        name: 'Central General Hospital',
        latitude: 37.5725,
        longitude: 126.9698,
        category: 'Emergency + Psychiatry',
        distanceMeters: 2800,
        phone: '021199',
        address: 'Sejong-daero, Seoul',
        specialistAvailability: ClinicSpecialistAvailability.available,
        specialistInfoSource: 'fallback_seed',
        openingHoursByDay: <int, String>{
          DateTime.monday: '00:00-23:59',
          DateTime.tuesday: '00:00-23:59',
          DateTime.wednesday: '00:00-23:59',
          DateTime.thursday: '00:00-23:59',
          DateTime.friday: '00:00-23:59',
          DateTime.saturday: '00:00-23:59',
          DateTime.sunday: '00:00-23:59',
        },
        openNow: true,
        timezone: 'Asia/Seoul',
      ),
    ];
  }
}
