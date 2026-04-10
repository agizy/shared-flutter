import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../monetization/ad_service.dart';
import '../monetization/premium_repository.dart';

// Conditionally import AdWidget - only available on mobile
import 'package:google_mobile_ads/google_mobile_ads.dart'
    if (dart.library.html) 'banner_ad_widget_stub.dart';

/// Reusable Banner Ad Widget
/// Shows ad only if user is not premium and frequency allows
/// Automatically disabled on web platform
class BannerAdWidget extends StatefulWidget {
  final int frequency;

  const BannerAdWidget({
    super.key,
    this.frequency = 3,
  });

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  dynamic _bannerAd;
  bool _isLoading = true;
  bool _shouldShow = false;
  final _premiumRepo = PremiumRepository();
  final _adService = AdService();

  @override
  void initState() {
    super.initState();
    // Skip ads on web platform
    if (kIsWeb) {
      setState(() => _isLoading = false);
      return;
    }
    _loadAd();
  }

  Future<void> _loadAd() async {
    // Skip on web
    if (kIsWeb) {
      setState(() => _isLoading = false);
      return;
    }

    // Check if premium
    if (_premiumRepo.isPremium) {
      setState(() => _isLoading = false);
      return;
    }

    // Check frequency
    final shouldShow = await _adService.shouldShowAd(widget.frequency);
    if (!shouldShow) {
      setState(() => _isLoading = false);
      return;
    }

    // Load banner ad
    final ad = await _adService.loadBannerAd();
    if (mounted) {
      setState(() {
        _bannerAd = ad;
        _shouldShow = ad != null;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    // Only dispose if not on web
    if (!kIsWeb && _bannerAd != null) {
      _bannerAd.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Return empty on web
    if (kIsWeb) {
      return const SizedBox.shrink();
    }

    if (_isLoading) {
      return const SizedBox(
        height: 50,
        child: Center(
          child: SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    if (!_shouldShow || _bannerAd == null) {
      return const SizedBox.shrink();
    }

    // Use AdWidget only on mobile platforms
    return Container(
      alignment: Alignment.center,
      width: _bannerAd.size.width.toDouble(),
      height: _bannerAd.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd),
    );
  }
}
