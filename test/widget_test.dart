import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:giphy_app/app.dart';
import 'package:giphy_app/core/di/injection.dart';

void main() {
  testWidgets('App should load without errors', (WidgetTester tester) async {
    await dotenv.load(fileName: '.env');
    await configureDependencies();

    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
