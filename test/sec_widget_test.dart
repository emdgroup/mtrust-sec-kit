import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:liquid_flutter/liquid_flutter.dart';
import 'package:mtrust_sec_kit/mtrust_sec_kit.dart';
import 'package:mtrust_sec_kit/src/ui/l10n/sec_locale_en.dart';

import 'golden_utils.dart';
import 'test_utils.dart';

void main() {
  testGoldens('SecWidget', (WidgetTester test) async {
    urpUiDisableAnimations = true;

    await multiGolden(
      test,
      'SecWidget',
      {
        'Idle': (tester, place) async {
          final strategy = CompleterStrategy(withReaders: true);

          final storageAdapter = MockStorageAdapter();

          await place(
            AspectRatio(
              aspectRatio: 1,
              child: SecWidget(
                strategy: strategy.strategy,
                storageAdapter: storageAdapter,
                payload: '',
                onVerificationDone: (_) async {},
                onVerificationFailed: (_) async {},
              ),
            ),
          );

          await tester.pumpAndSettle();
          return null;
        },
        'Priming': (tester, place) async {
          final strategy = CompleterStrategy(withReaders: true);

          final storageAdapter = MockStorageAdapter();

          await place(
            AspectRatio(
              aspectRatio: 1,
              child: SecWidget(
                strategy: strategy.strategy,
                storageAdapter: storageAdapter,
                payload: '',
                onVerificationDone: (_) async {},
                onVerificationFailed: (_) async {},
              ),
            ),
          );

          await tester.pumpAndSettle();

          await tester.tap(find.byKey(const Key('connect_button')));

          return () async {
            strategy.primeCompleter.complete();
          };
        },
        'Waiting for measurement': (tester, place) async {
          final strategy = CompleterStrategy(withReaders: true);

          final storageAdapter = MockStorageAdapter();

          await place(
            AspectRatio(
              aspectRatio: 1,
              child: SecWidget(
                strategy: strategy.strategy,
                storageAdapter: storageAdapter,
                payload: '',
                onVerificationDone: (_) async {},
                onVerificationFailed: (_) async {},
              ),
            ),
          );

          await tester.pumpAndSettle();

          await tester.tap(find.byKey(const Key('connect_button')));

          await tester.pumpAndSettle();

          strategy.primeCompleter.complete();

          await tester.pumpAndSettle();

          return () async {
            strategy.startMeasurementCompleter.complete();
          };
        },
        'Measuring': (tester, place) async {
          final strategy = CompleterStrategy(withReaders: true);

          final storageAdapter = MockStorageAdapter();

          await place(
            AspectRatio(
              aspectRatio: 1,
              child: SecWidget(
                strategy: strategy.strategy,
                storageAdapter: storageAdapter,
                payload: '',
                onVerificationDone: (_) async {},
                onVerificationFailed: (_) async {},
              ),
            ),
          );

          await tester.pumpAndSettle();

          await tester.tap(find.byKey(const Key('connect_button')));

          await tester.pumpAndSettle();

          strategy.primeCompleter.complete();

          await tester.pumpAndSettle();

          await tester.tap(find.text('Start scan'));

          await tester.pumpAndSettle();

          return () async {
            strategy.startMeasurementCompleter.complete();
          };
        },
        'Measure Fail': (tester, place) async {
          final strategy = CompleterStrategy(withReaders: true);

          final storageAdapter = MockStorageAdapter();

          await place(
            AspectRatio(
              aspectRatio: 1,
              child: SecWidget(
                strategy: strategy.strategy,
                storageAdapter: storageAdapter,
                payload: '',
                onVerificationDone: (_) async {},
                onVerificationFailed: (_) async {},
              ),
            ),
          );

          await tester.pumpAndSettle();

          await tester.tap(find.byKey(const Key('connect_button')));

          await tester.pumpAndSettle();

          strategy.primeCompleter.complete();

          await tester.pumpAndSettle();

          await tester.tap(find.text('Start scan'));

          await tester.pump(const Duration(seconds: 36));

          await tester.pumpAndSettle();

          return () async {};
        },
        'Measure Complete': (tester, place) async {
          final strategy =
              CompleterStrategy(withReaders: true, useDelays: true);

          final storageAdapter = MockStorageAdapter();

          await place(
            AspectRatio(
              aspectRatio: 1,
              child: SecWidget(
                strategy: strategy.strategy,
                storageAdapter: storageAdapter,
                payload: '',
                onVerificationDone: (_) async {},
                onVerificationFailed: (_) async {},
              ),
            ),
          );

          await tester.pumpAndSettle();

          await tester.tap(find.byKey(const Key('connect_button')));

          await tester.pumpAndSettle();

          await tester.pumpAndSettle();

          await tester.pump(const Duration(seconds: 1));

          await tester.pumpAndSettle();

          await tester.tap(find.text('Start scan'));

          await tester.pump(const Duration(seconds: 1));

          await tester.pumpAndSettle();

          await tester.pump(const Duration(seconds: 2));

          return () async {};
        },
      },
      width: 500,
    );
  });

  testWidgets('SecWidget calls onVerificationFailed on error',
      (WidgetTester tester) async {
    urpUiDisableAnimations = true;
    ldDisableAnimations = true;

    // Create a strategy that throws an error during priming
    final strategy = CompleterStrategy(
      withReaders: true,
      // return a response with an empty payload to simulate a measurement failure
      measurementResponse: UrpResponse(),
    );

    final storageAdapter = MockStorageAdapter();

    SecReaderException? capturedError;
    var failureCallbackCalled = false;

    final theme = LdTheme();

    await tester.pumpWidget(
      LdThemeProvider(
        theme: theme,
        autoSize: false,
        brightnessMode: LdThemeBrightnessMode.light,
        child: MaterialApp(
          localizationsDelegates: const [
            GlobalWidgetsLocalizations.delegate,
            LiquidLocalizations.delegate,
            UrpUiLocalizations.delegate,
            SecLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en')],
          home: Scaffold(
            body: AspectRatio(
              aspectRatio: 1,
              child: SecWidget(
                strategy: strategy.strategy,
                storageAdapter: storageAdapter,
                payload: 'test-payload',
                onVerificationDone: (_) async {},
                onVerificationFailed: (exception) async {
                  failureCallbackCalled = true;
                  capturedError = exception;
                },
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    // Verify connect button is available
    expect(find.byKey(const Key('connect_button')), findsOneWidget);
    await tester.tap(find.byKey(const Key('connect_button')));

    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    // Complete the prime operation to transition to "Waiting for measurement" state
    strategy.primeCompleter.complete();

    await tester.pumpAndSettle();
    await tester.tap(find.text('Start scan'));

    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    // Complete the measurement completer - strategy will throw the error
    strategy.startMeasurementCompleter.complete();

    // Wait for error to propagate
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    // Check whether the 'verification failed' message is displayed in the UI
    expect(
      find.textContaining(SecLocalizationsEn().verificationFailed),
      findsAny,
    );

    // Tap the 'Done' button in order to trigger the onVerificationFailed callback
    await tester.tap(find.text(SecLocalizationsEn().done));

    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    // Verify the callback was called with the correct exception
    expect(failureCallbackCalled, isTrue);
    expect(capturedError, isNotNull);

    // The exception type should be measurementFailed as set in the strategy
    expect(capturedError?.type, SecReaderExceptionType.measurementFailed);

    // Pump through the remaining 10-second timer in LdSubmitController to ensure that there are no pending timers that
    // could cause issues in subsequent tests
    await tester.pumpAndSettle(const Duration(seconds: 10));
  });
}
