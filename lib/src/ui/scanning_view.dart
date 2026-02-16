// ignore_for_file: avoid_dynamic_calls

import 'package:flutter/material.dart';
import 'package:liquid_flutter/liquid_flutter.dart';
import 'package:mtrust_sec_kit/mtrust_sec_kit.dart';
import 'package:mtrust_sec_kit/src/ui/count_down_progress.dart';
import 'package:mtrust_sec_kit/src/ui/scanning_instruction.dart';

/// [ScanningView] is used when the user is performing a measurement
/// Responsible for starting the measurement , showing the progress indicator
/// and displaying the result.
class ScanningView extends StatelessWidget {
  /// Creates a new [ScanningView].
  const ScanningView({
    required this.strategy,
    required this.onVerificationDone,
    required this.onVerificationFailed,
    super.key,
    this.remainingScans,
  });

  /// The number of remaining scans.
  final int? remainingScans;

  /// The strategy to use for the connection.
  final ConnectionStrategy strategy;

  /// The function to call when the verification is done.
  final Future<void> Function(
    UrpSecSecureMeasurement measurement,
  ) onVerificationDone;

  /// Called when the verification fails.
  ///
  /// The [exception] is extracted from the [LdException] that was produced by
  /// the exception mapper. If the original exception was already a
  /// [SecReaderException], it is passed through directly. Otherwise, a new
  /// [SecReaderException] is created using the mapper's localized message.
  final Future<void> Function(
    SecReaderException exception,
  ) onVerificationFailed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LdSubmit<UrpSecSecureMeasurement>(
        config: LdSubmitConfig<UrpSecSecureMeasurement>(
          loadingText: SecLocalizations.of(context).scanning,
          submitText: SecLocalizations.of(context).startScan,
          timeout: const Duration(seconds: 35),
          action: () async {
            final reader = SECReader(
              connectionStrategy: strategy,
            );
            final result = await reader.startMeasurement();

            return result;
          },
        ),
        builder: LdSubmitCustomBuilder<UrpSecSecureMeasurement>(
          builder: (context, measurementController, measurementStateType) {
            switch (measurementStateType) {
              case (LdSubmitStateType.loading):
                return LdAutoSpace(
                  key: const Key('loading-scanning-view'),
                  crossAxisAlignment: CrossAxisAlignment.center,
                  animate: true,
                  children: [
                    LdTextHs(
                      SecLocalizations.of(context).scanning,
                      textAlign: TextAlign.center,
                    ),
                    LdTextP(
                      SecLocalizations.of(context).distanceHint,
                      textAlign: TextAlign.center,
                    ),
                    ldSpacerL,
                    const Expanded(
                      child: ScanningInstruction(),
                    ),
                    ldSpacerL,
                    const CountDownProgress(),
                    ldSpacerL,
                  ],
                );
              case (LdSubmitStateType.result):
                final result = measurementController.state.result!;

                return LdAutoSpace(
                  key: const Key('result-scanning-view'),
                  crossAxisAlignment: CrossAxisAlignment.center,
                  animate: true,
                  children: [
                    LdTextHs(
                      SecLocalizations.of(context).successfullyVerified,
                      textAlign: TextAlign.center,
                    ),
                    ldSpacerL,
                    Expanded(
                      child: SecReaderVisualization(
                        ledColor: Colors.green,
                        screenContent: Center(
                          child: Text(
                            SecLocalizations.of(context).successfullyVerified,
                          ),
                        ),
                      ),
                    ),
                    ldSpacerL,
                    LdButtonVague(
                      width: double.infinity,
                      borderRadius: LdTheme.of(context).radius(LdSize.l),
                      size: LdSize.l,
                      onPressed: () async {
                        await onVerificationDone(
                          result,
                        );
                      },
                      loadingText: SecLocalizations.of(context).disconnecting,
                      child: Text(
                        SecLocalizations.of(context).done,
                      ),
                    ),
                  ],
                );
              case (LdSubmitStateType.idle):
                return LdAutoSpace(
                  key: const Key('idle-scanning-view'),
                  animate: true,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LdTextHs(
                      SecLocalizations.of(context).readyToScan,
                      textAlign: TextAlign.center,
                    ),
                    LdTextP(
                      SecLocalizations.of(context).timeHint,
                      textAlign: TextAlign.center,
                    ),
                    Expanded(
                      child: SecReaderVisualization(
                        ledColor: Colors.yellow,
                        screenContent: Center(
                          child: Text(
                            SecLocalizations.of(context).readyToScan,
                          ),
                        ),
                      ),
                    ),
                    LdMute(
                      child: LdTextPs(
                        SecLocalizations.of(context)
                            .readingsLeft(remainingScans ?? 0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    LdButtonVague(
                      onPressed: measurementController.trigger,
                      borderRadius: LdTheme.of(context).radius(LdSize.l),
                      width: double.infinity,
                      size: LdSize.l,
                      child: Text(
                        SecLocalizations.of(context).startScan,
                      ),
                    ),
                  ],
                );
              case (LdSubmitStateType.error):
                final message = measurementController.state.error?.message ??
                    SecLocalizations.of(context).verificationFailedMessage;
                return LdAutoSpace(
                  key: const Key('failed-scanning-view'),
                  animate: true,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LdTextHs(
                      SecLocalizations.of(context).verificationFailed,
                      textAlign: TextAlign.center,
                    ),
                    LdTextP(
                      message,
                      textAlign: TextAlign.center,
                    ),
                    Expanded(
                      child: SecReaderVisualization(
                        ledColor: Colors.red,
                        screenContent: Container(),
                      ),
                    ),
                    LdButtonWarning(
                      width: double.infinity,
                      borderRadius: LdTheme.of(context).radius(LdSize.l),
                      size: LdSize.l,
                      onPressed: () {
                        return onVerificationFailed(
                          SecReaderException.from(
                            measurementController.state.error?.exception,
                            fallbackMessage:
                                measurementController.state.error?.message,
                          ),
                        );
                      },
                      loadingText: SecLocalizations.of(context).disconnecting,
                      context: context,
                      child: Text(
                        SecLocalizations.of(context).done,
                      ),
                    ),
                  ],
                );
            }
          },
        ),
      ),
    );
  }
}
