import 'package:giphy_app/modules/giphy_list/data/models/giphy_response.dart';
import 'package:giphy_app/modules/giphy_list/data/service/giphy_api_service.dart';
import 'package:injectable/injectable.dart';

abstract class BaseGiphyListRepository {
  Future<GiphyResponse> searchGifs({
    required String query,
    int limit = 25,
    int offset = 0,
    String? rating,
    String? lang,
    String? bundle,
  });
}

@Injectable(as: BaseGiphyListRepository)
class GiphyListRepository implements BaseGiphyListRepository {
  final GiphyApiService _apiService;

  GiphyListRepository(this._apiService);

  @override
  Future<GiphyResponse> searchGifs({
    required String query,
    int limit = 25,
    int offset = 0,
    String? rating,
    String? lang,
    String? bundle,
  }) async {
    return _apiService.searchGifs(
      query: query,
      limit: limit,
      offset: offset,
      rating: rating,
      lang: lang,
      bundle: bundle,
    );
  }
}
