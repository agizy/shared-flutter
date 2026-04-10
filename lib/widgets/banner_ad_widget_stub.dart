import 'package:flutter/material.dart';

/// Stub classes for web platform where google_mobile_ads is not available

/// Stub BannerAd class for web
class BannerAd {
  final AdSize size;
  
  BannerAd({
    required this.size,
    required String adUnitId,
    required AdRequest request,
    required BannerAdListener listener,
  });

  void load() {}
  void dispose() {}
}

/// Stub AdSize class for web
class AdSize {
  final int width;
  final int height;

  const AdSize({required this.width, required this.height});

  static const AdSize banner = AdSize(width: 320, height: 50);
}

/// Stub AdRequest class for web
class AdRequest {
  const AdRequest();
}

/// Stub BannerAdListener class for web
class BannerAdListener {
  final void Function(dynamic ad)? onAdLoaded;
  final void Function(dynamic ad, dynamic error)? onAdFailedToLoad;

  const BannerAdListener({
    this.onAdLoaded,
    this.onAdFailedToLoad,
  });
}

/// Stub AdWidget class for web
class AdWidget extends StatelessWidget {
  final dynamic ad;

  const AdWidget({super.key, required this.ad});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
