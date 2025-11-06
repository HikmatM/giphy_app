import 'package:equatable/equatable.dart';

sealed class ConnectivityState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitConnectivityState extends ConnectivityState {}

class InternetConnectionState extends ConnectivityState {}

class InternetDisconnectionState extends ConnectivityState {}
