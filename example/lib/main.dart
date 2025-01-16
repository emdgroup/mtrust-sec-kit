import 'package:example/virtual_strategy.dart';
import 'package:flutter/material.dart';
import 'package:mtrust_sec_kit/mtrust_sec_kit.dart';

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

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool _canDismiss = true;

  @override
  void initState() {
    virtualStrategy.createVirtualReader(FoundDevice(
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
          child: LdAutoSpace(children: [
            LdToggle(
                label: "User can dismiss modal",
                checked: _canDismiss,
                onChanged: (value) {
                  setState(() {
                    _canDismiss = value;
                  });
                }),
            SecModalBuilder(
              canDismiss: _canDismiss,
              strategy: virtualStrategy,
              payload: "<example payload>",
              onDismiss: () {
                debugPrint("Dismissed");
              },
              onVerificationDone: (measurement) {
                debugPrint("Verification done $measurement");
              },
              onVerificationFailed: () {
                debugPrint("Verification failed");
              },
              builder: (context, openModal) {
                return LdButton(
                  onPressed: openModal,
                  size: LdSize.l,
                  child: const Text("Start verification"),
                );
              },
            ),
            ldSpacerL,
          ]),
        ).padL(),
      ),
    );
  }
}
