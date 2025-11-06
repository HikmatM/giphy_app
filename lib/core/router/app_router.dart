import 'package:auto_route/auto_route.dart';
import 'package:giphy_app/core/router/app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      initial: true,
      page: ConnectivityContainerRoute.page,
      children: [
        AutoRoute(initial: true, page: GiphyListRoute.page),
        AutoRoute(page: GiphyDetailRoute.page),
      ],
    ),
  ];
}
