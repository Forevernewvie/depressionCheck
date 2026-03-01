import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:vibemental_app/core/logging/logging_providers.dart';
import 'package:vibemental_app/features/map/application/location_service.dart';
import 'package:vibemental_app/features/map/application/nearby_clinic_service.dart';
import 'package:vibemental_app/features/map/data/clinic_repository.dart';
import 'package:vibemental_app/features/map/data/overpass_clinic_repository.dart';

/// Purpose: Provide an HTTP client singleton per provider lifecycle.
final httpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
});

/// Purpose: Provide repository implementation behind data interface.
final clinicRepositoryProvider = Provider<ClinicRepository>((ref) {
  final client = ref.watch(httpClientProvider);
  final logger = ref.watch(appLoggerProvider);
  return OverpassClinicRepository(client: client, logger: logger);
});

/// Purpose: Provide location service implementation behind application interface.
final locationServiceProvider = Provider<LocationService>((ref) {
  final logger = ref.watch(appLoggerProvider);
  return GeolocatorLocationService(logger);
});

/// Purpose: Provide map loading orchestrator used by presentation layer.
final nearbyClinicServiceProvider = Provider<NearbyClinicService>((ref) {
  return NearbyClinicService(
    locationService: ref.watch(locationServiceProvider),
    repository: ref.watch(clinicRepositoryProvider),
    logger: ref.watch(appLoggerProvider),
  );
});
