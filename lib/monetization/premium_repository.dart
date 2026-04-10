import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/debug_flags.dart';

/// Unified PremiumRepository for IAP across all apps
/// Handles purchase streams, verification, and premium state
/// 
/// Note: In-App Purchase only supports Android and iOS.
/// On web, this repository gracefully disables itself.
class PremiumRepository {
  static final PremiumRepository _instance = PremiumRepository._internal();
  factory PremiumRepository() => _instance;
  PremiumRepository._internal();

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  final _premiumController = StreamController<bool>.broadcast();
  Stream<bool> get premiumStream => _premiumController.stream;

  bool _isPremium = false;
  bool get isPremium => _isPremium;

  String? _productId;
  ProductDetails? _productDetails;
  bool _isWeb = false;

  /// Initialize with product ID
  Future<void> initialize(String productId) async {
    _productId = productId;
    _isWeb = kIsWeb;

    // Skip IAP on web platform
    if (_isWeb) {
      debugPrint('PremiumRepository: Web platform detected - IAP disabled');
      _isPremium = false;
      _premiumController.add(false);
      return;
    }

    if (DebugFlags.bypassPremiumCheck) {
      _isPremium = false;
      _premiumController.add(false);
      return;
    }

    // Load saved premium state
    final prefs = await SharedPreferences.getInstance();
    _isPremium = prefs.getBool('is_premium') ?? false;
    _premiumController.add(_isPremium);

    // Check if IAP is available
    final bool available = await _iap.isAvailable();
    if (!available) {
      debugPrint('PremiumRepository: IAP not available');
      return;
    }

    // Listen to purchase stream
    _subscription = _iap.purchaseStream.listen(
      _onPurchaseUpdate,
      onDone: () => _subscription?.cancel(),
    );

    // Query product details
    await _loadProductDetails();

    // Restore previous purchases
    await restorePurchases();
  }

  /// Load product details from store
  Future<void> _loadProductDetails() async {
    if (_isWeb) return;
    if (_productId == null) return;

    final ProductDetailsResponse response =
        await _iap.queryProductDetails({_productId!});

    if (response.notFoundIDs.isNotEmpty) {
      debugPrint('PremiumRepository: Product not found: $_productId');
      return;
    }

    _productDetails = response.productDetails.first;
    debugPrint('PremiumRepository: Product loaded: ${_productDetails?.title}');
  }

  /// Handle purchase updates
  void _onPurchaseUpdate(List<PurchaseDetails> purchases) {
    if (_isWeb) return;
    for (final purchase in purchases) {
      switch (purchase.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          _verifyAndDeliverPurchase(purchase);
          break;
        case PurchaseStatus.error:
          debugPrint('PremiumRepository: Purchase error: ${purchase.error}');
          break;
        case PurchaseStatus.pending:
          debugPrint('PremiumRepository: Purchase pending');
          break;
        case PurchaseStatus.canceled:
          debugPrint('PremiumRepository: Purchase canceled');
          break;
      }
    }
  }

  /// Verify and deliver purchase
  Future<void> _verifyAndDeliverPurchase(PurchaseDetails purchase) async {
    if (_isWeb) return;
    // Verify product ID matches
    if (purchase.productID != _productId) return;

    // Deliver premium
    await _setPremium(true);

    // Complete purchase
    if (purchase.pendingCompletePurchase) {
      await _iap.completePurchase(purchase);
    }

    debugPrint('PremiumRepository: Purchase verified and delivered');
  }

  /// Set premium state
  Future<void> _setPremium(bool value) async {
    _isPremium = value;
    _premiumController.add(value);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_premium', value);
  }

  /// Purchase premium
  Future<bool> purchasePremium() async {
    if (_isWeb) {
      debugPrint('PremiumRepository: Purchase not available on web');
      return false;
    }
    if (_productDetails == null) {
      debugPrint('PremiumRepository: Product not loaded');
      return false;
    }

    if (_isPremium) return true;

    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: _productDetails!,
    );

    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    return true;
  }

  /// Restore purchases
  Future<bool> restorePurchases() async {
    if (_isWeb) {
      debugPrint('PremiumRepository: Restore not available on web');
      return _isPremium;
    }
    await _iap.restorePurchases();
    return _isPremium;
  }

  /// Get formatted price
  String? get price => _productDetails?.price;

  /// Get product description
  String? get description => _productDetails?.description;

  /// Dispose
  void dispose() {
    _subscription?.cancel();
    _premiumController.close();
  }
}
