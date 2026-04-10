import 'package:flutter/material.dart';
import 'app_localizations.dart';

/// Extension for easy string translation
extension StringTranslation on String {
  /// Translate this string key
  /// 
  /// Usage:
  /// ```dart
  /// Text('upgrade_to_premium'.tr())
  /// ```
  String tr({BuildContext? context, Map<String, String>? params}) {
    if (context != null) {
      return AppLocalizations.of(context).tr(this, params: params);
    }
    // Use current if context not provided
    try {
      return AppLocalizations.current.tr(this, params: params);
    } catch (e) {
      return this;
    }
  }

  /// Translate with context (recommended)
  String trContext(BuildContext context, {Map<String, String>? params}) {
    return AppLocalizations.of(context).tr(this, params: params);
  }
}

/// Extension for Text widget
extension TextTranslation on Text {
  /// Create translated text
  /// 
  /// Usage:
  /// ```dart
  /// const Text('upgrade_to_premium').tr()
  /// ```
  Text tr({Map<String, String>? params}) {
    return Text(
      data?.tr(params: params) ?? '',
      style: style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
    );
  }
}
