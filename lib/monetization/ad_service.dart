import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/debug_flags.dart';

// Conditionally import mobile ads - only available on mobile platforms
import 'ad_service_mobile.dart' if (dart.library.html) 'ad_service_web.dart';

/// Unified AdService with frequency capping and grace period
/// Used across all apps
/// 
/// Note: Google Mobile Ads only supports Android and iOS.
/// On web, this service gracefully disables itself.
class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  final _mobileAdService = MobileAdServiceImpl();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // Frequency capping
  int _interactionCount = 0;
  static const String _interactionCountKey = 'ad_interaction_count';
  static const String _firstOpenKey = 'ad_first_open_date';
  static const int _gracePeriodDays = 3;

  /// Initialize the ad service
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Skip on web platform - ads not supported
    if (kIsWeb) {
      debugPrint('AdService: Web platform detected - ads disabled');
      _isInitialized = true;
      return;
    }

    await _mobileAdService.initialize();
    await _loadCounters();
    _isInitialized = true;

    debugPrint('AdService: Initialized');
  }

  /// Load interaction counters
  Future<void> _loadCounters() async {
    final prefs = await SharedPreferences.getInstance();
    _interactionCount = prefs.getInt(_interactionCountKey) ?? 0;
  }

  /// Check if user is in grace period (first 3 days)
  Future<bool> isInGracePeriod() async {
    final prefs = await SharedPreferences.getInstance();
    final firstOpen = prefs.getInt(_firstOpenKey);

    if (firstOpen == null) {
      await prefs.setInt(_firstOpenKey, DateTime.now().millisecondsSinceEpoch);
      return true;
    }

    final firstOpenDate = DateTime.fromMillisecondsSinceEpoch(firstOpen);
    final daysSinceFirstOpen = DateTime.now().difference(firstOpenDate).inDays;

    return daysSinceFirstOpen < _gracePeriodDays;
  }

  /// Check if ads should be shown (frequency capping)
  Future<bool> shouldShowAd(int frequency) async {
    if (kIsWeb) return false;
    if (DebugFlags.disableAds) return false;
    if (await isInGracePeriod()) return false;

    _interactionCount++;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_interactionCountKey, _interactionCount);

    return _interactionCount % frequency == 0;
  }

  /// Load a banner ad
  Future<dynamic> loadBannerAd() async {
    if (kIsWeb) return null;
    if (DebugFlags.disableAds) return null;
    return _mobileAdService.loadBannerAd();
  }

  /// Load an interstitial ad
  Future<void> loadInterstitialAd() async {
    if (kIsWeb) return;
    if (DebugFlags.disableAds) return;
    return _mobileAdService.loadInterstitialAd();
  }

  /// Show interstitial ad if ready
  Future<void> showInterstitialAd() async {
    if (kIsWeb) return;
    return _mobileAdService.showInterstitialAd();
  }

  /// Load a rewarded ad
  Future<void> loadRewardedAd() async {
    if (kIsWeb) return;
    if (DebugFlags.disableAds) return;
    return _mobileAdService.loadRewardedAd();
  }

  /// Show rewarded ad with callback
  Future<void> showRewardedAd({required Function(String) onReward}) async {
    if (kIsWeb) return;
    return _mobileAdService.showRewardedAd(onReward: onReward);
  }

  /// Dispose all ads
  void dispose() {
    if (kIsWeb) return;
    _mobileAdService.dispose();
  }
}
