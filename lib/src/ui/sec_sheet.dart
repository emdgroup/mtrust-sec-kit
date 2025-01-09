import 'package:flutter/material.dart';
import 'package:liquid_flutter/liquid_flutter.dart';
import 'package:mtrust_sec_kit/mtrust_sec_kit.dart';

/// Shows a sheet that guides the user through the SEC workflow.
/// pass the [ConnectionStrategy] and the [payload] to the sheet.
/// The [onVerificationDone] will be called if the verification was successful.
/// The [onVerificationFailed] will be called if the verification failed.
/// Provide a [builder] that renders some UI with a callback to open the sheet.
class SecSheet extends StatelessWidget {
  /// Creates a new instance of [SecSheet]
  const SecSheet({
    required this.strategy,
    required this.payload,
    required this.onVerificationDone,
    required this.onVerificationFailed,
    required this.builder,
    this.onDismiss,
    this.disconnectOnClose = true,
    this.turnOffOnClose = true,
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
  final void Function(UrpSecMeasurement measurement) onVerificationDone;

  /// Will be called if a verification failed.
  final void Function() onVerificationFailed;

  /// Called when the user dismisses the sheet.
  final void Function()? onDismiss;

  /// The builder that opens the sheet.
  final Widget Function(BuildContext context, Function openSheet) builder;

  @override
  Widget build(BuildContext context) {
    return LdButtonSheet(
      buttonBuilder: builder,
      sheetBuilder: (context, dismissSheet, isOpen) {
        Future<void> dismiss() async {
          if (turnOffOnClose && strategy.status == ConnectionStatus.connected) {
            await SECReader(connectionStrategy: strategy).turnOff();
          }
          if (disconnectOnClose) {
            await strategy.disconnectDevice();
          }
          dismissSheet();
          onDismiss?.call();
        }

        return LdSheet(
          customDetachedSize: const Size(450, 450),
          open: isOpen,
          initialSize: 1,
          minInsets: LdTheme.of(context).pad(LdSize.m),
          noHeader: true,
          child: AspectRatio(
            aspectRatio: 1,
            child: Stack(
              children: [
                SecWidget(
                  strategy: strategy,
                  payload: payload,
                  onVerificationDone: (UrpSecMeasurement measurement) async {
                    onVerificationDone(measurement);
                    await dismiss();
                  },
                  onVerificationFailed: () async {
                    onVerificationFailed();
                    await dismiss();
                  },
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: IntrinsicHeight(
                    child: LdButton(
                      size: LdSize.s,
                      mode: LdButtonMode.vague,
                      onPressed: dismiss,
                      child: const Icon(
                        Icons.clear,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ).padL(),
        );
      },
    );
  }
}
