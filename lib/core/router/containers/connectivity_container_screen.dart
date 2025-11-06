import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giphy_app/core/connectivity/cubit/connectivity_cubit.dart';
import 'package:giphy_app/core/connectivity/cubit/connectivity_state.dart';
import 'package:giphy_app/core/connectivity/disconnection_screen.dart';
import 'package:giphy_app/core/di/injection.dart';

@RoutePage()
class ConnectivityContainerScreen extends StatelessWidget {
  const ConnectivityContainerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const AutoRouter(),
        BlocProvider(
          create: (context) => getIt<ConnectivityCubit>()..init(),
          child: BlocBuilder<ConnectivityCubit, ConnectivityState>(
            builder: (context, state) {
              if (state is InternetDisconnectionState) {
                if (context.router.canPop()) {
                  context.router.pop();
                }
                return const DisconnectionScreen();
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}
