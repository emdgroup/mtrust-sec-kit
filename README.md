# SEC-Kit

<img src="./banner.png" alt="Description" width="200">

[![Documentation Status](https://img.shields.io/badge/Documentation-SEC--Kit%20Docs-blue?style=flat&logo=readthedocs)](https://docs.mtrust.io/sdks/sec-kit/)


[![pub package](https://img.shields.io/pub/v/mtrust_sec_kit.svg)](https://pub.dev/packages/mtrust_sec_kit)
[![pub points](https://img.shields.io/pub/points/mtrust_sec_kit)](https://pub.dev/packages/mtrust_sec_kit/score)
[![style: very good analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)

## Overview

The SEC-Kit simplifies the integration of the M-Trust SEC-Reader into your Flutter application, providing secure and efficient communication capabilities.

## Prerequisites

- Flutter SDK installed on your system.
- Basic knowledge of Flutter development.
- Access to the M-Trust SEC-Reader hardware, or use the `mtrust_virtual_strategy` for development without the hardware.

## Installation

Add the `mtrust_sec_kit` to your Flutter project via the pub add command

```
flutter pub add mtrust_sec_kit
```
or manually add it to your `pubspec.yaml`

```yaml
dependencies:
  mtrust_sec_kit: ˆ1.0.0
```

SEC-Kit can work with different URP Connection Strategy. The default for SEC Readers is BLE. 
Add the ble connection strategy to your project by including it in your `pubspec.yaml` file.
```yaml
dependencies:
  mtrust_sec_kit: ˆ1.0.0
  # Add the BLE connection strategy
  mtrust_urp_ble_strategy: ˆ8.0.1
```

Please follow the instructions for configuring BLE for your respective platform in the [README](https://github.com/emdgroup/mtrust-urp/blob/main/mtrust_urp_ble_strategy/README.md) of the `urp_ble_strategy`!

## Usage


### Fonts

SEC-Kit utilizes the Lato font and custom icons. To include these assets, update your `pubspec.yaml`:

```yaml
fluter:
  fonts: 
    - family: Lato
      fonts:
        - asset: packages/liquid_flutter/fonts/Lato-Regular.ttf
          weight: 500
        - asset: packages/liquid_flutter/fonts/Lato-Bold.ttf
          weight: 800
    - family: LiquidIcons
      fonts:
        - asset: packages/liquid_flutter/fonts/LiquidIcons.ttf
```


### Localization
To support multiple languages, add the necessary localization delegates to your application. For comprehensive guidance on internationalization, consult the [flutter documentation](https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization).

```dart
  return const MaterialApp(
    title: 'Your awesome application',
      localizationsDelegates: [
        ...LiquidLocalizations.delegate,
        ...UrpUiLocalizations.delegate,
        ...SecLocalizations.localizationsDelegates,
      ],
      
      home: MyHomePage(),
    );
```

## Adding UI dependencies

To utilize SEC-Kit's UI components, incorporate the following providers and portals:

1. **Theme Provider:** Wrap your app with LdThemeProvider:
    ```dart
    LdThemeProvider(
        child: MaterialApp(
          home: MyHomePage(),
        ),
    )
    ```

2. **Portal:** Enclose your Scaffold with LdPortal:

    ```dart
    LdPortal(
      child: Scaffold(
        ...
      ),
    )
    ```


## Use the SEC Sheet 

To display the SEC Sheet, utilize the `SecSheet` widget. It requires a connection strategy, a payload, and callbacks for the verification process:


```dart
  SecSheet(
    strategy: _connectionStrategy,
    payload: // Payload,
    onVerificationDone: () {},
    onVerificationFailed: () {},
    builder: (context, openSheet) {
      // Call openSheet to open the SEC Sheet
    },
  ),

```

## Configuration Options
- **Connection Strategies:** While BLE is the default, SEC-Kit supports various connection strategies. Ensure you include and configure the appropriate strategy package as needed.

## Troubleshooting
- **BLE Connectivity Issues:** Verify that your device's Bluetooth is enabled and that the M-Trust SEC-Reader is powered on and in range.

- **Font Rendering Problems:** Ensure that the font assets are correctly referenced in your `pubspec.yaml` and that the files exist in the specified paths.

## Contributing
We welcome contributions! Please fork the repository and submit a pull request with your changes. Ensure that your code adheres to our coding standards and includes appropriate tests.

## License
This project is licensed under the Apache 2.0 License. See the [LICENSE](./LICENSE) file for details.