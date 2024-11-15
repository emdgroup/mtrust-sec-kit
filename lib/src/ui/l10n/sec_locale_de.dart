import 'sec_locale.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class SecLocalizationsDe extends SecLocalizations {
  SecLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get successfullyVerfied => 'Verifizierung erfolgreich';

  @override
  String get primeFailed => 'Failed to prepare for scan';

  @override
  String get verificationFailed => 'Verifizierung fehlgeschlagen';

  @override
  String get verificationFailedMessage => 'Sicherheitspigment nicht erkannt.';

  @override
  String get done => 'Fertig';

  @override
  String get buttonContinue => 'Weiter';

  @override
  String get retry => 'Wiederholen';

  @override
  String get connected => 'Verbunden';

  @override
  String get turnOnPrompt => 'Zum Einschalten Taste drücken';

  @override
  String get timeHint => 'Sobald der Vorgang gestartet wurde, haben Sie 30 Sekunden Zeit zum Scannen';

  @override
  String get readyToScan => 'Bereit zum Scannen';

  @override
  String get startScan => 'Scan starten';

  @override
  String get distanceHint => 'Approach the surface parallel to the reader at a distance of 8-12mm';

  @override
  String get primingTitle => 'Scannen vorbereiten...';

  @override
  String get connecting => 'Verbinden...';

  @override
  String get disconnecting => 'Disconnecting...';

  @override
  String get searching => 'Suchen...';

  @override
  String get scanning => 'Scannen...';

  @override
  String secondsLeft(Object seconds) {
    return '${seconds}s\nverbleibend';
  }
}
