// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:giphy_app/core/api_client/api_client.dart' as _i225;
import 'package:giphy_app/core/api_client/base_api_client.dart' as _i533;
import 'package:giphy_app/core/connectivity/cubit/connectivity_cubit.dart'
    as _i281;
import 'package:giphy_app/core/di/injection.dart' as _i316;
import 'package:giphy_app/core/router/app_router.dart' as _i394;
import 'package:giphy_app/core/router/coordinators/giphy_coordinator.dart'
    as _i662;
import 'package:giphy_app/modules/giphy_detail/cubit/giphy_detail_cubit.dart'
    as _i357;
import 'package:giphy_app/modules/giphy_detail/data/repository/giphy_detail_repository.dart'
    as _i56;
import 'package:giphy_app/modules/giphy_detail/data/service/giphy_detail_api_service.dart'
    as _i1018;
import 'package:giphy_app/modules/giphy_list/cubit/giphy_list_cubit.dart'
    as _i77;
import 'package:giphy_app/modules/giphy_list/data/repository/giphy_list_repository.dart'
    as _i884;
import 'package:giphy_app/modules/giphy_list/data/service/giphy_api_service.dart'
    as _i1015;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final connectivityModule = _$ConnectivityModule();
    final routerModule = _$RouterModule();
    final dioModule = _$DioModule();
    gh.singleton<_i895.Connectivity>(() => connectivityModule.connectivity);
    gh.singleton<_i394.AppRouter>(() => routerModule.appRouter);
    gh.lazySingleton<_i361.Dio>(() => dioModule.dio);
    gh.factory<_i533.BaseApiClient>(() => _i225.ApiClient(gh<_i361.Dio>()));
    gh.factory<_i662.BaseGiphyCoordinator>(
      () => _i662.GiphyCoordinator(gh<_i394.AppRouter>()),
    );
    gh.factory<_i1018.GiphyDetailApiService>(
      () => _i1018.GiphyDetailApiService(gh<_i533.BaseApiClient>()),
    );
    gh.factory<_i1015.GiphyApiService>(
      () => _i1015.GiphyApiService(gh<_i533.BaseApiClient>()),
    );
    gh.factory<_i884.BaseGiphyListRepository>(
      () => _i884.GiphyListRepository(gh<_i1015.GiphyApiService>()),
    );
    gh.lazySingleton<_i281.ConnectivityCubit>(
      () => _i281.ConnectivityCubit(gh<_i895.Connectivity>()),
    );
    gh.factory<_i77.GiphyListCubit>(
      () => _i77.GiphyListCubit(gh<_i884.BaseGiphyListRepository>()),
    );
    gh.factory<_i56.BaseGiphyDetailRepository>(
      () => _i56.GiphyDetailRepository(gh<_i1018.GiphyDetailApiService>()),
    );
    gh.factory<_i357.GiphyDetailCubit>(
      () => _i357.GiphyDetailCubit(gh<_i56.BaseGiphyDetailRepository>()),
    );
    return this;
  }
}

class _$ConnectivityModule extends _i316.ConnectivityModule {}

class _$RouterModule extends _i316.RouterModule {}

class _$DioModule extends _i316.DioModule {}
