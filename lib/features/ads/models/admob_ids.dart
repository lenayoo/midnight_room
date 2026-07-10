import 'package:flutter/foundation.dart';

class AdMobIds {
  const AdMobIds._();

  static const String androidAppId = 'ca-app-pub-3940256099942544~3347511713';
  static const String iosAppId = 'ca-app-pub-7195864152055881~1402843474';

  static const String androidBannerAdUnitId =
      'ca-app-pub-3940256099942544/6300978111';
  static const String iosBannerAdUnitId =
      'ca-app-pub-7195864152055881/9309253650';

  static bool get supportsMobileAds {
    if (kIsWeb) {
      return false;
    }

    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  static bool get shouldLoadAds {
    if (!supportsMobileAds) {
      return false;
    }

    return bannerAdUnitId.trim().isNotEmpty;
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
