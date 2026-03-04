import 'package:flutter/widgets.dart';
import 'package:vibemental_app/core/ads/ad_service.dart';
import 'package:vibemental_app/core/config/ad_config.dart';

/// Purpose: Provide a web-safe ad service that keeps app flow stable when
/// mobile ad plugins are unavailable.
class NoopAdService implements AdService {
  const NoopAdService();

  @override
  /// Purpose: Skip SDK setup while keeping initialization contracts intact.
  Future<void> initialize() async {}

  @override
  /// Purpose: Disable banner rendering for all placements on unsupported
  /// platforms.
  bool canShowBanner(AdPlacement placement) {
    return false;
  }

  @override
  /// Purpose: Return an empty widget to preserve layout without ads.
  Widget buildBanner({required AdPlacement placement}) {
    return const SizedBox.shrink();
  }
}
