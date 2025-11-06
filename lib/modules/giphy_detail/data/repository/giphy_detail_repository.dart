import 'package:giphy_app/modules/giphy_detail/data/service/giphy_detail_api_service.dart';
import 'package:giphy_app/modules/giphy_detail/data/models/giphy_single_response.dart';
import 'package:injectable/injectable.dart';

abstract class BaseGiphyDetailRepository {
  Future<GiphySingleResponse> getGifById(String id, {String? rating});
}

@Injectable(as: BaseGiphyDetailRepository)
class GiphyDetailRepository implements BaseGiphyDetailRepository {
  final GiphyDetailApiService _apiService;

  GiphyDetailRepository(this._apiService);

  @override
  Future<GiphySingleResponse> getGifById(String id, {String? rating}) async {
    return _apiService.getGifById(id, rating: rating);
  }
}
