import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'app.dart';
import 'features/ads/models/admob_ids.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (AdMobIds.shouldLoadAds) {
    final InitializationStatus status = await MobileAds.instance.initialize();
    debugPrint(
      '[AdMob] MobileAds initialized for ${status.adapterStatuses.length} adapter(s).',
    );
  }

  runApp(const SoundscapeDaysApp());
}
