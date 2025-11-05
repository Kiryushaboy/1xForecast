// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:forecast_app/main.dart';
import 'package:forecast_app/core/services/match_cache_service.dart';
import 'package:forecast_app/core/services/scheduled_update_service.dart';

void main() {
  testWidgets('App initializes correctly', (WidgetTester tester) async {
    // Initialize services for testing
    final cacheService = MatchCacheService();
    await cacheService.initialize();

    final updateService = ScheduledUpdateService(
      onDataParsed: (matches) async {
        await cacheService.cacheMatches(matches);
      },
    );

    // Build our app and trigger a frame
    await tester.pumpWidget(MyApp(
      cacheService: cacheService,
      updateService: updateService,
    ));

    // Verify that the app builds without errors
    expect(find.byType(MaterialApp), findsOneWidget);

    // Clean up
    await cacheService.dispose();
    updateService.dispose();
  });
}
