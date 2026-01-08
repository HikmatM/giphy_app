import 'package:flutter/material.dart';
import 'package:giphy_app/core/constants/app_constants.dart';

/// Widget for displaying error messages to users.
///
/// Shows an error icon and message in a user-friendly format.
class ErrorDisplayWidget extends StatelessWidget {
  final String message;

  const ErrorDisplayWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    const IconData errorIcon = Icons.error_outline;
    const Color errorColor = Colors.red;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(errorIcon, size: AppConstants.errorIconSize, color: errorColor),
            const SizedBox(height: AppConstants.defaultPadding),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: errorColor),
            ),
          ],
        ),
      ),
    );
  }
}
