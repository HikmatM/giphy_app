// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i4;
import 'package:flutter/material.dart' as _i5;
import 'package:giphy_app/core/router/containers/connectivity_container_screen.dart'
    as _i1;
import 'package:giphy_app/modules/giphy_detail/screens/giphy_detail_screen.dart'
    as _i2;
import 'package:giphy_app/modules/giphy_list/screens/giphy_list_screen.dart'
    as _i3;

/// generated route for
/// [_i1.ConnectivityContainerScreen]
class ConnectivityContainerRoute extends _i4.PageRouteInfo<void> {
  const ConnectivityContainerRoute({List<_i4.PageRouteInfo>? children})
    : super(ConnectivityContainerRoute.name, initialChildren: children);

  static const String name = 'ConnectivityContainerRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return const _i1.ConnectivityContainerScreen();
    },
  );
}

/// generated route for
/// [_i2.GiphyDetailScreen]
class GiphyDetailRoute extends _i4.PageRouteInfo<GiphyDetailRouteArgs> {
  GiphyDetailRoute({
    _i5.Key? key,
    required String gifId,
    List<_i4.PageRouteInfo>? children,
  }) : super(
         GiphyDetailRoute.name,
         args: GiphyDetailRouteArgs(key: key, gifId: gifId),
         initialChildren: children,
       );

  static const String name = 'GiphyDetailRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<GiphyDetailRouteArgs>();
      return _i2.GiphyDetailScreen(key: args.key, gifId: args.gifId);
    },
  );
}

class GiphyDetailRouteArgs {
  const GiphyDetailRouteArgs({this.key, required this.gifId});

  final _i5.Key? key;

  final String gifId;

  @override
  String toString() {
    return 'GiphyDetailRouteArgs{key: $key, gifId: $gifId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! GiphyDetailRouteArgs) return false;
    return key == other.key && gifId == other.gifId;
  }

  @override
  int get hashCode => key.hashCode ^ gifId.hashCode;
}

/// generated route for
/// [_i3.GiphyListScreen]
class GiphyListRoute extends _i4.PageRouteInfo<void> {
  const GiphyListRoute({List<_i4.PageRouteInfo>? children})
    : super(GiphyListRoute.name, initialChildren: children);

  static const String name = 'GiphyListRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return const _i3.GiphyListScreen();
    },
  );
}
