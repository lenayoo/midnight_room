import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../models/admob_ids.dart';

class TopBannerAd extends StatefulWidget {
  const TopBannerAd({super.key});

  @override
  State<TopBannerAd> createState() => _TopBannerAdState();
}

class _TopBannerAdState extends State<TopBannerAd> {
  static const int _maxLoadAttempts = 3;

  BannerAd? _bannerAd;
  bool _isLoaded = false;
  int _loadAttempts = 0;

  @override
  void initState() {
    super.initState();
    if (AdMobIds.shouldLoadAds) {
      _loadBannerAd();
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  void _loadBannerAd() {
    if (_loadAttempts >= _maxLoadAttempts) {
      debugPrint(
        '[AdMob] Banner load aborted after $_loadAttempts attempt(s) for ${AdMobIds.bannerAdUnitId}.',
      );
      return;
    }
    _loadAttempts += 1;
    debugPrint(
      '[AdMob] Loading banner attempt $_loadAttempts/$_maxLoadAttempts for ${AdMobIds.bannerAdUnitId}.',
    );

    final BannerAd bannerAd = BannerAd(
      adUnitId: AdMobIds.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }

          setState(() {
            _bannerAd = ad as BannerAd;
            _isLoaded = true;
          });
          debugPrint('[AdMob] Banner loaded for ${AdMobIds.bannerAdUnitId}.');
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          debugPrint(
            '[AdMob] Banner failed for ${AdMobIds.bannerAdUnitId}: $error',
          );
          ad.dispose();
          if (!mounted || _loadAttempts >= _maxLoadAttempts) {
            return;
          }

          Future<void>.delayed(const Duration(milliseconds: 800), () {
            if (!mounted || _bannerAd != null) {
              return;
            }
            _loadBannerAd();
          });
        },
        onAdImpression: (Ad ad) {
          debugPrint(
            '[AdMob] Banner impression for ${AdMobIds.bannerAdUnitId}.',
          );
        },
      ),
    );

    bannerAd.load();
  }

  @override
  Widget build(BuildContext context) {
    if (!AdMobIds.shouldLoadAds) {
      return const SizedBox.shrink();
    }

    final BannerAd? bannerAd = _bannerAd;
    if (!_isLoaded || bannerAd == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Align(
        alignment: Alignment.topCenter,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: SizedBox(
            width: bannerAd.size.width.toDouble(),
            height: bannerAd.size.height.toDouble(),
            child: AdWidget(ad: bannerAd),
          ),
        ),
      ),
    );
  }
}
