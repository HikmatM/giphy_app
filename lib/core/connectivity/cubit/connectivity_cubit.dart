import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giphy_app/core/connectivity/cubit/connectivity_state.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ConnectivityCubit extends Cubit<ConnectivityState> {
  final Connectivity _connectivity;

  ConnectivityCubit(this._connectivity) : super(InitConnectivityState());

  FutureOr<void> init() async {
    final initialResult = await _connectivity.checkConnectivity();

    if (initialResult.contains(ConnectivityResult.none)) {
      emit(InternetDisconnectionState());
    } else {
      emit(InternetConnectionState());
    }

    _connectivity.onConnectivityChanged.listen(_connectedHandler);
  }

  void _connectedHandler(List<ConnectivityResult> result) {
    final connected = !result.contains(ConnectivityResult.none);

    if (connected && state is InternetConnectionState) {
      return;
    } else if (connected) {
      emit(InternetConnectionState());
    } else if (!connected) {
      emit(InternetDisconnectionState());
    }
  }
}
