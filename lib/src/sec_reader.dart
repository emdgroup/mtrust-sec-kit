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

  Future<UrpResponse> _addCommandToQueue({
    UrpCoreCommand? coreCommand, 
    UrpSecDeviceCommand? deviceCommand,
  }) async {
    return connectionStrategy.addQueue(
      UrpSecCommandWrapper(
        coreCommand: coreCommand,
        deviceCommand: deviceCommand,
      ).writeToBuffer(), 
      target, 
      origin,
    );
  }

  /// Pings the device.
  @override
  Future<void> ping() async {
    final cmd = UrpCoreCommand(
      command: UrpCommand.urpPing,
    );
    await _addCommandToQueue(coreCommand: cmd);
  }

  /// Returns the device info. Throws an error if failed.
  @override
  Future<UrpDeviceInfo> info() async {
    final cmd = UrpCoreCommand(
      command: UrpCommand.urpGetInfo,
    );
    final res = await _addCommandToQueue(coreCommand: cmd);

    if (!res.hasPayload()) {
      throw SecReaderException(message: 'Failed to get info');
    }
    return UrpDeviceInfo.fromBuffer(res.payload);
  }

  /// Returns the power state of the device. Throws an error if failed.
  @override
  Future<UrpPowerState> getPower() async {
    final cmd = UrpCoreCommand(
      command: UrpCommand.urpGetPower,
    );
    final res = await _addCommandToQueue(coreCommand: cmd);

    if(!res.hasPayload()) {
      throw SecReaderException(message: 'Failed to get power state');
    }
    return UrpPowerState.fromBuffer(res.payload);
  }

  /// Sets the name of the device.
  @override
  Future<void> setName(String? name) async {
    final cmd = UrpCoreCommand(
      command: UrpCommand.urpSetName,
      setNameParameters: UrpSetNameParameters(name: name),
    );
    await _addCommandToQueue(coreCommand: cmd);
  }

  /// Returns the devic name. Throws an error if failed.
  @override
  Future<UrpDeviceName> getName() async {
    final cmd = UrpCoreCommand(
      command: UrpCommand.urpGetName,
    );
    final res = await _addCommandToQueue(coreCommand: cmd);

    if(!res.hasPayload()) {
      throw SecReaderException(message: 'Failed to get name');
    }
    return UrpDeviceName.fromBuffer(res.payload);
  }

  /// Pair the device.
  @override
  Future<void> pair() async {
    final cmd = UrpCoreCommand(
      command: UrpCommand.urpPair,
    );
    await _addCommandToQueue(coreCommand: cmd);
  }

  /// Unpair the device.
  @override
  Future<void> unpair() async {
    final cmd = UrpCoreCommand(
      command: UrpCommand.urpUnpair,
    );
    await _addCommandToQueue(coreCommand: cmd);
  }

  /// Starts the DFU mode of the device.
  @override
  Future<void> startDFU() async {
    final cmd = UrpCoreCommand(
      command: UrpCommand.urpStartDfu,
    );
    await _addCommandToQueue(coreCommand: cmd);
  }

  /// Stops the DFU mode of the device.
  @override
  Future<void> stopDFU() async {
    final cmd = UrpCoreCommand(
      command: UrpCommand.urpStopDfu,
    );
    await _addCommandToQueue(coreCommand: cmd);
  }

  /// Puts the device to sleep mode. This will disconnect the device.
  @override
  Future<void> sleep() async {
    final cmd = UrpCoreCommand(
      command: UrpCommand.urpSleep,
    );
    await _addCommandToQueue(coreCommand: cmd);
  }

  /// Turns the device off. This will disconnect the device.
  @override
  Future<void> off() async {
    final cmd = UrpCoreCommand(
      command: UrpCommand.urpOff,
    );
    await _addCommandToQueue(coreCommand: cmd);
  }

  /// Reboots the device. This will disconnect the device.
  @override
  Future<void> reboot() async {
    final cmd = UrpCoreCommand(
      command: UrpCommand.urpReboot,
    );
    await _addCommandToQueue(coreCommand: cmd);
  }

  /// Prevents the device from going to sleep mode.
  @override
  Future<void> stayAwake() async {
    final cmd = UrpCoreCommand(
      command: UrpCommand.urpStayAwake,
    );
    await _addCommandToQueue(coreCommand: cmd);
  }

  /// Returns the public key of the device. Throws an error if failed.
  @override
  Future<UrpPublicKey> getPublicKey() async {
    final cmd = UrpCoreCommand(
      command: UrpCommand.urpGetPublicKey,
    );
    final res = await _addCommandToQueue(coreCommand: cmd);

    if(!res.hasPayload()) {
      throw SecReaderException(message: 'Failed to get public key');
    }
    return UrpPublicKey.fromBuffer(res.payload);
  }

  /// Return the device id. Throws an error if failed.
  @override
  Future<UrpDeviceId> getDeviceId() async {
    final cmd = UrpCoreCommand(
      command: UrpCommand.urpGetDeviceId,
    );
    final res = await _addCommandToQueue(coreCommand: cmd);

    if(!res.hasPayload()) {
      throw SecReaderException(message: 'Failed to get public key');
    }
    return UrpDeviceId.fromBuffer(res.payload);
  }

  /// Identify reader. Triggers the LED to identify the device.
  @override
  Future<void> identify() async {
    final cmd = UrpCoreCommand(
      command: UrpCommand.urpIdentify,
    );
    await _addCommandToQueue(coreCommand: cmd);
  }

  /// Connect AP. Throws an error if failed.
  @override
  Future<UrpWifiState> connectAP(String ssid, String apk) async {
    final cmd = UrpCoreCommand(
      command: UrpCommand.urpConnectAp,
      apParameters: UrpApParamters(ssid: ssid, password: apk),
    );
    final res = await _addCommandToQueue(coreCommand: cmd);

    if(!res.hasPayload()) {
      throw SecReaderException(message: 'Failed to connect to AP');
    }
    return UrpWifiState.fromBuffer(res.payload);
  }
  
  /// Disconnect AP.
  @override
  Future<void> disconnectAP() async {
    final cmd = UrpCoreCommand(
      command: UrpCommand.urpDisconnectAp,
    );
    await _addCommandToQueue(coreCommand: cmd);
  }
  
  /// Start AP. Throws an error if failed.
  @override
  Future<UrpWifiState> startAP(String ssid, String apk) async {
    final cmd = UrpCoreCommand(
      command: UrpCommand.urpStartAp,
      apParameters: UrpApParamters(ssid: ssid, password: apk),
    );
    final res = await _addCommandToQueue(coreCommand: cmd);

    if(!res.hasPayload()) {
      throw SecReaderException(message: 'Failed to start AP');
    }
    return UrpWifiState.fromBuffer(res.payload);
  }
  
  /// Stop AP.
  @override
  Future<void> stopAP() async {
    final cmd = UrpCoreCommand(
      command: UrpCommand.urpStopAp,
    );
    await _addCommandToQueue(coreCommand: cmd);
  }

  /// Prepares (primes) a measurement for the given [payload].
  Future<void> prime(String payload) async {
    final cmd = UrpSecDeviceCommand(
      command: UrpSecCommand.urpSecPrime,
      primeParameters: UrpSecPrimeParameters(payload: payload),
    );
    await _addCommandToQueue(deviceCommand: cmd);
  }

  /// Unprime a measurement.
  Future<void> unprime() async {
    final cmd = UrpSecDeviceCommand(
      command: UrpSecCommand.urpSecUnprime,
    );
    await _addCommandToQueue(deviceCommand: cmd);
  }

  /// Measures until detection. Returns the result if successful.
  /// Triggers an error if failed.
  Future<UrpSecMeasurement> startMeasurement() async {
    final cmd = UrpSecDeviceCommand(
      command: UrpSecCommand.urpSecStartMeasurement,
    );
    final result = await _addCommandToQueue(deviceCommand: cmd);

    if (!result.hasPayload()) {
      throw Exception('Failed to measure.');
    }
    return UrpSecMeasurement.fromBuffer(result.payload);
  }

  /// Stop measurement
  Future<void> stopMeasurement() async {
    final cmd = UrpSecDeviceCommand(
      command: UrpSecCommand.urpSecStopMeasurement,
    );
    await _addCommandToQueue(deviceCommand: cmd);
  }

  /// Get model info. Returns the result if successful.
  /// Triggers an error if failed.
  Future<UrpSecModelInfo> getModelInfo() async {
    final cmd = UrpSecDeviceCommand(
      command: UrpSecCommand.urpSecGetModelInfo,
    );
    final res = await _addCommandToQueue(deviceCommand: cmd);

    if (!res.hasPayload()) {
      throw Exception('Failed to get model info');
    }
    return UrpSecModelInfo.fromBuffer(res.payload);
  }
  
}
