// test/widget_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab1_itt632/main.dart';

void main() {
  testWidgets('App starts without crashing', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(NewsApp());

    // Wait for any async operations
    await tester.pump();

    // Just check that the app doesn't crash
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}