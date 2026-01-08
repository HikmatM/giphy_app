import 'package:giphy_app/core/router/app_router.dart';
import 'package:giphy_app/core/router/app_router.gr.dart';
import 'package:injectable/injectable.dart';

/// Base coordinator interface for navigation operations.
///
/// This abstraction allows for easy testing and swapping implementations.
abstract class BaseGiphyCoordinator {
  /// Navigates to the GIF detail screen with the given GIF ID.
  void navigateToDetail(String gifId);

  /// Navigates back to the previous screen.
  void navigateBack();
}

/// Coordinator for handling navigation in the Giphy feature module.
///
/// Implements the coordinator pattern to centralize navigation logic
/// and decouple UI components from routing implementation.
@Injectable(as: BaseGiphyCoordinator)
class GiphyCoordinator implements BaseGiphyCoordinator {
  final AppRouter _router;

  GiphyCoordinator(this._router);

  @override
  void navigateToDetail(String gifId) {
    _router.navigate(GiphyDetailRoute(gifId: gifId));
  }

  @override
  void navigateBack() {
    _router.pop();
  }
}
