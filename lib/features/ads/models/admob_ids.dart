import 'package:flutter/foundation.dart';

import 'admob_ids.local.dart';

class AdMobIds {
  const AdMobIds._();

  static const String androidAppId = AdMobLocalIds.androidAppId;
  static const String iosAppId = AdMobLocalIds.iosAppId;

  static const String androidBannerAdUnitId =
      AdMobLocalIds.androidBannerAdUnitId;
  static const String iosBannerAdUnitId = AdMobLocalIds.iosBannerAdUnitId;

  static bool get supportsMobileAds {
    if (kIsWeb) {
      return false;
    }

    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  static String get bannerAdUnitId {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return androidBannerAdUnitId;
      case TargetPlatform.iOS:
        return iosBannerAdUnitId;
      default:
        throw UnsupportedError(
          'Banner ads are only configured for iOS and Android.',
        );
    }
  }
}
