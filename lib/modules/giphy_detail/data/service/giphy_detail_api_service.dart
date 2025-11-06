import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:giphy_app/core/api_client/base_api_client.dart';
import 'package:giphy_app/modules/giphy_detail/data/models/giphy_single_response.dart';
import 'package:injectable/injectable.dart';

@injectable
class GiphyDetailApiService {
  final BaseApiClient _apiClient;

  GiphyDetailApiService(this._apiClient);

  Future<GiphySingleResponse> getGifById(String id, {String? rating}) async {
    final apiKey = dotenv.env['API_KEY'];
    final queryParams = <String, dynamic>{'api_key': apiKey};

    if (rating != null) {
      queryParams['rating'] = rating;
    }

    final response = await _apiClient.get<Map<String, dynamic>>(
      path: 'v1/gifs/$id',
      queryParameters: queryParams,
    );
    return GiphySingleResponse.fromJson(response);
  }
}
