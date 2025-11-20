import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mtrust_sec_kit/mtrust_sec_kit.dart';

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
  })  : target = target ??
            UrpDeviceIdentifier(
              deviceClass: UrpDeviceClass.urpReader,
              deviceType: UrpDeviceType.urpSec,
            ),
        origin = origin ??
            UrpDeviceIdentifier(
              deviceClass: UrpDeviceClass.urpHost,
              deviceType: (kIsWeb || Platform.isAndroid || Platform.isIOS)
                  ? UrpDeviceType.urpMobile
                  : UrpDeviceType.urpDesktop,
            );

  /// The connectionStrategy used to connect the device.
  final ConnectionStrategy connectionStrategy;

  /// The target device.
  final UrpDeviceIdentifier target;

  /// The origin device.
  final UrpDeviceIdentifier origin;

  int _requestTokenAmount = 10;

  /// Sets the amount of tokens to be requested if the device has no more
  /// tokens available. The default is 10.
  void setTokenAmount(int amount) {
    _requestTokenAmount = amount;
    notifyListeners();
  }

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
  static Stream<FoundDevice> findReaders(
    ConnectionStrategy connectionStrategy,
  ) {
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

  @override
  Future<UrpResponse> addCoreCmdToQueue(
    UrpCoreCommand coreCommand,
  ) async {
    return connectionStrategy.addQueue(
      UrpSecCommandWrapper(
        coreCommand: coreCommand,
      ).writeToBuffer(),
      target,
      origin,
    );
  }

  Future<UrpResponse> _addDeviceCmdToQueue({
    UrpSecDeviceCommand? deviceCommand,
  }) async {
    return connectionStrategy.addQueue(
      UrpSecCommandWrapper(
        deviceCommand: deviceCommand,
      ).writeToBuffer(),
      target,
      origin,
    );
  }

  /// Prepares (primes) a measurement for the given [payload].
  Future<UrpSecPrimeResponse?> prime(String payload) async {
    final cmd = UrpSecDeviceCommand(
      command: UrpSecCommand.urpSecPrime,
      primeParameters: UrpSecPrimeParameters(payload: payload),
    );
    try {
      final res = await _addDeviceCmdToQueue(deviceCommand: cmd);
      return UrpSecPrimeResponse.fromBuffer(res.payload);
    } catch (e) {
      if (e is DeviceError) {
        if (e.errorCode.value != 4) {
          // urpLeaseError
          rethrow;
        }
        final publicKey = await getPublicKey();
        final oldToken = await requestToken();

        UrpSecureToken? newToken;

        try {
          newToken = await getToken(oldToken, publicKey);
        } catch (e) {
          throw SecReaderException(
            message: 'Failed to get new token!',
            type: SecReaderExceptionType.tokenFailed,
          );
        }

        await setToken(newToken);
        return prime(payload);
      }
      return null;
    }
  }

  /// Request the device to send a new token request
  Future<UrpSecureToken> requestToken() async {
    final cmd = UrpSecDeviceCommand(
      command: UrpSecCommand.urpSecRequestToken,
      tokenRequest: UrpTokenRequest(
        amount: _requestTokenAmount,
      ),
    );
    final res = await _addDeviceCmdToQueue(
      deviceCommand: cmd,
    );

    if (!res.hasPayload()) {
      throw SecReaderException(
        message: 'Failed to request token!',
        type: SecReaderExceptionType.tokenFailed,
      );
    }
    return UrpSecureToken.fromBuffer(res.payload);
  }

  /// Install a new token after a token request on the device
  Future<void> setToken(UrpSecureToken token) async {
    final cmd = UrpSecDeviceCommand(
      command: UrpSecCommand.urpSecSetToken,
      secureToken: token,
    );
    await _addDeviceCmdToQueue(deviceCommand: cmd);
  }

  /// Request the currently installed token from the device
  Future<UrpSecureToken> getCurrentToken() async {
    final cmd = UrpSecDeviceCommand(
      command: UrpSecCommand.urpSecGetToken,
    );
    final res = await _addDeviceCmdToQueue(
      deviceCommand: cmd,
    );

    if (!res.hasPayload()) {
      throw SecReaderException(
        message: 'Failed to get current token!',
        type: SecReaderExceptionType.tokenFailed,
      );
    }
    return UrpSecureToken.fromBuffer(res.payload);
  }

  /// Unprime a measurement.
  Future<void> unprime() async {
    final cmd = UrpSecDeviceCommand(
      command: UrpSecCommand.urpSecUnprime,
    );
    await _addDeviceCmdToQueue(deviceCommand: cmd);
  }

  /// Measures until detection. Returns the result if successful.
  /// Triggers an error if failed.
  Future<UrpSecSecureMeasurement> startMeasurement() async {
    final cmd = UrpSecDeviceCommand(
      command: UrpSecCommand.urpSecStartMeasurement,
    );
    final res = await _addDeviceCmdToQueue(deviceCommand: cmd);

    return UrpSecSecureMeasurement.fromBuffer(res.payload);
  }

  /// Stop measurement
  Future<void> stopMeasurement() async {
    final cmd = UrpSecDeviceCommand(
      command: UrpSecCommand.urpSecStopMeasurement,
    );
    final res = await _addDeviceCmdToQueue(deviceCommand: cmd);
    print(res);
  }

  /// Get model info. Returns the result if successful.
  /// Triggers an error if failed.
  Future<List<UrpSecModelInfo>> getModelInfo() async {
    final cmd = UrpSecDeviceCommand(
      command: UrpSecCommand.urpSecGetModelInfo,
    );
    final res = await _addDeviceCmdToQueue(deviceCommand: cmd);

    if (!res.hasPayload()) {
      throw Exception('Failed to get model info');
    }
    final urpSecModels = UrpSecModels.fromBuffer(res.payload);
    return urpSecModels.models;
  }
}
