import 'package:giphy_app/core/router/app_router.dart';
import 'package:giphy_app/core/router/app_router.gr.dart';
import 'package:injectable/injectable.dart';

abstract class BaseGiphyCoordinator {
  void navigateToDetail(String gifId);
  void navigateBack();
}

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
