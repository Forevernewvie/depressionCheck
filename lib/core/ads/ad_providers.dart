import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibemental_app/core/ads/ad_service.dart';
import 'package:vibemental_app/core/logging/logging_providers.dart';
import 'package:vibemental_app/infrastructure/ads/google_mobile_ads_service.dart';

/// Purpose: Provide AdService implementation through dependency inversion.
final adServiceProvider = Provider<AdService>((ref) {
  return GoogleMobileAdsService(ref.watch(appLoggerProvider));
});
