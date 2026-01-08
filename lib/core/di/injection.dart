import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:giphy_app/core/constants/app_constants.dart';
import 'package:giphy_app/core/di/injection.config.dart';
import 'package:giphy_app/core/router/app_router.dart';
import 'package:injectable/injectable.dart';

/// Global GetIt instance for dependency injection.
final getIt = GetIt.instance;

/// Module for providing Dio HTTP client instance.
@module
abstract class DioModule {
  @lazySingleton
  Dio get dio {
    final dio = Dio();
    return dio;
  }
}

/// Module for providing Connectivity instance for network status monitoring.
@module
abstract class ConnectivityModule {
  @singleton
  Connectivity get connectivity => Connectivity();
}

/// Module for providing AppRouter instance for navigation.
@module
abstract class RouterModule {
  @singleton
  AppRouter get appRouter => AppRouter();
}

/// Initializes the dependency injection container.
///
/// Reads environment from .env file and configures all dependencies
/// using the generated injection configuration.
@InjectableInit()
Future<void> configureDependencies() async {
  final environment = dotenv.env[AppConstants.environmentKey] ?? 'dev';
  getIt.init(environment: environment);
}
