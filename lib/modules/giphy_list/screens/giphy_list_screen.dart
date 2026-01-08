import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giphy_app/core/constants/app_constants.dart';
import 'package:giphy_app/core/di/injection.dart';
import 'package:giphy_app/core/router/coordinators/giphy_coordinator.dart';
import 'package:giphy_app/modules/giphy_list/cubit/giphy_list_cubit.dart';
import 'package:giphy_app/modules/giphy_list/cubit/giphy_list_state.dart';
import 'package:giphy_app/core/common/widgets/error_widget.dart';
import 'package:giphy_app/modules/giphy_list/screens/components/components/giphy_grid_item.dart';
import 'package:giphy_app/core/common/widgets/loading_indicator.dart';
import 'package:giphy_app/modules/giphy_list/screens/components/components/search_box_widget.dart';

/// Main screen for searching and displaying GIFs from Giphy.
///
/// Features:
/// - Search functionality with real-time results
/// - Infinite scroll pagination
/// - Responsive grid layout
/// - Error handling with user-friendly messages
@RoutePage()
class GiphyListScreen extends StatefulWidget {
  const GiphyListScreen({super.key});

  @override
  State<GiphyListScreen> createState() => _GiphyListScreenState();
}

class _GiphyListScreenState extends State<GiphyListScreen> {
  final GiphyListCubit _cubit = getIt<GiphyListCubit>();
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  /// Handles scroll events to trigger pagination.
  ///
  /// Loads more GIFs when user scrolls within [AppConstants.scrollThreshold]
  /// pixels from the bottom of the list.
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent -
            AppConstants.scrollThreshold) {
      _cubit.loadMoreGifs();
    }
  }

  void _onSearchChanged(String query) {
    _cubit.searchGifs(query);
  }

  void _navigateToDetail(String gifId) {
    getIt<BaseGiphyCoordinator>().navigateToDetail(gifId);
  }

  @override
  void dispose() {
    _cubit.close();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: AppBar(title: const Text('Giphy Search'), elevation: 2),
        body: Column(
          children: [
            SearchBoxWidget(onSearchChanged: _onSearchChanged),
            Expanded(
              child: BlocBuilder<GiphyListCubit, GiphyListState>(
                builder: (context, state) {
                  if (state is GiphyListInitialState) {
                    return const Center(child: Text('Type for search'));
                  }

                  if (state is GiphyListLoadingState) {
                    return const LoadingIndicator();
                  }

                  if (state is GiphyListErrorState) {
                    return ErrorDisplayWidget(message: state.message);
                  }

                  if (state is GiphyListSuccessState) {
                    if (state.gifs.isEmpty) {
                      return const Center(
                        child: Text('No GIFs found. Try a different search.'),
                      );
                    }

                    return _GridView(
                      state: state,
                      scrollController: _scrollController,
                      onNavigateToDetail: _navigateToDetail,
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GridView extends StatelessWidget {
  final GiphyListSuccessState state;
  final ScrollController scrollController;
  final void Function(String) onNavigateToDetail;

  const _GridView({
    required this.state,
    required this.scrollController,
    required this.onNavigateToDetail,
  });

  /// Calculates the number of columns for the grid based on screen width and orientation.
  ///
  /// Returns different column counts for portrait and landscape modes
  /// to optimize the layout for different screen sizes.
  int _getCrossAxisCount(BuildContext context, Orientation orientation) {
    final width = MediaQuery.of(context).size.width;

    if (orientation == Orientation.portrait) {
      if (width > AppConstants.breakpointLarge) {
        return AppConstants.portraitColumnsLarge;
      }
      if (width > AppConstants.breakpointMedium) {
        return AppConstants.portraitColumnsMedium;
      }
      if (width > AppConstants.breakpointSmall) {
        return AppConstants.portraitColumnsMedium;
      }
      return AppConstants.portraitColumnsSmall;
    } else {
      if (width > AppConstants.breakpointLarge) {
        return AppConstants.landscapeColumnsXLarge;
      }
      if (width > AppConstants.breakpointMedium) {
        return AppConstants.landscapeColumnsLarge;
      }
      if (width > AppConstants.breakpointSmall) {
        return AppConstants.landscapeColumnsMedium;
      }
      return AppConstants.landscapeColumnsSmall;
    }
  }

  /// Calculates the aspect ratio for grid items based on orientation.
  ///
  /// Portrait mode uses square items (1.0), landscape uses wider items (1.3).
  double _getAspectRatio(BuildContext context, Orientation orientation) {
    if (orientation == Orientation.portrait) {
      return AppConstants.portraitAspectRatio;
    } else {
      return AppConstants.landscapeAspectRatio;
    }
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return GridView.builder(
          controller: scrollController,
          padding: const EdgeInsets.all(AppConstants.gridSpacing),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _getCrossAxisCount(context, orientation),
            crossAxisSpacing: AppConstants.gridSpacing,
            mainAxisSpacing: AppConstants.gridSpacing,
            childAspectRatio: _getAspectRatio(context, orientation),
          ),
          itemCount: state.gifs.length + (state.hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= state.gifs.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final gif = state.gifs[index];
            return GiphyGridItem(
              gif: gif,
              onTap: () => onNavigateToDetail(gif.id),
            );
          },
        );
      },
    );
  }
}
