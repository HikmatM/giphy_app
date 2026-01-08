import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:giphy_app/app.dart';
import 'package:giphy_app/core/di/injection.dart';

/// Application entry point.
///
/// Initializes:
/// - Flutter bindings
/// - Environment variables from .env file
/// - Dependency injection container
/// - Runs the app
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await configureDependencies();
  runApp(const App());
}
