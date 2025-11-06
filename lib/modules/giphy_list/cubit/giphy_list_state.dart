import 'package:equatable/equatable.dart';
import 'package:giphy_app/core/common/models/giphy_data.dart';

abstract class GiphyListState extends Equatable {
  const GiphyListState();

  @override
  List<Object?> get props => [];
}

class GiphyListInitialState extends GiphyListState {
  const GiphyListInitialState();
}

class GiphyListLoadingState extends GiphyListState {
  const GiphyListLoadingState();
}

class GiphyListSuccessState extends GiphyListState {
  final List<GiphyData> gifs;
  final bool hasMore;
  final int currentOffset;
  final String? searchQuery;
  final String? rating;
  final String? lang;
  final String? bundle;

  const GiphyListSuccessState({
    required this.gifs,
    required this.hasMore,
    required this.currentOffset,
    this.searchQuery,
    this.rating,
    this.lang,
    this.bundle,
  });

  GiphyListSuccessState copyWith({
    List<GiphyData>? gifs,
    bool? hasMore,
    int? currentOffset,
    String? searchQuery,
    String? rating,
    String? lang,
    String? bundle,
  }) {
    return GiphyListSuccessState(
      gifs: gifs ?? this.gifs,
      hasMore: hasMore ?? this.hasMore,
      currentOffset: currentOffset ?? this.currentOffset,
      searchQuery: searchQuery ?? this.searchQuery,
      rating: rating ?? this.rating,
      lang: lang ?? this.lang,
      bundle: bundle ?? this.bundle,
    );
  }

  @override
  List<Object?> get props => [
    gifs,
    hasMore,
    currentOffset,
    searchQuery,
    rating,
    lang,
    bundle,
  ];
}

class GiphyListErrorState extends GiphyListState {
  final String message;

  const GiphyListErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
