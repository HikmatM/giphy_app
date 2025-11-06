import 'package:equatable/equatable.dart';
import 'package:giphy_app/core/common/models/giphy_data.dart';

abstract class GiphyDetailState extends Equatable {
  const GiphyDetailState();

  @override
  List<Object?> get props => [];
}

class GiphyDetailInitialState extends GiphyDetailState {
  const GiphyDetailInitialState();
}

class GiphyDetailLoadingState extends GiphyDetailState {
  const GiphyDetailLoadingState();
}

class GiphyDetailSuccessState extends GiphyDetailState {
  final GiphyData gif;

  const GiphyDetailSuccessState({required this.gif});

  @override
  List<Object?> get props => [gif];
}

class GiphyDetailErrorState extends GiphyDetailState {
  final String message;

  const GiphyDetailErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
