/// Web stub implementation of ad service
/// Google Mobile Ads is not supported on web, so this is a no-op implementation
class MobileAdServiceImpl {
  Future<void> initialize() async {
    // No-op on web
  }

  Future<dynamic> loadBannerAd() async {
    return null;
  }

  Future<void> loadInterstitialAd() async {
    // No-op on web
  }

  Future<void> showInterstitialAd() async {
    // No-op on web
  }

  Future<void> loadRewardedAd() async {
    // No-op on web
  }

  Future<void> showRewardedAd({required Function(String) onReward}) async {
    // No-op on web
  }

  void dispose() {
    // No-op on web
  }
}
