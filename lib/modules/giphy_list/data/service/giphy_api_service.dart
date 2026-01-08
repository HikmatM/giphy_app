import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:giphy_app/core/api_client/base_api_client.dart';
import 'package:giphy_app/core/constants/app_constants.dart';
import 'package:giphy_app/modules/giphy_list/data/models/giphy_response.dart';
import 'package:injectable/injectable.dart';

/// Service for interacting with Giphy API.
///
/// Handles API requests for searching GIFs with various filters.
@injectable
class GiphyApiService {
  final BaseApiClient _apiClient;

  GiphyApiService(this._apiClient);

  /// Searches for GIFs using Giphy API.
  ///
  /// [query] - Search query string
  /// [limit] - Number of results per page (default: 25)
  /// [offset] - Pagination offset
  /// [rating] - Content rating filter
  /// [lang] - Language code
  /// [bundle] - Bundle type filter
  Future<GiphyResponse> searchGifs({
    required String query,
    int limit = AppConstants.defaultGifLimit,
    int offset = 0,
    String? rating,
    String? lang,
    String? bundle,
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      path: AppConstants.searchGifsEndpoint,
      queryParameters: _searchParams(
        query,
        limit: limit,
        offset: offset,
        rating: rating,
        lang: lang,
        bundle: bundle,
      ),
    );
    return GiphyResponse.fromJson(response);
  }

  /// Builds query parameters for the search API request.
  ///
  /// Includes API key, query, pagination, and optional filters.
  Map<String, dynamic> _searchParams(
    String query, {
    int limit = AppConstants.defaultGifLimit,
    int offset = 0,
    String? rating,
    String? lang,
    String? bundle,
  }) {
    final apiKey = dotenv.env[AppConstants.apiKeyEnvKey];
    final queryParams = <String, dynamic>{
      'api_key': apiKey,
      'q': query,
      'limit': limit,
      'offset': offset,
    };

    // Add optional filters if provided
    if (rating != null) {
      queryParams['rating'] = rating;
    }
    if (lang != null) {
      queryParams['lang'] = lang;
    }
    if (bundle != null) {
      queryParams['bundle'] = bundle;
    }

    return queryParams;
  }
}
