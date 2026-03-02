import 'package:flutter/widgets.dart';
import 'package:vibemental_app/core/ads/ad_service.dart';
import 'package:vibemental_app/core/config/ad_config.dart';

/// Purpose: Provide deterministic ad behavior for widget tests without SDK
/// dependencies.
class FakeAdService implements AdService {
  FakeAdService({Set<AdPlacement>? enabledPlacements})
    : _enabledPlacements =
          enabledPlacements ??
          <AdPlacement>{
            AdPlacement.homeBottomBanner,
            AdPlacement.modulesBottomBanner,
          };

  final Set<AdPlacement> _enabledPlacements;

  @override
  Future<void> initialize() async {}

  @override
  bool canShowBanner(AdPlacement placement) {
    return _enabledPlacements.contains(placement);
  }

  @override
  Widget buildBanner({required AdPlacement placement}) {
    if (!canShowBanner(placement)) {
      return const SizedBox.shrink();
    }
    return SizedBox(key: Key('fake_ad_${placement.name}'), height: 1, width: 1);
  }
}
