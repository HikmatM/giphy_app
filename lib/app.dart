import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:giphy_app/core/di/injection.dart';
import 'package:giphy_app/core/router/app_router.dart';

/// Root application widget.
///
/// Configures:
/// - Material app with router
/// - Navigation observers for route tracking
/// - Theme configuration
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = getIt<AppRouter>();
    return MaterialApp.router(
      title: 'Giphy search app',
      routerConfig: appRouter.config(
        navigatorObservers: () {
          return [AutoRouteObserver()];
        },
      ),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
    );
  }
}
