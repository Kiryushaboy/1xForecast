class AppConstants {
  // App Info
  static const String appName = '1xForecast';
  static const String appVersion = '1.0.0';

  // Tournament
  static const String defaultTournament = 'FIFA FC24 4x4 England';

  // Analysis Thresholds
  static const int highScoringThreshold = 6;
  static const int minMatchesForAnalysis = 3;

  // Color Thresholds
  static const double highProbabilityThreshold = 70.0;
  static const double mediumProbabilityThreshold = 50.0;

  // Storage Keys
  static const String matchesKey = 'fifa_matches_v1';
  static const String settingsKey = 'app_settings';

  // API (for future use)
  static const String baseUrl = 'https://1xbet.com';
  static const Duration requestTimeout = Duration(seconds: 30);

  // UI
  static const int defaultRecentMatches = 10;
  static const int alternativeRecentMatches = 5;
}
