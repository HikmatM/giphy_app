import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giphy_app/core/api_client/exceptions/api_exception.dart';
import 'package:giphy_app/modules/giphy_detail/cubit/giphy_detail_state.dart';
import 'package:giphy_app/modules/giphy_detail/data/repository/giphy_detail_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GiphyDetailCubit extends Cubit<GiphyDetailState> {
  final BaseGiphyDetailRepository _repository;

  GiphyDetailCubit(this._repository) : super(const GiphyDetailInitialState());

  Future<void> loadGif(String id) async {
    emit(const GiphyDetailLoadingState());

    try {
      final response = await _repository.getGifById(id);
      emit(GiphyDetailSuccessState(gif: response.data));
    } catch (e) {
      emit(
        GiphyDetailErrorState(
          message: e is ApiException
              ? e.errorMessage ?? 'Api Exception'
              : 'Unknown error',
        ),
      );
    }
  }
}
