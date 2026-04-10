import 'package:flutter/material.dart';

/// Supported locales for top 25 GDP countries
/// 17 unique languages covering 25 major economies
class SupportedLocales {
  /// All supported locale codes
  static const List<String> localeCodes = [
    'en', // English - US, UK, Canada, Australia, Ireland
    'zh', // Chinese (Simplified) - China
    'de', // German - Germany, Switzerland
    'ja', // Japanese - Japan
    'hi', // Hindi - India
    'fr', // French - France, Canada, Belgium, Switzerland
    'pt', // Portuguese - Brazil
    'it', // Italian - Italy, Switzerland
    'ru', // Russian - Russia
    'es', // Spanish - Mexico, Spain, Argentina
    'ko', // Korean - South Korea
    'id', // Indonesian - Indonesia
    'nl', // Dutch - Netherlands, Belgium
    'ar', // Arabic - Saudi Arabia
    'tr', // Turkish - Turkey
    'pl', // Polish - Poland
    'sv', // Swedish - Sweden
  ];

  /// Flutter Locale objects
  static List<Locale> get locales => 
      localeCodes.map((code) => Locale(code)).toList();

  /// Locale names for display
  static const Map<String, String> localeNames = {
    'en': 'English',
    'zh': '中文',
    'de': 'Deutsch',
    'ja': '日本語',
    'hi': 'हिन्दी',
    'fr': 'Français',
    'pt': 'Português',
    'it': 'Italiano',
    'ru': 'Русский',
    'es': 'Español',
    'ko': '한국어',
    'id': 'Bahasa Indonesia',
    'nl': 'Nederlands',
    'ar': 'العربية',
    'tr': 'Türkçe',
    'pl': 'Polski',
    'sv': 'Svenska',
  };

  /// Check if locale is supported
  static bool isSupported(Locale locale) {
    return localeCodes.contains(locale.languageCode);
  }

  /// Get fallback locale (English)
  static Locale get fallbackLocale => const Locale('en');
}
