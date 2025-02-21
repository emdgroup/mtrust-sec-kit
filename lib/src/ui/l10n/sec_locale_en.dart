import 'sec_locale.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class SecLocalizationsEn extends SecLocalizations {
  SecLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get successfullyVerfied => 'Successfully verified';

  @override
  String get primeFailed => 'Failed to prepare for scan';

  @override
  String get verificationFailed => 'Verification failed';

  @override
  String get verificationFailedMessage => 'Could not detect security pigment.';

  @override
  String get done => 'Done';

  @override
  String get buttonContinue => 'Continue';

  @override
  String get retry => 'Retry';

  @override
  String get connected => 'Connected';

  @override
  String get turnOnPrompt => 'Press the button on the reader to turn it on';

  @override
  String get timeHint => 'Once started you will have 30s to scan';

  @override
  String get readyToScan => 'Ready to scan';

  @override
  String get startScan => 'Start scan';

  @override
  String get distanceHint => 'Approach the surface parallel to the reader at a distance of 8-12mm';

  @override
  String get primingTitle => 'Getting ready to scan...';

  @override
  String get connecting => 'Connecting...';

  @override
  String get disconnecting => 'Disconnecting...';

  @override
  String get searching => 'Searching...';

  @override
  String get scanning => 'Scanning...';

  @override
  String secondsLeft(Object seconds) {
    return '${seconds}s\nleft';
  }

  @override
  String get incompatibleFirmware => 'Firmware incompatible. Please update!';

  @override
  String get tokenFailed => 'Getting new token failed!';

  @override
  String get readingsLeft => 'Readings left with current token:';
}
