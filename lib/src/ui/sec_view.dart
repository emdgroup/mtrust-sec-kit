import 'package:flutter/material.dart';
import 'package:liquid_flutter/liquid_flutter.dart';
import 'package:mtrust_sec_kit/mtrust_sec_kit.dart';
import 'package:mtrust_sec_kit/src/ui/count_down_progress.dart';
import 'package:mtrust_sec_kit/src/ui/scanning_instruction.dart';

/// [SecWidget] is a widget that guides the user through the SEC
/// workflow.
class SecWidget extends StatelessWidget {
  /// Creates a new instance of [SecWidget]
  const SecWidget({
    required this.strategy,
    required this.payload,
    required this.onVerificationDone,
    required this.onVerificationFailed,
    this.storageAdapter,
    super.key,
  });

  /// The StorageAdapter to use for persisting the last connected and paired
  /// devices.
  final StorageAdapter? storageAdapter;

  /// The strategy to use for the connection.
  final ConnectionStrategy strategy;

  /// The payload to send to the reader.
  final String payload;

  /// Will be called if a verification was successful.
  final Future<void> Function(UrpSecMeasurement measurement) onVerificationDone;

  /// Will be called if a verification failed.
  final Future<void> Function() onVerificationFailed;

  @override
  Widget build(BuildContext context) {
    return DeviceConnector(
      connectionStrategy: strategy,
      storageAdapter: storageAdapter,
      connectedBuilder: (BuildContext context) {
        return LdSubmit<bool>(
          config: LdSubmitConfig<bool>(
            loadingText: SecLocalizations.of(context).primingTitle,
            autoTrigger: true,
            action: () async {
              final reader = SECReader(
                connectionStrategy: strategy,
              );
              await reader.prime(payload);
              return true;
            },
          ),
          builder: LdSubmitCustomBuilder<bool>(
            builder: (context, controller, stateType) {
              if (stateType == LdSubmitStateType.error) {
                return LdAutoSpace(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LdTextH(
                      SecLocalizations.of(context).primeFailed,
                      textAlign: TextAlign.center,
                    ),
                    LdTextP(
                      controller.state.error?.moreInfo ?? 'Unknown error',
                    ),
                    Expanded(
                      child: SecReaderVisualization(
                        ledColor: Colors.red,
                        screenContent: Container(),
                      ),
                    ),
                    LdButtonWarning(
                      onPressed: controller.trigger,
                      context: context,
                      child: Text(
                        SecLocalizations.of(context).retry,
                      ),
                    ),
                  ],
                );
              }

              if (stateType == LdSubmitStateType.loading) {
                return Center(
                  child: LdAutoSpace(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    animate: true,
                    children: [
                      const LdLoader(),
                      LdTextL(
                        SecLocalizations.of(context).primingTitle,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              return _ScanningView(
                strategy: strategy,
                onVerificationDone: (UrpSecMeasurement measurement) async {
                  controller.reset();
                  await onVerificationDone(measurement);
                },
                onVerificationFailed: () async {
                  controller.reset();
                  await onVerificationFailed();
                },
              );
            },
          ),
        );
      },
      deviceTypes: const {UrpDeviceType.urpSec},
    );
  }
}

class _ScanningView extends StatelessWidget {
  const _ScanningView({
    required this.strategy,
    required this.onVerificationDone,
    required this.onVerificationFailed,
  });

  final ConnectionStrategy strategy;
  final Future<void> Function(UrpSecMeasurement measurement) onVerificationDone;
  final Future<void> Function() onVerificationFailed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LdSubmit<UrpSecMeasurement>(
        config: LdSubmitConfig<UrpSecMeasurement>(
          loadingText: SecLocalizations.of(context).scanning,
          submitText: SecLocalizations.of(context).startScan,
          timeout: const Duration(seconds: 35),
          action: () async {
            final reader = SECReader(
              connectionStrategy: strategy,
            );
            return reader.startMeasurement();
          },
        ),
        builder: LdSubmitCustomBuilder<UrpSecMeasurement>(
          builder: (context, measurementController, measurementStateType) {
            return switch (measurementStateType) {
              (LdSubmitStateType.loading) => LdAutoSpace(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  animate: true,
                  children: [
                    LdTextH(
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
                ),
              (LdSubmitStateType.result) => LdAutoSpace(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  animate: true,
                  children: [
                    LdTextHs(
                      SecLocalizations.of(context).successfullyVerfied,
                      textAlign: TextAlign.center,
                    ),
                    ldSpacerL,
                    Expanded(
                      child: SecReaderVisualization(
                        ledColor: Colors.green,
                        screenContent: Center(
                          child: Text(
                            SecLocalizations.of(context).successfullyVerfied,
                          ),
                        ),
                      ),
                    ),
                    ldSpacerL,
                    LdButtonSuccess(
                      onPressed: () async {
                        await onVerificationDone(
                          measurementController.state.result!,
                        );
                      },
                      loadingText: SecLocalizations.of(context).disconnecting,
                      context: context,
                      child: Text(
                        SecLocalizations.of(context).done,
                      ),
                    ),
                    ldSpacerL,
                  ],
                ),
              (LdSubmitStateType.idle) => LdAutoSpace(
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
                        screenContent: Container(),
                      ),
                    ),
                    LdButton(
                      onPressed: measurementController.trigger,
                      child: Text(
                        SecLocalizations.of(context).startScan,
                      ),
                    ),
                  ],
                ).padL(),
              (LdSubmitStateType.error) => LdAutoSpace(
                  animate: true,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LdTextHs(
                      SecLocalizations.of(context).verificationFailed,
                      textAlign: TextAlign.center,
                    ),
                    LdTextP(
                      SecLocalizations.of(context).verificationFailedMessage,
                      textAlign: TextAlign.center,
                    ),
                    Expanded(
                      child: SecReaderVisualization(
                        ledColor: Colors.red,
                        screenContent: Container(),
                      ),
                    ),
                    LdButtonWarning(
                      onPressed: onVerificationFailed,
                      loadingText: SecLocalizations.of(context).disconnecting,
                      context: context,
                      child: Text(
                        SecLocalizations.of(context).done,
                      ),
                    ),
                  ],
                ).padL(),
            };
          },
        ),
      ),
    );
  }
}
