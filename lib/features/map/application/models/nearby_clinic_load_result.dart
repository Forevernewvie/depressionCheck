import 'package:latlong2/latlong.dart';
import 'package:vibemental_app/features/map/domain/clinic.dart';

/// Purpose: Enumerate user-facing status outcomes of nearby clinic loading.
enum NearbyClinicStatus {
  realtimeLoaded,
  noResultFallback,
  networkFallback,
  permissionDenied,
  permissionDeniedForever,
  unavailable,
}

/// Purpose: Carry full map payload and status from application layer to UI.
class NearbyClinicLoadResult {
  const NearbyClinicLoadResult({
    required this.center,
    required this.clinics,
    required this.status,
  });

  final LatLng center;
  final List<Clinic> clinics;
  final NearbyClinicStatus status;
}
