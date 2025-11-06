import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giphy_app/core/connectivity/cubit/connectivity_cubit.dart';
import 'package:giphy_app/core/ui_kit/h_button.dart';

class DisconnectionScreen extends StatelessWidget {
  const DisconnectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;

    return Scaffold(
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        padding: EdgeInsets.fromLTRB(16, 0, 16, 16 + bottomPadding),
        child: Column(
          children: [
            const Spacer(),
            const Icon(Icons.wifi_off, size: 208),
            const SizedBox(height: 24),
            Text('Network connection lost', textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text('Check network connection again', textAlign: TextAlign.center),
            const Spacer(),
            HButton(
              title: 'Try again',
              onPressed: () => context.read<ConnectivityCubit>()..init(),
            ),
          ],
        ),
      ),
    );
  }
}
