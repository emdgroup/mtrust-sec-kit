import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mtrust_sec_kit/mtrust_sec_kit.dart';

import 'package:mtrust_urp_virtual_strategy/mtrust_urp_virtual_strategy.dart';

import 'package:liquid_flutter/liquid_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(LdThemeProvider(
    child: LdThemedAppBuilder(appBuilder: (context, theme) {
      return MaterialApp(
        theme: theme,
        localizationsDelegates: const [
          DefaultMaterialLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
          LiquidLocalizations.delegate,
          SecLocalizations.delegate,
          UrpUiLocalizations.delegate,
        ],
        home: const MainApp(),
      );
    }),
  ));
}

extension PrependLength on Uint8List {
  Uint8List prependLength() {
    return Uint8List.fromList(_int16ToBytes(length) + this);
  }

  Uint8List _int16ToBytes(int value) {
    if (value < -32768 || value > 32767) {
      throw ArgumentError('Value must be between -32768 and 32767.');
    }

    final bytes = Uint8List(2);

    // Store the two bytes in little-endian order
    bytes[0] = (value >> 8) & 0xFF; // Upper byte
    bytes[1] = value & 0xFF; // Lower byte

    return bytes;
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool _canDismiss = false;

  final _virtualStrategy = UrpVirtualStrategy((UrpRequest request) async {
    final payload = UrpSecCommandWrapper.fromBuffer(request.payload);
    final result = switch (payload.deviceCommand.command) {
      (UrpSecCommand.urpSecPrime) => UrpResponse(),
      (UrpSecCommand.urpSecStartMeasurement) => UrpResponse(
          payload: UrpSecMeasurement(
            nonce: 12,
            readerId: "foo",
            signature: "bar",
          ).writeToBuffer(),
        ),
      _ => switch (payload.coreCommand.command) {
          (UrpCommand.urpOff) => UrpResponse(),
          _ => throw Exception("Command not supported"),
        },
    };

    await Future.delayed(const Duration(seconds: 2));

    return result;
  });

  //late final _bleStrategy = UrpBleStrategy();

  @override
  void initState() {
    _virtualStrategy.createVirtualReader(FoundDevice(
      name: "SEC-000123",
      type: UrpDeviceType.urpSec,
      address: "00:00:00:00:00:00",
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LdPortal(
      child: Scaffold(
        appBar: LdAppBar(
          context: context,
          title: const Text(
            "SEC Kit Example",
          ),
        ),
        body: SafeArea(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                LdToggle(
                    label: "User can dismiss modal",
                    checked: _canDismiss,
                    onChanged: (value) {
                      setState(() {
                        _canDismiss = value;
                      });
                    }).padL(),
                ldSpacerL,
                SecModalBuilder(
                  canDismiss: _canDismiss,
                  strategy: _virtualStrategy,
                  payload: "",
                  onDismiss: () {
                    debugPrint("Dismissed");
                  },
                  onVerificationDone: (measurement) {
                    debugPrint("Verification done $measurement");
                  },
                  onVerificationFailed: () {
                    debugPrint("Verification failed");
                  },
                  builder: (context, openSheet) {
                    return LdButton(
                      onPressed: openSheet,
                      child: const Text("Open SEC Sheet"),
                    );
                  },
                ),
                ldSpacerL,
              ]),
        ),
      ),
    );
  }
}
