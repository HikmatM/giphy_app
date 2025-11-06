import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:giphy_app/core/api_client/base_api_client.dart';
import 'package:giphy_app/modules/giphy_list/data/models/giphy_response.dart';
import 'package:injectable/injectable.dart';

@injectable
class GiphyApiService {
  final BaseApiClient _apiClient;

  GiphyApiService(this._apiClient);

  Future<GiphyResponse> searchGifs({
    required String query,
    int limit = 25,
    int offset = 0,
    String? rating,
    String? lang,
    String? bundle,
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      path: 'v1/gifs/search',
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

  Map<String, dynamic> _searchParams(
    String query, {
    int limit = 25,
    int offset = 0,
    String? rating,
    String? lang,
    String? bundle,
  }) {
    final apiKey = dotenv.env['API_KEY'];
    final queryParams = <String, dynamic>{
      'api_key': apiKey,
      'q': query,
      'limit': limit,
      'offset': offset,
    };

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
