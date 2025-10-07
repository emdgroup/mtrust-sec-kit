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
    this.tokenAmount,
    super.key,
  });

  /// Whether the connection should be disconnected when the sheet is closed.
  final bool disconnectOnClose;

  /// Whether the reader should be turned off when the sheet is closed.
  final bool turnOffOnClose;

  /// Strategy to use for the connection.
  final ConnectionStrategy strategy;

  /// Payload to send to the reader.
  final String payload;

  /// Will be called if a verification was successful.
  final void Function(UrpSecSecureMeasurement measurement) onVerificationDone;

  /// Will be called if a verification failed.
  final void Function(SecReaderException?) onVerificationFailed;

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
        canDismiss: canDismiss,
        insets: insets,
        topRadius: topRadius,
        bottomRadius: bottomRadius,
        useSafeArea: useSafeArea,
        strategy: strategy,
        payload: payload,
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
  final SecReaderException? exception;
}

/// Build a modal using [SecWidget], pops the result of the SEC verification.
/// The result is either [SecResultSuccess], [SecResultFailed]
/// or [SecResultDismissed]. If the user dismisses the modal via the back
/// button or the swip gesture, the result is null.
LdModal secModal({
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

  /// Amount of token to be requested on token refresh
  int? tokenAmount,
}) {
  return LdModal(
    disableScrolling: true,
    noHeader: true,
    showDismissButton: canDismiss,
    userCanDismiss: canDismiss,
    topRadius: topRadius,
    bottomRadius: bottomRadius,
    useSafeArea: useSafeArea,
    insets: insets,
    contentPadding: EdgeInsets.zero,
    fixedDialogSize: const Size(400, 400),
    size: LdSize.s,
    modalContent: (context) => AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
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
        ),
      ),
    ).padL(),
  );
}
