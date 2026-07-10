import 'package:flutter/foundation.dart';

import 'admob_ids.local.dart';

class AdMobIds {
  const AdMobIds._();

  static const String androidAppId = AdMobLocalIds.androidAppId;
  static const String iosAppId = 'ca-app-pub-7195864152055881~1402843474';

  static const String androidBannerAdUnitId =
      AdMobLocalIds.androidBannerAdUnitId;
  static const String _androidProductionBannerAdUnitId =
      String.fromEnvironment(
        'ADMOB_ANDROID_BANNER_AD_UNIT_ID',
        defaultValue: '',
      );
  static const String _iosProductionBannerAdUnitId = String.fromEnvironment(
    'ADMOB_IOS_BANNER_AD_UNIT_ID',
    defaultValue: 'ca-app-pub-7195864152055881/9309253650',
  );
  static const bool _forceTestAdUnits = bool.fromEnvironment(
    'ADMOB_FORCE_TEST_IDS',
  );

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

  static bool get isUsingTestAdUnits => _forceTestAdUnits || !kReleaseMode;

  static bool get hasProductionBannerAdUnit =>
      productionBannerAdUnitId.trim().isNotEmpty;

  static String get bannerAdModeLabel {
    if (isUsingTestAdUnits) {
      return 'test';
    }

    return hasProductionBannerAdUnit ? 'production' : 'disabled';
  }

  static String get productionBannerAdUnitId {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return _androidProductionBannerAdUnitId;
      case TargetPlatform.iOS:
        return _iosProductionBannerAdUnitId;
      default:
        throw UnsupportedError(
          'Banner ads are only configured for iOS and Android.',
        );
    }
  }

  static String get bannerAdUnitId {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return isUsingTestAdUnits
            ? AdMobLocalIds.androidBannerAdUnitId
            : productionBannerAdUnitId;
      case TargetPlatform.iOS:
        return isUsingTestAdUnits
            ? AdMobLocalIds.iosBannerAdUnitId
            : productionBannerAdUnitId;
      default:
        throw UnsupportedError(
          'Banner ads are only configured for iOS and Android.',
        );
    }
  }
}
