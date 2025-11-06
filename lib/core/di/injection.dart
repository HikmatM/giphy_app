import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:giphy_app/core/di/injection.config.dart';
import 'package:giphy_app/core/router/app_router.dart';
import 'package:injectable/injectable.dart';

final getIt = GetIt.instance;

@module
abstract class DioModule {
  @lazySingleton
  Dio get dio {
    final dio = Dio();
    return dio;
  }
}

@module
abstract class ConnectivityModule {
  @singleton
  Connectivity get connectivity => Connectivity();
}

@module
abstract class RouterModule {
  @singleton
  AppRouter get appRouter => AppRouter();
}

@InjectableInit()
Future<void> configureDependencies() async {
  final environment = dotenv.env['ENVIRONMENT'] ?? 'dev';
  getIt.init(environment: environment);
}
