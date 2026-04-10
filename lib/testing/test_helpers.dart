/// Shared testing utilities for all Flutter apps
/// 
/// Provides common helpers for:
/// - Widget testing with MaterialApp wrapper
/// - BLoC testing utilities
/// - Mock creation helpers
/// - Golden test helpers
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

export 'package:flutter_test/flutter_test.dart';
export 'package:mocktail/mocktail.dart';
export 'package:bloc_test/bloc_test.dart';

/// Creates a testable widget wrapped in MaterialApp
/// 
/// Usage:
/// ```dart
/// await tester.pumpWidget(
///   makeTestable(child: MyWidget()),
/// );
/// ```
Widget makeTestable({
  required Widget child,
  ThemeData? theme,
  NavigatorObserver? navigatorObserver,
}) {
  return MaterialApp(
    theme: theme,
    navigatorObservers: navigatorObserver != null ? [navigatorObserver] : [],
    home: Scaffold(body: child),
  );
}

/// Creates a testable widget with BLoC providers
/// 
/// Usage:
/// ```dart
/// await tester.pumpWidget(
///   makeTestableWithBlocs(
///     child: MyWidget(),
///     providers: [
///       BlocProvider<MyBloc>.value(value: mockBloc),
///     ],
///   ),
/// );
/// ```
Widget makeTestableWithBlocs({
  required Widget child,
  required List<BlocProvider> providers,
  ThemeData? theme,
}) {
  return MultiBlocProvider(
    providers: providers,
    child: MaterialApp(
      theme: theme,
      home: Scaffold(body: child),
    ),
  );
}

/// Pumps and settles with a timeout
/// 
/// Useful for widgets with animations
Future<void> pumpAndSettleWithTimeout(
  WidgetTester tester, {
  Duration timeout = const Duration(seconds: 5),
}) async {
  await tester.pumpAndSettle(const Duration(milliseconds: 100), EnginePhase.sendSemanticsUpdate, timeout);
}

/// Finds a widget by type and verifies it exists
/// 
/// Returns the finder for further assertions
Finder findOne<T extends Widget>({String? reason}) {
  final finder = find.byType(T);
  expect(finder, findsOneWidget, reason: reason);
  return finder;
}

/// Finds text and verifies it exists exactly once
Finder findOneText(String text, {String? reason}) {
  final finder = find.text(text);
  expect(finder, findsOneWidget, reason: reason);
  return finder;
}

/// Finds a widget by key and verifies it exists
Finder findOneKey(String key, {String? reason}) {
  final finder = find.byKey(ValueKey(key));
  expect(finder, findsOneWidget, reason: reason);
  return finder;
}

/// Taps a widget and pumps
Future<void> tapAndPump(
  WidgetTester tester,
  Finder finder, {
  Duration settleDuration = const Duration(milliseconds: 100),
}) async {
  await tester.tap(finder);
  await tester.pump();
  if (settleDuration > Duration.zero) {
    await tester.pump(settleDuration);
  }
}

/// Enters text into a text field and pumps
Future<void> enterTextAndPump(
  WidgetTester tester,
  Finder finder,
  String text, {
  Duration settleDuration = const Duration(milliseconds: 100),
}) async {
  await tester.enterText(finder, text);
  await tester.pump();
  if (settleDuration > Duration.zero) {
    await tester.pump(settleDuration);
  }
}

/// Waits for a specific widget to appear
Future<Finder> waitForWidget<T extends Widget>(
  WidgetTester tester, {
  Duration timeout = const Duration(seconds: 5),
  String? reason,
}) async {
  final finder = find.byType(T);
  final endTime = DateTime.now().add(timeout);

  while (DateTime.now().isBefore(endTime)) {
    await tester.pump(const Duration(milliseconds: 100));
    if (finder.evaluate().isNotEmpty) {
      return finder;
    }
  }

  throw TestFailure('Widget $T not found within ${timeout.inSeconds}s: ${reason ?? ""}');
}

/// Creates a mock navigator observer for testing navigation
class MockNavigatorObserver extends Mock implements NavigatorObserver {}

/// Helper extension for widget tester
extension WidgetTesterX on WidgetTester {
  /// Shortcut to pump widget and settle
  Future<void> pumpWidgetSettled(Widget widget) async {
    await pumpWidget(widget);
    await pumpAndSettle();
  }

  /// Finds and taps a widget by text
  Future<void> tapText(String text) async {
    await tap(find.text(text));
    await pump();
  }

  /// Finds and taps a widget by type
  Future<void> tapType<T extends Widget>() async {
    await tap(find.byType(T));
    await pump();
  }

  /// Finds and taps a widget by key
  Future<void> tapKey(String key) async {
    await tap(find.byKey(ValueKey(key)));
    await pump();
  }
}

/// Golden test helper with consistent configuration
Future<void> goldenTest(
  String description,
  WidgetTester tester,
  Widget widget, {
  String? goldenFile,
  DeviceBuilder? deviceBuilder,
}) async {
  final builder = deviceBuilder ??
      DeviceBuilder()
        ..overrideDevicesForAllScenarios(devices: [
          Device.phone,
          Device.iphone11,
          Device.tabletPortrait,
        ]);

  await tester.pumpDeviceBuilder(builder);

  if (goldenFile != null) {
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/$goldenFile.png'),
    );
  }
}

/// Device builder for responsive testing
typedef DeviceBuilder = dynamic; // Placeholder - would use device_preview or similar

/// Mock class helper for creating simple mocks
class MockClass<T> extends Mock implements T {}
