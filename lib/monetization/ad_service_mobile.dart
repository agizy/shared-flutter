import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'debug_flags.dart';

/// Mobile implementation of ad service using Google Mobile Ads
/// Only imported on Android and iOS platforms
class MobileAdServiceImpl {
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  // Ad unit IDs - REPLACE WITH YOUR OWN
  static const String _bannerAdUnitId = DebugFlags.useTestAds
      ? 'ca-app-pub-3940256099942544/6300978111' // Test ID
      : 'YOUR_BANNER_AD_UNIT_ID';

  static const String _interstitialAdUnitId = DebugFlags.useTestAds
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'YOUR_INTERSTITIAL_AD_UNIT_ID';

  static const String _rewardedAdUnitId = DebugFlags.useTestAds
      ? 'ca-app-pub-3940256099942544/5224354917'
      : 'YOUR_REWARDED_AD_UNIT_ID';

  Future<void> initialize() async {
    await MobileAds.instance.initialize();
    debugPrint('MobileAdService: Initialized');
  }

  Future<BannerAd?> loadBannerAd() async {
    final completer = Completer<BannerAd?>();

    BannerAd(
      adUnitId: _bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _bannerAd = ad as BannerAd;
          completer.complete(ad);
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          completer.complete(null);
          debugPrint('Banner ad failed: $error');
        },
      ),
    ).load();

    return completer.future;
  }

  Future<void> loadInterstitialAd() async {
    await InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
          debugPrint('Interstitial ad failed: $error');
        },
      ),
    );
  }

  Future<void> showInterstitialAd() async {
    if (_interstitialAd != null) {
      await _interstitialAd!.show();
      _interstitialAd = null;
    }
  }

  Future<void> loadRewardedAd() async {
    await RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
        },
        onAdFailedToLoad: (error) {
          debugPrint('Rewarded ad failed: $error');
        },
      ),
    );
  }

  Future<void> showRewardedAd({required Function(String) onReward}) async {
    if (_rewardedAd == null) {
      await loadRewardedAd();
      return;
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
      },
    );

    await _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        onReward(reward.type);
      },
    );
  }

  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
  }
}
