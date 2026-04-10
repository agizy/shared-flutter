/// Debug flags for development and testing
/// Set to false before production release
class DebugFlags {
  /// Disable all ads for testing
  static const bool disableAds = false;

  /// Use test ad unit IDs instead of production
  static const bool useTestAds = true;

  /// Bypass premium check (treat as non-premium always)
  static const bool bypassPremiumCheck = false;

  /// Enable verbose logging
  static const bool verboseLogging = true;

  /// Skip grace period (show ads immediately)
  static const bool skipGracePeriod = false;
}
