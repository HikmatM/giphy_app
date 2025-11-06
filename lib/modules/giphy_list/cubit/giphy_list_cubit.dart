import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giphy_app/core/api_client/exceptions/api_exception.dart';
import 'package:giphy_app/modules/giphy_list/cubit/giphy_list_state.dart';
import 'package:giphy_app/modules/giphy_list/data/models/giphy_response.dart';
import 'package:giphy_app/modules/giphy_list/data/repository/giphy_list_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GiphyListCubit extends Cubit<GiphyListState> {
  final BaseGiphyListRepository _repository;
  static const int _limit = 25;

  GiphyListCubit(this._repository) : super(const GiphyListInitialState());

  Future<void> searchGifs(
    String query, {
    bool isNewSearch = true,
    String? rating,
    String? lang,
    String? bundle,
  }) async {
    try {
      if (isNewSearch) {
        emit(const GiphyListLoadingState());
      }

      final currentState = state;
      final offset = isNewSearch
          ? 0
          : (currentState is GiphyListSuccessState
                ? currentState.currentOffset
                : 0);

      final effectiveRating =
          rating ??
          (currentState is GiphyListSuccessState ? currentState.rating : null);
      final effectiveLang =
          lang ??
          (currentState is GiphyListSuccessState ? currentState.lang : null);
      final effectiveBundle =
          bundle ??
          (currentState is GiphyListSuccessState ? currentState.bundle : null);

      final response = await _repository.searchGifs(
        query: query,
        limit: _limit,
        offset: offset,
        rating: effectiveRating,
        lang: effectiveLang,
        bundle: effectiveBundle,
      );

      if (isNewSearch) {
        emit(
          GiphyListSuccessState(
            gifs: response.data,
            hasMore: _hasMoreData(response),
            currentOffset: offset + response.data.length,
            searchQuery: query.isEmpty ? null : query,
            rating: effectiveRating,
            lang: effectiveLang,
            bundle: effectiveBundle,
          ),
        );
      } else {
        if (currentState is GiphyListSuccessState) {
          final updatedGifs = [...currentState.gifs, ...response.data];
          emit(
            currentState.copyWith(
              gifs: updatedGifs,
              hasMore: _hasMoreData(response),
              currentOffset: offset + response.data.length,
            ),
          );
        }
      }
    } catch (e) {
      emit(
        GiphyListErrorState(
          message: e is ApiException
              ? e.errorMessage ?? 'Api Exception'
              : 'Unknown exception',
        ),
      );
    }
  }

  Future<void> loadMoreGifs() async {
    final currentState = state;
    if (currentState is GiphyListSuccessState &&
        currentState.hasMore &&
        !_isLoading) {
      await searchGifs(currentState.searchQuery ?? '', isNewSearch: false);
    }
  }

  bool _hasMoreData(GiphyResponse response) {
    if (response.pagination == null) return false;
    final pagination = response.pagination!;
    return (pagination.offset + pagination.count) < pagination.totalCount;
  }

  bool get _isLoading => state is GiphyListLoadingState;
}
