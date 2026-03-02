/// Purpose: Define AdMob placement identifiers used across presentation and
/// infrastructure layers.
enum AdPlacement { homeBottomBanner, modulesBottomBanner }

/// Purpose: Hold typed ad-related configuration values and placement policy.
class AdConfig {
  AdConfig._();

  /// Purpose: Enable or disable ad rendering globally through build-time env.
  static const bool adsEnabled = bool.fromEnvironment(
    'ADS_ENABLED',
    defaultValue: true,
  );

  /// Purpose: Control whether home bottom placement is active.
  static const bool homeBannerEnabled = bool.fromEnvironment(
    'ADS_HOME_BANNER_ENABLED',
    defaultValue: true,
  );

  /// Purpose: Control whether modules bottom placement is active.
  static const bool modulesBannerEnabled = bool.fromEnvironment(
    'ADS_MODULES_BANNER_ENABLED',
    defaultValue: true,
  );

  /// Purpose: Google-provided test banner ad unit ID for safe debug usage.
  static const String debugTestBannerAdUnitId =
      'ca-app-pub-3940256099942544/6300978111';

  /// Purpose: Resolve whether a placement is policy-approved for rendering.
  static bool isPlacementEnabled(AdPlacement placement) {
    if (!adsEnabled) {
      return false;
    }
    return switch (placement) {
      AdPlacement.homeBottomBanner => homeBannerEnabled,
      AdPlacement.modulesBottomBanner => modulesBannerEnabled,
    };
  }
}
