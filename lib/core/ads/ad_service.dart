import 'package:flutter/widgets.dart';
import 'package:vibemental_app/core/config/ad_config.dart';

/// Purpose: Abstract ad provider behavior behind an interface for testability
/// and dependency inversion.
abstract class AdService {
  /// Purpose: Initialize ad SDK resources safely before first ad usage.
  Future<void> initialize();

  /// Purpose: Check whether a banner can be shown for a specific placement.
  bool canShowBanner(AdPlacement placement);

  /// Purpose: Build one banner widget for a placement with graceful fallback.
  Widget buildBanner({required AdPlacement placement});
}
