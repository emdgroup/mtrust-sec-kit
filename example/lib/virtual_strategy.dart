import 'package:mtrust_urp_types/sec.pb.dart';
import 'package:mtrust_urp_types/wrapper.pb.dart';
import 'package:mtrust_urp_virtual_strategy/mtrust_urp_virtual_strategy.dart';

final virtualStrategy = UrpVirtualStrategy((UrpRequest request) async {
  final payload = UrpSecCommandWrapper.fromBuffer(request.payload);
  final result = switch (payload.deviceCommand.command) {
    (UrpSecCommand.urpSecPrime) => UrpResponse(),
    (UrpSecCommand.urpSecGetModelInfo) => UrpResponse(
        payload: UrpSecModels(
          models: [
            UrpSecModelInfo(
              modelId: 'Virtual Model',
              version: '0.0.1',
            ),
          ],
        ).writeToBuffer(),
      ),
    (UrpSecCommand.urpSecStartMeasurement) => UrpResponse(
        payload: UrpSecSecureMeasurement(
          measurement: UrpSecMeasurement(
            readerSn: "foo",
            result: [
              UrpSecMeasurementResult(
                modelId: "bar",
              )
            ],
          ),
        ).writeToBuffer(),
      ),
    _ => switch (payload.coreCommand.command) {
        (UrpCommand.urpOff) => UrpResponse(),
        _ => throw Exception("Command not supported"),
      },
  };

  await Future.delayed(const Duration(seconds: 10));

  return result;
});
