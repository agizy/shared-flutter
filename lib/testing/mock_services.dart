/// Mock service implementations for testing
/// 
/// Provides mocks for:
/// - AdService
/// - PremiumRepository
/// - AnalyticsService
/// - SharedPreferences
/// - Hive boxes
library;

import 'package:mocktail/mocktail.dart';
import 'package:shared/monetization/ad_service.dart';
import 'package:shared/monetization/premium_repository.dart';

/// Mock implementation of AdService for testing
class MockAdService extends Mock implements AdService {
  bool _initialized = false;
  bool _bannerShown = false;
  bool _interstitialReady = false;

  void setupDefaults() {
    when(() => initialize()).thenAnswer((_) async {
      _initialized = true;
    });
    when(() => dispose()).thenAnswer((_) async {
      _initialized = false;
    });
    when(() => showBannerAd()).thenAnswer((_) async {
      _bannerShown = true;
    });
    when(() => hideBannerAd()).thenAnswer((_) async {
      _bannerShown = false;
    });
    when(() => loadInterstitialAd()).thenAnswer((_) async {
      _interstitialReady = true;
    });
    when(() => showInterstitialAd()).thenAnswer((_) async {
      _interstitialReady = false;
    });
    when(() => isInterstitialAdLoaded()).thenReturn(_interstitialReady);
  }
}

/// Mock implementation of PremiumRepository for testing
class MockPremiumRepository extends Mock implements PremiumRepository {
  bool _isPremium = false;
  final List<VoidCallback> _listeners = [];

  void setupDefaults({bool isPremium = false}) {
    _isPremium = isPremium;
    
    when(() => initialize(any())).thenAnswer((_) async {});
    when(() => isPremium).thenReturn(_isPremium);
    when(() => isPremiumAsync()).thenAnswer((_) async => _isPremium);
    when(() => purchasePremium()).thenAnswer((_) async {
      _isPremium = true;
      _notifyListeners();
    });
    when(() => restorePurchases()).thenAnswer((_) async {
      _isPremium = true;
      _notifyListeners();
    });
    when(() => addListener(any())).thenAnswer((invocation) {
      _listeners.add(invocation.positionalArguments[0] as VoidCallback);
    });
    when(() => removeListener(any())).thenAnswer((invocation) {
      _listeners.remove(invocation.positionalArguments[0] as VoidCallback);
    });
    when(() => dispose()).thenAnswer((_) async {});
  }

  void setPremium(bool value) {
    _isPremium = value;
    _notifyListeners();
  }

  void _notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }
}

/// Mock box for testing Hive storage
class MockHiveBox<T> extends Mock {
  final Map<String, T> _storage = {};

  void setupDefaults() {
    when(() => get(any())).thenAnswer((invocation) {
      final key = invocation.positionalArguments[0] as String;
      return _storage[key];
    });
    when(() => get(any(), defaultValue: any(named: 'defaultValue'))).thenAnswer((invocation) {
      final key = invocation.positionalArguments[0] as String;
      final defaultValue = invocation.namedArguments[const Symbol('defaultValue')];
      return _storage[key] ?? defaultValue;
    });
    when(() => put(any(), any())).thenAnswer((invocation) async {
      final key = invocation.positionalArguments[0] as String;
      final value = invocation.positionalArguments[1] as T;
      _storage[key] = value;
    });
    when(() => delete(any())).thenAnswer((invocation) async {
      final key = invocation.positionalArguments[0] as String;
      _storage.remove(key);
    });
    when(() => containsKey(any())).thenAnswer((invocation) {
      final key = invocation.positionalArguments[0] as String;
      return _storage.containsKey(key);
    });
    when(() => clear()).thenAnswer((_) async {
      _storage.clear();
    });
    when(() => keys).thenReturn(_storage.keys.toList());
    when(() => values).thenReturn(_storage.values.toList());
    when(() => length).thenReturn(_storage.length);
    when(() => isEmpty).thenReturn(_storage.isEmpty);
    when(() => isNotEmpty).thenReturn(_storage.isNotEmpty);
  }

  void setValue(String key, T value) {
    _storage[key] = value;
  }

  T? getValue(String key) => _storage[key];

  void clearStorage() => _storage.clear();
}

/// Helper to initialize mocks for testing
class TestServiceLocator {
  late MockAdService adService;
  late MockPremiumRepository premiumRepository;
  late MockHiveBox settingsBox;
  late MockHiveBox favoritesBox;

  void init() {
    adService = MockAdService()..setupDefaults();
    premiumRepository = MockPremiumRepository()..setupDefaults();
    settingsBox = MockHiveBox<dynamic>()..setupDefaults();
    favoritesBox = MockHiveBox<dynamic>()..setupDefaults();
  }

  void reset() {
    adService.setupDefaults();
    premiumRepository.setupDefaults();
    settingsBox.clearStorage();
    favoritesBox.clearStorage();
  }
}

/// Setup function for widget tests that need services
void setupServiceMocks() {
  // Register fallback values for mocktail
  registerFallbackValue(const Duration(seconds: 1));
  registerFallbackValue(DateTime.now());
  registerFallbackValue('');
  registerFallbackValue(0);
  registerFallbackValue(false);
}
