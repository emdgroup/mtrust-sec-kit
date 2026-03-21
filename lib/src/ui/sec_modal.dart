import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:liquid_flutter/liquid_flutter.dart';
import 'package:mtrust_sec_kit/mtrust_sec_kit.dart';
import 'package:mtrust_sec_kit/src/ui/sec_result.dart';

/// Shows a sheet that guides the user through the SEC workflow.
/// pass the [ConnectionStrategy] and the [payload] to the sheet.
/// The [onVerificationDone] will be called if the verification was successful.
/// The [onVerificationFailed] will be called if the verification failed.
/// Provide a [builder] that renders some UI with a callback to open the sheet.
class SecModalBuilder extends StatelessWidget {
  /// Creates a new instance of [SecModalBuilder]
  const SecModalBuilder({
    required this.strategy,
    required this.payload,
    required this.onVerificationDone,
    required this.onVerificationFailed,
    required this.builder,
    this.onDismiss,
    this.disconnectOnClose = true,
    this.turnOffOnClose = true,
    this.canDismiss = true,
    this.storageAdapter,
    this.readerConnectorMode = ReaderConnectorMode.preferLastConnected,
    this.tokenAmount,
    super.key,
  });

  /// Whether the connection should be disconnected when the sheet is closed.
  final bool disconnectOnClose;

  /// Whether the reader should be turned off when the sheet is closed.
  final bool turnOffOnClose;

  /// The StorageAdapter to use for persisting the last connected and paired
  /// devices.
  final StorageAdapter? storageAdapter;

  /// The mode to use when connecting to a device.
  final ReaderConnectorMode readerConnectorMode;

  /// Strategy to use for the connection.
  final ConnectionStrategy strategy;

  /// Payload to send to the reader.
  final String payload;

  /// Will be called if a verification was successful.
  final void Function(UrpSecSecureMeasurement measurement) onVerificationDone;

  /// Called when the verification fails.
  ///
  /// Receives a [SecReaderException] describing the failure cause.
  /// Use [SecReaderException.type] to distinguish between failure types
  /// (e.g. [SecReaderExceptionType.tokenFailed],
  /// [SecReaderExceptionType.measurementFailed]).
  final void Function(
    SecReaderException exception,
  ) onVerificationFailed;

  /// Called when the user dismisses the sheet.
  final void Function()? onDismiss;

  /// The builder that opens the sheet.
  final Widget Function(BuildContext context, Function openSheet) builder;

  /// Whether the modal can be dissmissed by the user.
  final bool canDismiss;

  /// Amount of tokens to be requested on token refresh.
  final int? tokenAmount;

  @override
  Widget build(BuildContext context) {
    var topRadius = LdTheme.of(context).sizingConfig.radiusM;
    var bottomRadius = 0.0;
    var useSafeArea = true;
    var insets = EdgeInsets.zero;
    final screenRadius = LdTheme.of(context).screenRadius;

    if (screenRadius != 0) {
      topRadius = screenRadius - 1;
      bottomRadius = screenRadius - 1;
      if (!kIsWeb && Platform.isIOS) {
        useSafeArea = false;
        insets = const EdgeInsets.all(1);
      }
    }

    Future<void> handleClose() async {
      await Future<void>.delayed(const Duration(milliseconds: 500));
      if (turnOffOnClose && strategy.status == ConnectionStatus.connected) {
        await SECReader(connectionStrategy: strategy).off();
      }
      if (disconnectOnClose) {
        await strategy.disconnectDevice();
      }
    }

    return LdModalBuilder(
      builder: (context, openModal) {
        return builder(context, () async {
          final result = await openModal();
          if (result is SecResultFailed) {
            onVerificationFailed(result.exception);
          } else if (result is SecResultSuccess) {
            onVerificationDone(result.measurement);
          } else {
            onDismiss?.call();
          }
          await handleClose();
        });
      },
      modal: secModal(
        context: context,
        canDismiss: canDismiss,
        insets: insets,
        topRadius: topRadius,
        bottomRadius: bottomRadius,
        useSafeArea: useSafeArea,
        strategy: strategy,
        payload: payload,
        storageAdapter: storageAdapter,
        readerConnectorMode: readerConnectorMode,
        tokenAmount: tokenAmount,
      ),
    );
  }
}

/// Returned in case of a successful SEC verification.
class SecResultSuccess extends SecResult {
  /// Creates a new instance of [SecResultSuccess]
  SecResultSuccess(this.measurement);

  /// The resulting measurement.
  final UrpSecSecureMeasurement measurement;
}

/// Returned in case of a dismissed SEC verification.
class SecResultDismissed extends SecResult {}

/// Returned in case of a failed SEC verification (e.g. a timeout)
class SecResultFailed extends SecResult {
  /// Creates a new instance of [SecResultFailed]
  SecResultFailed(this.exception);

  /// The exception that caused the failure.
  final SecReaderException exception;
}

/// Build a modal using [SecWidget], pops the result of the SEC verification.
/// The result is either [SecResultSuccess], [SecResultFailed]
/// or [SecResultDismissed]. If the user dismisses the modal via the back
/// button or the swip gesture, the result is null.
LdModalRoute<SecResult> secModal({
  /// Whether the modal can be dissmissed by the user
  required bool canDismiss,

  /// The top radius of the modal
  required double topRadius,

  /// The bottom radius of the modal
  required double bottomRadius,

  /// The strategy to use for the connection
  required ConnectionStrategy strategy,

  /// The payload to send to the reader
  required String payload,

  /// The insets of the modal
  required EdgeInsets insets,

  /// Whether to use safe area inside the modal
  required bool useSafeArea,

  /// The context to use for the modal
  required BuildContext context,

  /// The StorageAdapter to use for persisting the last connected and paired
  /// devices.
  StorageAdapter? storageAdapter,

  /// The mode to use when connecting to a device.
  ReaderConnectorMode readerConnectorMode = ReaderConnectorMode.preferLastConnected,

  /// Amount of token to be requested on token refresh
  int? tokenAmount,
}) {
  return LdModalRoute(
    barrierDismissible: canDismiss,
    context: context,
    fixedDialogSize: const Size(400, 400),
    sheetAspectRatio: 1,
    pageBuilder: (BuildContext context) => LdScaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: SecWidget(
              strategy: strategy,
              payload: payload,
              onVerificationDone: (UrpSecSecureMeasurement measurement) async {
                Navigator.of(context).pop(SecResultSuccess(measurement));
              },
              onVerificationFailed: (exception) async {
                Navigator.of(context).pop(SecResultFailed(exception));
              },
              tokenAmount: tokenAmount,
            ).padL(),
          ),
          if (canDismiss)
            Align(
              alignment: Alignment.topRight,
              child: Column(
                children: [
                  LdButton.ghost(
                    size: LdSize.l,
                    onPressed: () {
                      Navigator.of(context).pop(SecResultDismissed());
                    },
                    child: const Icon(Icons.close),
                  ).padS(),
                ],
              ),
            ),
        ],
      ),
    ),
  );
}
