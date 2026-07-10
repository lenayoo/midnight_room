import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'app.dart';
import 'features/ads/models/admob_ids.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (AdMobIds.supportsMobileAds &&
      !AdMobIds.isUsingTestAdUnits &&
      !AdMobIds.hasProductionBannerAdUnit) {
    debugPrint(
      '[AdMob] Production banner ads are disabled because no production banner ad unit ID was provided for this platform.',
    );
  }

  if (AdMobIds.shouldLoadAds) {
    final InitializationStatus status = await MobileAds.instance.initialize();
    debugPrint(
      '[AdMob] MobileAds initialized for ${status.adapterStatuses.length} adapter(s); banner mode: ${AdMobIds.bannerAdModeLabel}.',
    );
  }

  runApp(const SoundscapeDaysApp());
}
