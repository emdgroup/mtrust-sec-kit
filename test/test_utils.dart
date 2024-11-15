import 'dart:async';

import 'package:mtrust_urp_core/mtrust_urp_core.dart';
import 'package:mtrust_urp_types/sec.pb.dart';
import 'package:mtrust_urp_ui/src/storage_adapter.dart';
import 'package:mtrust_urp_virtual_strategy/mtrust_urp_virtual_strategy.dart';

final reader1 = FoundDevice(
  name: 'SEC-000123',
  type: UrpDeviceType.urpSec,
  address: '00:00:00:00:00:00',
);

final reader2 = FoundDevice(
  name: 'SEC-000124',
  type: UrpDeviceType.urpSec,
  address: '00:00:00:00:00:01',
);

final reader3 = FoundDevice(
  name: 'SEC-000125',
  type: UrpDeviceType.urpSec,
  address: '00:00:00:00:00:02',
);

class CompleterStrategy {
  CompleterStrategy({bool withReaders = false}) {
    strategy = UrpVirtualStrategy((UrpRequest request) async {
      final payload = UrpSecCommandWrapper.fromBuffer(request.payload);
      switch (payload.deviceCommand.command) {
        case (UrpSecCommand.urpSecPrime):
          primeCompleter = Completer<void>();
          await primeCompleter.future;

          return UrpResponse();

        case UrpSecCommand.urpSecStartMeasurement:
          startMeasurementCompleter = Completer<void>();
          try {
            await startMeasurementCompleter.future;
          } catch (e) {
            return null;
          }

          return UrpResponse(
            payload: UrpSecMeasurementResult(
              modelId: '123',
              scoreDistance: 0.5,
              orthogonalDistance: 0.6,
            ).writeToBuffer(),
          );
        // ignore: no_default_cases
        default:
          return UrpResponse();
      }
    })
      ..simulateDelays = false;

    if (withReaders) {
      strategy
        ..createVirtualReader(reader1)
        ..createVirtualReader(reader2)
        ..createVirtualReader(reader3)
        ..createVirtualReader(
          FoundDevice(
            name: 'IMP-000123',
            type: UrpDeviceType.urpImp,
            address: '00:00:00:00:00:01',
          ),
        );
    }
  }
  Completer<void> primeCompleter = Completer<void>();
  Completer<void> startMeasurementCompleter = Completer<void>();
  late UrpVirtualStrategy strategy;
}

class MockStorageAdapter extends StorageAdapter {
  MockStorageAdapter() : super('mock_storage_adapter');

  @override
  Future<void> clearPairedReader() {
    return Future.value();
  }

  @override
  Future<void> clearPersistedReader() async {}

  @override
  Future<FoundDevice?> getLastConnectedReader() async {
    return reader2;
  }

  @override
  Future<FoundDevice?> getPairedReader() {
    return Future.value(reader2);
  }

  @override
  Future<void> persistLastConnectedReader(FoundDevice reader) async {}

  @override
  Future<void> persistPairedReader(FoundDevice reader) async {
    return Future.value();
  }
}
