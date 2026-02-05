// ignore_for_file: avoid_dynamic_calls

import 'package:flutter/material.dart';
import 'package:liquid_flutter/liquid_flutter.dart';
import 'package:mtrust_sec_kit/mtrust_sec_kit.dart';
import 'package:mtrust_sec_kit/src/ui/scanning_view.dart';

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

  /// Called when verification fails; receives the underlying [SecReaderException]
  /// when available, otherwise `null`.
  final Future<void> Function(
    SecReaderException exception,
  ) onVerificationFailed;

  /// Amount of token to be requested on token refresh.
  final int? tokenAmount;

  @override
  Widget build(BuildContext context) {
    final locale = SecLocalizations.of(context);
    return LdExceptionMapperProvider(
      exceptionMapper: _SecExceptionMapper(
        secLocalizations: locale,
        localizations: LiquidLocalizations.of(context),
      ),
      child: DeviceConnector(
        connectionStrategy: strategy,
        storageAdapter: storageAdapter,
        connectedBuilder: (BuildContext context) {
          return LdSubmit<UrpSecPrimeResponse?>(
            config: LdSubmitConfig<UrpSecPrimeResponse?>(
              loadingText: locale.primingTitle,
              autoTrigger: true,
              action: () async {
                final reader = SECReader(
                  connectionStrategy: strategy,
                );

                if (tokenAmount != null) {
                  reader.setTokenAmount(tokenAmount!);
                }
                return reader.prime(payload);
              },
            ),
            builder: LdSubmitCustomBuilder<UrpSecPrimeResponse?>(
              builder: (context, controller, stateType) {
                if (stateType == LdSubmitStateType.error) {
                  var message =
                      controller.state.error?.message ?? 'Unknown error';

                  if (controller.state.error?.exception.runtimeType
                      is ApiException) {
                    message = locale.tokenFailed;
                  }
                  return LdAutoSpace(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      LdTextHs(
                        locale.primeFailed,
                        textAlign: TextAlign.center,
                      ),
                      Expanded(
                        child: SecReaderVisualization(
                          ledColor: Colors.red,
                          screenContent: Container(),
                        ),
                      ),
                      LdTextP(
                        message,
                        textAlign: TextAlign.center,
                      ),
                      if (controller.canRetry)
                        LdButtonWarning(
                          onPressed: controller.trigger,
                          context: context,
                          child: Text(
                            locale.retry,
                          ),
                        )
                      else
                        LdButtonWarning(
                          onPressed: () {
                            final secException = SecReaderException.from(
                              controller.state.error?.exception,
                              fallbackMessage: controller.state.error?.message,
                            );
                            return onVerificationFailed(secException);
                          },
                          context: context,
                          child: Text(
                            locale.done,
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
                          locale.primingTitle,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return ScanningView(
                  strategy: strategy,
                  onVerificationDone: (
                    UrpSecSecureMeasurement measurement,
                  ) async {
                    controller.reset();
                    await onVerificationDone(measurement);
                  },
                  onVerificationFailed: (e) async {
                    controller.reset();
                    await onVerificationFailed(e);
                  },
                  remainingScans: controller.state.result?.gsa,
                );
              },
            ),
          );
        },
        deviceTypes: const {UrpDeviceType.urpSec},
      ),
    );
  }
}

class _SecExceptionMapper extends LdExceptionMapper {
  _SecExceptionMapper({
    required this.secLocalizations,
    required super.localizations,
  });

  final SecLocalizations secLocalizations;

  @override
  LdException handle(dynamic e, {StackTrace? stackTrace}) {
    if (e is SecReaderException) {
      final retriable = {
        SecReaderExceptionType.tokenFailed,
        SecReaderExceptionType.measurementFailed,
        SecReaderExceptionType.unspecified,
      };
      return LdException(
        message: switch (e.type) {
          SecReaderExceptionType.tokenFailed => secLocalizations.tokenFailed,
          SecReaderExceptionType.incompatibleFirmware =>
            secLocalizations.incompatibleFirmware,
          SecReaderExceptionType.measurementFailed =>
            secLocalizations.verificationFailedMessage,
          SecReaderExceptionType.unspecified => localizations.unknownError,
        },
        canRetry: retriable.contains(e.type),
        exception: e,
      );
    }

    return super.handle(e, stackTrace: stackTrace);
  }
}
