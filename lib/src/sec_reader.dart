import 'dart:async';
import 'dart:io';

import 'package:mtrust_sec_kit/mtrust_sec_kit.dart';
import 'package:mtrust_sec_kit/src/sec_reader_exception.dart';

/// [SECReader] is a class that provides a high-level API to interact with
/// a SEC reader.
class SECReader extends CmdWrapper {
  /// Creates a new instance of [SECReader]
  /// [connectionStrategy] is the strategy to use for the connection.
  /// [target] is the target device to connect to. it defaults to a
  /// [UrpDeviceType.urpSec] reader.
  /// [origin] is the origin device. It defaults to a [UrpDeviceType.urpMobile]
  /// on iOS and Android else it will use [UrpDeviceType.urpDesktop].
  SECReader({
    required ConnectionStrategy connectionStrategy,
    UrpDeviceIdentifier? target,
    UrpDeviceIdentifier? origin,
  }) : super(
          strategy: connectionStrategy,
          target: target ??
              UrpDeviceIdentifier(
                deviceClass: UrpDeviceClass.urpReader,
                deviceType: UrpDeviceType.urpSec,
              ),
          origin: origin ??
              UrpDeviceIdentifier(
                deviceClass: UrpDeviceClass.urpHost,
                deviceType: (Platform.isAndroid || Platform.isIOS)
                    ? UrpDeviceType.urpMobile
                    : UrpDeviceType.urpDesktop,
              ),
        );

  /// Find and connect to a SEC reader using the given [strategy].
  /// If [deviceAddress] is provided, it will try to connect to the reader
  /// with the given address.
  static Future<SECReader> findAndConnect(
    ConnectionStrategy strategy, {
    String? deviceAddress,
  }) async {
    final connceted = await strategy.findAndConnectDevice(
      readerTypes: {UrpDeviceType.urpSec},
      deviceAddress: deviceAddress,
    );

    if (!connceted) {
      throw SecReaderException(message: 'Failed to connect to reader');
    }

    return SECReader(connectionStrategy: strategy);
  }

  /// Returns a list of all available [UrpDeviceType.urpSec] and
  /// [UrpDeviceType.urpSecQc] reader
  static Stream<FoundDevice> findReaders(ConnectionStrategy strategy) {
    return strategy.findDevices({
      UrpDeviceType.urpSec,
      UrpDeviceType.urpSecQc,
    });
  }

  /// Connect to a [FoundDevice]
  Future<SECReader> connectTo(
    FoundDevice reader,
    ConnectionStrategy strategy,
  ) async {
    final connected = await strategy.findAndConnectDevice(
      readerTypes: {reader.type},
      deviceAddress: reader.address,
    );

    if (!connected) {
      throw SecReaderException(
        message: 'Failed to connect to found reader $reader',
      );
    }

    return SECReader(connectionStrategy: strategy);
  }

  /// Prepares (primes) a measurement for the given [payload]
  Future<void> prime(String payload) async {
    await strategy.addQueue(
      UrpSecCommandWrapper(
        deviceCommand: UrpSecDeviceCommand(
          command: UrpSecCommand.urpSecPrime,
          primeParameters: UrpSecPrimeParameters(payload: payload),
        ),
      ).writeToBuffer(),
      super.target,
      super.origin,
    );
  }

  /// Unprime a measurement
  Future<void> unprime() async {
    await strategy.addQueue(
      UrpSecCommandWrapper(
        deviceCommand: UrpSecDeviceCommand(
          command: UrpSecCommand.urpSecUnprime,
        ),
      ).writeToBuffer(),
      super.target,
      super.origin,
    );
  }

  /// Measures until detection. Returns the result if successful.
  /// Triggers an error if failed.
  Future<UrpSecMeasurement> startMeasurement() async {
    final result = await strategy.addQueue(
      UrpSecCommandWrapper(
        deviceCommand: UrpSecDeviceCommand(
          command: UrpSecCommand.urpSecStartMeasurement,
        ),
      ).writeToBuffer(),
      super.target,
      super.origin,
      timeout: const Duration(seconds: 30),
    );

    if (!result.hasPayload()) {
      throw Exception('Failed to measure.');
    }
    return UrpSecMeasurement.fromBuffer(result.payload);
  }

  /// Stop measurement
  Future<void> stopMeasurement() async {
    await strategy.addQueue(
      UrpSecCommandWrapper(
        deviceCommand: UrpSecDeviceCommand(
          command: UrpSecCommand.urpSecStopMeasurement,
        ),
      ).writeToBuffer(),
      super.target,
      super.origin,
    );
  }

  /// Get model info. Returns the result if successful.
  /// Triggers an error if failed.
  Future<UrpSecModelInfo> getModelInfo() async {
    final res = await strategy.addQueue(
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
