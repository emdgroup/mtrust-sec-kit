// ignore_for_file: avoid_dynamic_calls

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
    this.tokenAmount,
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
  final Future<void> Function(
    UrpSecSecureMeasurement measurement,
  ) onVerificationDone;

  /// Will be called if a verification failed.
  final Future<void> Function() onVerificationFailed;

  /// Amount of token to be requested on token refresh.
  final int? tokenAmount;

  @override
  Widget build(BuildContext context) {
    return DeviceConnector(
      connectionStrategy: strategy,
      storageAdapter: storageAdapter,
      connectedBuilder: (BuildContext context) {
        return LdSubmit<UrpSecPrimeResponse?>(
          config: LdSubmitConfig<UrpSecPrimeResponse?>(
            loadingText: SecLocalizations.of(context).primingTitle,
            autoTrigger: true,
            action: () async {
              final reader = SECReader(
                connectionStrategy: strategy,
              );
              if(tokenAmount != null) {
                reader.setTokenAmount(tokenAmount!);
              }
              return reader.prime(payload);
            },
          ),
          builder: LdSubmitCustomBuilder<UrpSecPrimeResponse?>(
            builder: (context, controller, stateType) {
              if (stateType == LdSubmitStateType.error) {
                var message = controller.state.error?.message 
                              ?? 'Unknown error';
                final moreInfo = controller.state.error?.moreInfo;
                if(controller.state.error?.exception.runtimeType 
                    == SecReaderException) {
                  final error = controller.state.error?.exception 
                                as SecReaderException;
                  if(error.type == SecReaderExceptionType.tokenFailed) {
                    message = SecLocalizations.of(context).tokenFailed;
                  }
                }
                return LdAutoSpace(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LdTextH(
                      SecLocalizations.of(context).primeFailed,
                      textAlign: TextAlign.center,
                    ),
                    LdTextP(
                      message,
                    ),
                    if(moreInfo != null)
                      LdTextP(
                        moreInfo,
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
                onVerificationDone: (
                  UrpSecSecureMeasurement measurement,
                ) async {
                  controller.reset();
                  await onVerificationDone(measurement);
                },
                onVerificationFailed: () async {
                  controller.reset();
                  await onVerificationFailed();
                },
                remainingScans: controller.state.result?.gsa,
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
    this.remainingScans,
  });

  final int? remainingScans;
  final ConnectionStrategy strategy;
  final Future<void> Function(
    UrpSecSecureMeasurement measurement,
  ) onVerificationDone;
  final Future<void> Function() onVerificationFailed;

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
            return reader.startMeasurement();
          },
        ),
        builder: LdSubmitCustomBuilder<UrpSecSecureMeasurement>(
          builder: (context, measurementController, measurementStateType) {
            switch (measurementStateType) {
              case (LdSubmitStateType.loading):
                return LdAutoSpace(
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
                return LdAutoSpace(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  animate: true,
                  children: [
                    LdTextHs(
                      SecLocalizations.of(context).successfullyVerfied,
                      textAlign: TextAlign.center,
                    ),
                    ldSpacerL,
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
                    LdButton(
                      onPressed: () async {
                        await onVerificationDone(
                          measurementController.state.result!,
                        );
                      },
                      loadingText: SecLocalizations.of(context).disconnecting,
                      child: Text(
                        SecLocalizations.of(context).done,
                      ),
                    ),
                    ldSpacerL,
                  ],
                );
              case (LdSubmitStateType.idle):
                return LdAutoSpace(
                  animate: true,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LdTextHs(
                      SecLocalizations.of(context).readyToScan,
                      textAlign: TextAlign.center,
                    ),
                    ldSpacerL,
                    LdTextP(
                      """${SecLocalizations.of(context).readingsLeft} ${remainingScans ?? 'Unknown'}""",
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
                ).padL();
              case (LdSubmitStateType.error): 
                var message = SecLocalizations.of(context)
                              .verificationFailedMessage;
                if(measurementController.state.error?.exception.runtimeType 
                    == SecReaderExceptionType) {
                  final error = measurementController.state.error?.exception 
                                as SecReaderException;
                  if(error.type == SecReaderExceptionType.incompatibleFirmware){
                    message = SecLocalizations.of(context).incompatibleFirmware;
                  }
                }
                return LdAutoSpace(
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
                      onPressed: onVerificationFailed,
                      loadingText: SecLocalizations.of(context).disconnecting,
                      context: context,
                      child: Text(
                        SecLocalizations.of(context).done,
                      ),
                    ),
                  ],
                ).padL();
            }
          },
        ),
      ),
    );
  }
}
