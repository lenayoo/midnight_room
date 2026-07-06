import 'package:flutter/foundation.dart';

class AdMobIds {
  const AdMobIds._();

  static const String _androidTestBannerAdUnitId =
      'ca-app-pub-3940256099942544/6300978111';
  static const String _iosTestBannerAdUnitId =
      'ca-app-pub-3940256099942544/2934735716';

  static const String androidBannerAdUnitId = String.fromEnvironment(
    'ADMOB_ANDROID_BANNER_AD_UNIT_ID',
  );
  static const String iosBannerAdUnitId = String.fromEnvironment(
    'ADMOB_IOS_BANNER_AD_UNIT_ID',
  );

  static const Set<String> _testBannerAdUnitIds = <String>{
    _androidTestBannerAdUnitId,
    _iosTestBannerAdUnitId,
  };

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

    final String bannerAdUnitId = _platformBannerAdUnitId.trim();
    if (bannerAdUnitId.isEmpty) {
      return false;
    }

    if (!kReleaseMode) {
      return true;
    }

    return _isLiveId(bannerAdUnitId, _testBannerAdUnitIds);
  }

  static String get bannerAdUnitId {
    return _platformBannerAdUnitId;
  }

  static String get _platformBannerAdUnitId {
    if (!kReleaseMode) {
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          return _androidTestBannerAdUnitId;
        case TargetPlatform.iOS:
          return _iosTestBannerAdUnitId;
        default:
          throw UnsupportedError(
            'Banner ads are only configured for iOS and Android.',
          );
      }
    }

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

  static bool _isLiveId(String value, Set<String> knownTestIds) {
    final String normalized = value.trim();
    return normalized.isNotEmpty && !knownTestIds.contains(normalized);
  }
}
