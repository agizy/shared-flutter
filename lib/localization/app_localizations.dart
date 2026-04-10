import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'supported_locales.dart';
import 'strings/app_strings.dart';

/// Lightweight localization service for top 25 GDP countries
/// Uses in-memory maps instead of heavy ARB files
class AppLocalizations {
  final Locale locale;
  
  AppLocalizations(this.locale);

  static AppLocalizations? _current;
  static AppLocalizations get current => _current!;

  /// Initialize with locale
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(SupportedLocales.fallbackLocale);
  }

  /// Load translations for current locale
  String translate(String key, {Map<String, String>? params}) {
    final languageCode = locale.languageCode;
    
    // Try current locale
    String? translation = AppStrings.get(key, languageCode);
    
    // Fallback to English
    if (translation == null && languageCode != 'en') {
      translation = AppStrings.get(key, 'en');
    }
    
    // Return key if no translation found
    if (translation == null) return key;
    
    // Replace parameters
    if (params != null) {
      params.forEach((paramKey, value) {
        translation = translation!.replaceAll('{$paramKey}', value);
      });
    }
    
    return translation!;
  }

  /// Short access method
  String tr(String key, {Map<String, String>? params}) => 
      translate(key, params: params);

  /// All localization delegates
  static List<LocalizationsDelegate<dynamic>> get delegates => [
    _AppLocalizationsDelegate(),
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  /// Supported locales for MaterialApp
  static List<Locale> get supportedLocales => SupportedLocales.locales;

  /// Locale resolution callback
  static Locale? localeResolutionCallback(
    Locale? locale,
    Iterable<Locale> supportedLocales,
  ) {
    if (locale == null) return SupportedLocales.fallbackLocale;
    
    // Check exact match
    for (final supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        _current = AppLocalizations(supportedLocale);
        return supportedLocale;
      }
    }
    
    // Return fallback
    _current = AppLocalizations(SupportedLocales.fallbackLocale);
    return SupportedLocales.fallbackLocale;
  }
}

/// Localization delegate
class _AppLocalizationsDelegate 
    extends LocalizationsDelegate<AppLocalizations> {
  @override
  bool isSupported(Locale locale) => 
      SupportedLocales.isSupported(locale);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations._current = AppLocalizations(locale);
    return AppLocalizations.current;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
