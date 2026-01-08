import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giphy_app/core/api_client/exceptions/api_exception.dart';
import 'package:giphy_app/core/constants/app_constants.dart';
import 'package:giphy_app/modules/giphy_list/cubit/giphy_list_state.dart';
import 'package:giphy_app/modules/giphy_list/data/models/giphy_response.dart';
import 'package:giphy_app/modules/giphy_list/data/repository/giphy_list_repository.dart';
import 'package:injectable/injectable.dart';

/// Cubit for managing GIF list state and business logic.
///
/// Handles:
/// - Searching for GIFs
/// - Pagination and loading more results
/// - State management (loading, success, error)
/// - Preserving search filters (rating, lang, bundle) across pagination
@injectable
class GiphyListCubit extends Cubit<GiphyListState> {
  final BaseGiphyListRepository _repository;

  /// Number of GIFs to fetch per request
  static const int _limit = AppConstants.defaultGifLimit;

  GiphyListCubit(this._repository) : super(const GiphyListInitialState());

  /// Searches for GIFs with optional filters.
  ///
  /// [query] - Search query string
  /// [isNewSearch] - If true, resets the list and shows loading state
  /// [rating] - Content rating filter (g, pg, pg-13, r)
  /// [lang] - Language code for results
  /// [bundle] - Bundle type filter
  ///
  /// When [isNewSearch] is false, appends results to existing list (pagination).
  /// Preserves filters from previous search if not provided.
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
      // Calculate offset: 0 for new search, current offset for pagination
      final offset = isNewSearch
          ? 0
          : (currentState is GiphyListSuccessState
                ? currentState.currentOffset
                : 0);

      // Preserve filters from previous search if not provided
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
        // New search: replace existing list
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
        // Pagination: append to existing list
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
      // Handle errors and emit error state with user-friendly message
      emit(
        GiphyListErrorState(
          message: e is ApiException
              ? e.errorMessage ?? 'Api Exception'
              : 'Unknown exception',
        ),
      );
    }
  }

  /// Loads more GIFs if there are more available and not currently loading.
  ///
  /// Uses the current search query and filters from the success state.
  Future<void> loadMoreGifs() async {
    final currentState = state;
    if (currentState is GiphyListSuccessState &&
        currentState.hasMore &&
        !_isLoading) {
      await searchGifs(currentState.searchQuery ?? '', isNewSearch: false);
    }
  }

  /// Determines if there are more GIFs available based on pagination data.
  ///
  /// Returns true if (offset + count) < totalCount, indicating more results exist.
  bool _hasMoreData(GiphyResponse response) {
    if (response.pagination == null) return false;
    final pagination = response.pagination!;
    return (pagination.offset + pagination.count) < pagination.totalCount;
  }

  /// Checks if the cubit is currently in a loading state.
  bool get _isLoading => state is GiphyListLoadingState;
}
