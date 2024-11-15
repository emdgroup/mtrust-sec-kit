import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mtrust_sec_kit/mtrust_sec_kit.dart';

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
                onVerificationFailed: () async {},
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
                onVerificationFailed: () async {},
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
                onVerificationFailed: () async {},
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
                onVerificationFailed: () async {},
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
                onVerificationFailed: () async {},
              ),
            ),
          );

          await tester.pumpAndSettle();

          await tester.tap(find.byKey(const Key('connect_button')));

          await tester.pumpAndSettle();

          strategy.primeCompleter.complete();

          await tester.pumpAndSettle();

          await tester.tap(find.text('Start scan'));

          strategy.startMeasurementCompleter.completeError('');

          await tester.pumpAndSettle();

          return () async {};
        },
        'Measure Complete': (tester, place) async {
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
                onVerificationFailed: () async {},
              ),
            ),
          );

          await tester.pumpAndSettle();

          await tester.tap(find.byKey(const Key('connect_button')));

          await tester.pumpAndSettle();

          strategy.primeCompleter.complete();

          await tester.pumpAndSettle();

          await tester.tap(find.text('Start scan'));

          strategy.startMeasurementCompleter.complete();

          await tester.pumpAndSettle();

          return () async {};
        },
      },
      width: 500,
    );
  });
}
