/// Application-wide constants
class AppConstants {
  AppConstants._(); // Private constructor to prevent instantiation

  // API Configuration
  static const String apiBaseUrlKey = 'BASE_URL';
  static const String apiKeyEnvKey = 'API_KEY';
  static const String environmentKey = 'ENVIRONMENT';

  // API Endpoints
  static const String searchGifsEndpoint = 'v1/gifs/search';
  static const String getGifByIdEndpoint = 'v1/gifs';

  // Pagination
  static const int defaultGifLimit = 25;
  static const int scrollThreshold = 200; // pixels from bottom to trigger load more

  // Timeouts (in seconds)
  static const int connectTimeout = 20;
  static const int receiveTimeout = 20;
  static const int sendTimeout = 20;

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double gridSpacing = 8.0;
  static const double errorIconSize = 64.0;

  // Grid Configuration
  static const int portraitColumnsSmall = 2;
  static const int portraitColumnsMedium = 3;
  static const int portraitColumnsLarge = 4;
  static const int landscapeColumnsSmall = 3;
  static const int landscapeColumnsMedium = 4;
  static const int landscapeColumnsLarge = 5;
  static const int landscapeColumnsXLarge = 6;

  // Breakpoints (in pixels)
  static const double breakpointSmall = 600;
  static const double breakpointMedium = 800;
  static const double breakpointLarge = 1200;

  // Aspect Ratios
  static const double portraitAspectRatio = 1.0;
  static const double landscapeAspectRatio = 1.3;
}

