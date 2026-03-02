import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:vibemental_app/core/ads/ad_service.dart';
import 'package:vibemental_app/core/config/ad_config.dart';
import 'package:vibemental_app/core/config/app_env.dart';
import 'package:vibemental_app/core/logging/app_logger.dart';

/// Purpose: Implement AdService using Google Mobile Ads SDK with defensive
/// loading behavior and safe fallbacks.
class GoogleMobileAdsService implements AdService {
  GoogleMobileAdsService(this._logger);

  final AppLogger _logger;
  bool _initialized = false;

  @override
  Future<void> initialize() async {
    if (_initialized || !AdConfig.adsEnabled) {
      return;
    }

    try {
      await MobileAds.instance.initialize();
      _initialized = true;
      _logger.info('Mobile Ads SDK initialized.');
    } catch (error, stackTrace) {
      _logger.error(
        'Mobile Ads SDK initialization failed.',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  bool canShowBanner(AdPlacement placement) {
    return AdConfig.isPlacementEnabled(placement);
  }

  @override
  Widget buildBanner({required AdPlacement placement}) {
    if (!canShowBanner(placement)) {
      return const SizedBox.shrink();
    }

    return _BannerAdSlot(
      adUnitId: _bannerAdUnitId,
      logger: _logger,
      placement: placement,
    );
  }

  /// Purpose: Resolve test-vs-release banner unit to avoid policy violations.
  String get _bannerAdUnitId {
    if (!kReleaseMode) {
      return AdConfig.debugTestBannerAdUnitId;
    }
    return AppEnv.adMobBannerAdUnitId;
  }
}

class _BannerAdSlot extends StatefulWidget {
  const _BannerAdSlot({
    required this.adUnitId,
    required this.logger,
    required this.placement,
  });

  final String adUnitId;
  final AppLogger logger;
  final AdPlacement placement;

  @override
  State<_BannerAdSlot> createState() => _BannerAdSlotState();
}

class _BannerAdSlotState extends State<_BannerAdSlot> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadBanner();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  /// Purpose: Load a banner ad and keep failures non-blocking for UI flow.
  void _loadBanner() {
    final bannerAd = BannerAd(
      adUnitId: widget.adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() {
            _bannerAd = ad as BannerAd;
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          widget.logger.warn(
            'Banner ad failed to load.',
            context: {
              'placement': widget.placement.name,
              'errorCode': error.code,
              'errorDomain': error.domain,
            },
          );
        },
      ),
    );

    bannerAd.load();
  }

  @override
  /// Purpose: Render a loaded banner only; otherwise keep layout unobstructed.
  Widget build(BuildContext context) {
    if (!_isLoaded || _bannerAd == null) {
      return const SizedBox.shrink();
    }

    return Center(
      child: SizedBox(
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      ),
    );
  }
}
