import 'dart:async';
import 'dart:io';

import 'package:mtrust_sec_kit/mtrust_sec_kit.dart';
import 'package:mtrust_sec_kit/src/sec_reader_exception.dart';

/// [SECReader] is a class that provides a high-level API to interact with
/// a SEC reader.
class SECReader extends CmdWrapper {
  /// Creates a new instance of [SECReader]
  /// [connectionStrategy] is the connectionStrategy to use for the connection.
  /// [target] is the target device to connect to. it defaults to a
  /// [UrpDeviceType.urpSec] reader.
  /// [origin] is the origin device. It defaults to a [UrpDeviceType.urpMobile]
  /// on iOS and Android else it will use [UrpDeviceType.urpDesktop].
  SECReader({
    required this.connectionStrategy,
    UrpDeviceIdentifier? target,
    UrpDeviceIdentifier? origin,
  }) : target = target ??
              UrpDeviceIdentifier(
                deviceClass: UrpDeviceClass.urpReader,
                deviceType: UrpDeviceType.urpSec,
              ),
        origin = origin ??
            UrpDeviceIdentifier(
              deviceClass: UrpDeviceClass.urpHost,
              deviceType: (Platform.isAndroid || Platform.isIOS)
                  ? UrpDeviceType.urpMobile
                  : UrpDeviceType.urpDesktop,
            );

    /// The connectionStrategy used to connect the device.
    final ConnectionStrategy connectionStrategy;

    /// The target device.
    final UrpDeviceIdentifier target;

    /// The origin device.
    final UrpDeviceIdentifier origin;

  /// Find and connect to a SEC reader using the given [connectionStrategy].
  /// If [deviceAddress] is provided, it will try to connect to the reader
  /// with the given address.
  static Future<SECReader> findAndConnect(
    ConnectionStrategy connectionStrategy, {
    String? deviceAddress,
  }) async {
    final connceted = await connectionStrategy.findAndConnectDevice(
      readerTypes: {UrpDeviceType.urpSec},
      deviceAddress: deviceAddress,
    );

    if (!connceted) {
      throw SecReaderException(message: 'Failed to connect to reader');
    }

    return SECReader(connectionStrategy: connectionStrategy);
  }

  /// Returns a list of all available [UrpDeviceType.urpSec] and
  /// [UrpDeviceType.urpSecQc] reader.
  static Stream<FoundDevice> findReaders(ConnectionStrategy connectionStrategy){
    return connectionStrategy.findDevices({
      UrpDeviceType.urpSec,
      UrpDeviceType.urpSecQc,
    });
  }

  /// Connect to a [FoundDevice].
  Future<SECReader> connectTo(
    FoundDevice reader,
    ConnectionStrategy connectionStrategy,
  ) async {
    final connected = await connectionStrategy.findAndConnectDevice(
      readerTypes: {reader.type},
      deviceAddress: reader.address,
    );

    if (!connected) {
      throw SecReaderException(
        message: 'Failed to connect to found reader $reader',
      );
    }

    return SECReader(connectionStrategy: connectionStrategy);
  }

  /// Pings the device.
  Future<void> pingDevice() async {
    await connectionStrategy.addQueue(
      UrpSecCommandWrapper(
        coreCommand: ping(),
      ).writeToBuffer(),
      target, 
      origin,
    );
  }

  /// Returns the device info. Throws an error if failed.
  Future<UrpDeviceInfo> getInfo() async {
    final res = await connectionStrategy.addQueue(
      UrpSecCommandWrapper(
        coreCommand: info(),
      ).writeToBuffer(),
      target,
      origin,
    );

    if (!res.hasPayload()) {
      throw SecReaderException(message: 'Failed to get info');
    }
    return UrpDeviceInfo.fromBuffer(res.payload);
  }

  /// Returns the power state of the device. Throws an error if failed.
  Future<UrpPowerState> getPowerState() async {
    final res = await connectionStrategy.addQueue(
      UrpSecCommandWrapper(
        coreCommand: getPower(),
      ).writeToBuffer(),
      target,
      origin,
    );

    if(!res.hasPayload()) {
      throw SecReaderException(message: 'Failed to get power state');
    }
    return UrpPowerState.fromBuffer(res.payload);
  }

  /// Sets the name of the device.
  Future<void> setDeviceName(String name) async {
    await connectionStrategy.addQueue(
      UrpSecCommandWrapper(
        coreCommand: setName(name),
      ).writeToBuffer(),
      target, 
      origin,
    );
  }

  /// Returns the devic name. Throws an error if failed.
  Future<UrpDeviceName> getDeviceName() async {
    final res = await connectionStrategy.addQueue(
      UrpSecCommandWrapper(
        coreCommand: getName(),
      ).writeToBuffer(),
      target,
      origin,
    );

    if(!res.hasPayload()) {
      throw SecReaderException(message: 'Failed to get name');
    }
    return UrpDeviceName.fromBuffer(res.payload);
  }

  /// Pair the device.
  Future<void> pairDevice() async {
    await connectionStrategy.addQueue(
      UrpSecCommandWrapper(
        coreCommand: pair(),
      ).writeToBuffer(),
      target, 
      origin,
    );
  }

  /// Unpair the device.
  Future<void> unpairDevice() async {
    await connectionStrategy.addQueue(
      UrpSecCommandWrapper(
        coreCommand: unpair(),
      ).writeToBuffer(),
      target, 
      origin,
    );
  }

  /// Starts the DFU mode of the device.
  Future<void> startDFUMode() async {
    await connectionStrategy.addQueue(
      UrpSecCommandWrapper(
        coreCommand: startDFU(),
      ).writeToBuffer(),
      target, 
      origin,
    );
  }

  /// Stops the DFU mode of the device.
  Future<void> stopDFUMode() async {
    await connectionStrategy.addQueue(
      UrpSecCommandWrapper(
        coreCommand: stopDFU(),
      ).writeToBuffer(),
      target, 
      origin,
    );
  }

  /// Puts the device to sleep mode. This will disconnect the device.
  Future<void> sleepMode() async {
    await connectionStrategy.addQueue(
      UrpSecCommandWrapper(
        // super.sleep necessary because of dart:io sleep method
        coreCommand: super.sleep(),
      ).writeToBuffer(),
      target, 
      origin,
    );
  }

  /// Turns the device off. This will disconnect the device.
  Future<void> turnOff() async {
    await connectionStrategy.addQueue(
      UrpSecCommandWrapper(
        coreCommand: off(),
      ).writeToBuffer(),
      target, 
      origin,
    );
  }

  /// Reboots the device. This will disconnect the device.
  Future<void> rebootDevice() async {
    await connectionStrategy.addQueue(
      UrpSecCommandWrapper(
        coreCommand: reboot(),
      ).writeToBuffer(),
      target, 
      origin,
    );
  }

  /// Prevents the device from going to sleep mode.
  Future<void> keepAwake() async {
    await connectionStrategy.addQueue(
      UrpSecCommandWrapper(
        coreCommand: stayAwake(),
      ).writeToBuffer(),
      target, 
      origin,
    );
  }

  /// Returns the public key of the device. Throws an error if failed.
  Future<UrpPublicKey> getKey() async {
    final res = await connectionStrategy.addQueue(
      UrpSecCommandWrapper(
        coreCommand: getPublicKey(),
      ).writeToBuffer(),
      target,
      origin,
    );

    if(!res.hasPayload()) {
      throw SecReaderException(message: 'Failed to get public key');
    }
    return UrpPublicKey.fromBuffer(res.payload);
  }

  /// Return the device id. Throws an error if failed.
  Future<UrpDeviceId> getId() async {
    final res = await connectionStrategy.addQueue(
      UrpSecCommandWrapper(
        coreCommand: getDeviceId(),
      ).writeToBuffer(),
      target,
      origin,
    );

    if(!res.hasPayload()) {
      throw SecReaderException(message: 'Failed to get public key');
    }
    return UrpDeviceId.fromBuffer(res.payload);
  }

  /// Identify reader. Triggers the LED to identify the device.
  Future<void> identifyDevice() async {
    await connectionStrategy.addQueue(
      UrpSecCommandWrapper(
        coreCommand: identify(),
      ).writeToBuffer(),
      target, 
      origin,
    );
  }

  /// Prepares (primes) a measurement for the given [payload].
  Future<void> prime(String payload) async {
    await connectionStrategy.addQueue(
      UrpSecCommandWrapper(
        deviceCommand: UrpSecDeviceCommand(
          command: UrpSecCommand.urpSecPrime,
          primeParameters: UrpSecPrimeParameters(payload: payload),
        ),
      ).writeToBuffer(),
      target,
      origin,
    );
  }

  /// Unprime a measurement.
  Future<void> unprime() async {
    await connectionStrategy.addQueue(
      UrpSecCommandWrapper(
        deviceCommand: UrpSecDeviceCommand(
          command: UrpSecCommand.urpSecUnprime,
        ),
      ).writeToBuffer(),
      target,
      origin,
    );
  }

  /// Measures until detection. Returns the result if successful.
  /// Triggers an error if failed.
  Future<UrpSecMeasurement> startMeasurement() async {
    final result = await connectionStrategy.addQueue(
      UrpSecCommandWrapper(
        deviceCommand: UrpSecDeviceCommand(
          command: UrpSecCommand.urpSecStartMeasurement,
        ),
      ).writeToBuffer(),
      target,
      origin,
      timeout: const Duration(seconds: 30),
    );

    if (!result.hasPayload()) {
      throw Exception('Failed to measure.');
    }
    return UrpSecMeasurement.fromBuffer(result.payload);
  }

  /// Stop measurement
  Future<void> stopMeasurement() async {
    await connectionStrategy.addQueue(
      UrpSecCommandWrapper(
        deviceCommand: UrpSecDeviceCommand(
          command: UrpSecCommand.urpSecStopMeasurement,
        ),
      ).writeToBuffer(),
      target,
      origin,
    );
  }

  /// Get model info. Returns the result if successful.
  /// Triggers an error if failed.
  Future<UrpSecModelInfo> getModelInfo() async {
    final res = await connectionStrategy.addQueue(
      UrpSecCommandWrapper(
        deviceCommand: UrpSecDeviceCommand(
          command: UrpSecCommand.urpSecGetModelInfo,
        ),
      ).writeToBuffer(),
      target,
      origin,
    );

    if (!res.hasPayload()) {
      throw Exception('Failed to get model info');
    }
    return UrpSecModelInfo.fromBuffer(res.payload);
  }
}
