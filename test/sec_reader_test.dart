// ignore_for_file: lines_longer_than_80_chars
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:mtrust_urp_core/mtrust_urp_core.dart';
import 'package:mtrust_urp_types/sec.pb.dart';

void main() {
  group(
    'Testing correct generation of byte array for device commands', 
    () {

      UrpMessage getUrpMessage(UrpSecDeviceCommand cmd) {
        return UrpMessage(
          header: UrpMessageHeader(
            seqNr: 1,
            target: UrpDeviceIdentifier(
              deviceClass: UrpDeviceClass.urpReader,
              deviceType: UrpDeviceType.urpSec,
            ),
            origin: UrpDeviceIdentifier(
              deviceClass: UrpDeviceClass.urpHost,
              deviceType: UrpDeviceType.urpMobile,
            ),
          ),
          request: UrpRequest(
            payload: UrpSecCommandWrapper(
              deviceCommand: cmd,
            ).writeToBuffer(),
          ),
        );
      }

      Uint8List int16ToBytes(int value) {
        if (value < -32768 || value > 32767) {
          throw ArgumentError('Value must be between -32768 and 32767.');
        }

        final bytes = Uint8List(2);

        // Store the two bytes in little-endian order
        bytes[0] = (value >> 8) & 0xFF; // Upper byte
        bytes[1] = value & 0xFF; // Lower byte

        return bytes;
      }

      test('Prime command', () {
        final cmd = UrpSecDeviceCommand(
          command: UrpSecCommand.urpSecPrime,
        );
        final message = getUrpMessage(cmd);
        final bytes = message.writeToBuffer();
        final length = int16ToBytes(bytes.length);
        final messageBytes = length + bytes;
        final hexString = messageBytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(' ');
        const expected = '00 18 0a 0e 08 01 22 04 08 02 10 04 2a 04 08 00 10 01 12 06 0a 04 12 02 08 00';
        expect(hexString, equals(expected));
      });

      test('Unprime command', () {
        final cmd = UrpSecDeviceCommand(
          command: UrpSecCommand.urpSecUnprime,
        );
        final message = getUrpMessage(cmd);
        final bytes = message.writeToBuffer();
        final length = int16ToBytes(bytes.length);
        final messageBytes = length + bytes;
        final hexString = messageBytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(' ');
        const expected = '00 18 0a 0e 08 01 22 04 08 02 10 04 2a 04 08 00 10 01 12 06 0a 04 12 02 08 01';
        expect(hexString, equals(expected));
      });

      test('Start measurement command', () {
        final cmd = UrpSecDeviceCommand(
          command: UrpSecCommand.urpSecStartMeasurement,
        );
        final message = getUrpMessage(cmd);
        final bytes = message.writeToBuffer();
        final length = int16ToBytes(bytes.length);
        final messageBytes = length + bytes;
        final hexString = messageBytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(' ');
        const expected = '00 18 0a 0e 08 01 22 04 08 02 10 04 2a 04 08 00 10 01 12 06 0a 04 12 02 08 02';
        expect(hexString, equals(expected));
      });

      test('Stop measurement command', () {
        final cmd = UrpSecDeviceCommand(
          command: UrpSecCommand.urpSecStopMeasurement,
        );
        final message = getUrpMessage(cmd);
        final bytes = message.writeToBuffer();
        final length = int16ToBytes(bytes.length);
        final messageBytes = length + bytes;
        final hexString = messageBytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(' ');
        const expected = '00 18 0a 0e 08 01 22 04 08 02 10 04 2a 04 08 00 10 01 12 06 0a 04 12 02 08 03';
        expect(hexString, equals(expected));
      });

      test('Get model info command', () {
        final cmd = UrpSecDeviceCommand(
          command: UrpSecCommand.urpSecGetModelInfo,
        );
        final message = getUrpMessage(cmd);
        final bytes = message.writeToBuffer();
        final length = int16ToBytes(bytes.length);
        final messageBytes = length + bytes;
        final hexString = messageBytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(' ');
        const expected = '00 18 0a 0e 08 01 22 04 08 02 10 04 2a 04 08 00 10 01 12 06 0a 04 12 02 08 04';
        expect(hexString, equals(expected));
      });
    },
  );
}
