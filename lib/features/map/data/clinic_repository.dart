import 'package:vibemental_app/core/config/app_env.dart';
import 'package:vibemental_app/features/map/domain/clinic.dart';
import 'package:vibemental_app/core/result/app_result.dart';

/// Purpose: Define clinic data contract decoupled from concrete network/storage
/// implementations.
abstract class ClinicRepository {
  /// Purpose: Fetch nearby clinics around a coordinate using remote or local
  /// data providers.
  Future<AppResult<List<Clinic>>> getNearbyClinics({
    required double latitude,
    required double longitude,
    int radiusMeters = AppEnv.defaultClinicSearchRadiusMeters,
  });
}
