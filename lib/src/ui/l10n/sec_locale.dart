import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'sec_locale_de.dart';
import 'sec_locale_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of SecLocalizations
/// returned by `SecLocalizations.of(context)`.
///
/// Applications need to include `SecLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/sec_locale.dart';
///
/// return MaterialApp(
///   localizationsDelegates: SecLocalizations.localizationsDelegates,
///   supportedLocales: SecLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the SecLocalizations.supportedLocales
/// property.
abstract class SecLocalizations {
  SecLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static SecLocalizations of(BuildContext context) {
    return Localizations.of<SecLocalizations>(context, SecLocalizations)!;
  }

  static const LocalizationsDelegate<SecLocalizations> delegate = _SecLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en')
  ];

  /// No description provided for @successfullyVerfied.
  ///
  /// In en, this message translates to:
  /// **'Successfully verified with '**
  String get successfullyVerfied;

  /// No description provided for @primeFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to prepare for scan'**
  String get primeFailed;

  /// No description provided for @verificationFailed.
  ///
  /// In en, this message translates to:
  /// **'Verification failed'**
  String get verificationFailed;

  /// No description provided for @verificationFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Could not detect security pigment.'**
  String get verificationFailedMessage;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @buttonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get buttonContinue;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @connected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// No description provided for @turnOnPrompt.
  ///
  /// In en, this message translates to:
  /// **'Press the button on the reader to turn it on'**
  String get turnOnPrompt;

  /// No description provided for @timeHint.
  ///
  /// In en, this message translates to:
  /// **'Once started you will have 30s to scan'**
  String get timeHint;

  /// No description provided for @readyToScan.
  ///
  /// In en, this message translates to:
  /// **'Ready to scan'**
  String get readyToScan;

  /// No description provided for @startScan.
  ///
  /// In en, this message translates to:
  /// **'Start scan'**
  String get startScan;

  /// No description provided for @distanceHint.
  ///
  /// In en, this message translates to:
  /// **'Approach the surface parallel to the reader at a distance of 8-12mm'**
  String get distanceHint;

  /// No description provided for @primingTitle.
  ///
  /// In en, this message translates to:
  /// **'Getting ready to scan...'**
  String get primingTitle;

  /// No description provided for @connecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting...'**
  String get connecting;

  /// No description provided for @disconnecting.
  ///
  /// In en, this message translates to:
  /// **'Disconnecting...'**
  String get disconnecting;

  /// No description provided for @searching.
  ///
  /// In en, this message translates to:
  /// **'Searching...'**
  String get searching;

  /// No description provided for @scanning.
  ///
  /// In en, this message translates to:
  /// **'Scanning...'**
  String get scanning;

  /// No description provided for @secondsLeft.
  ///
  /// In en, this message translates to:
  /// **'{seconds}s\nleft'**
  String secondsLeft(Object seconds);

  /// No description provided for @incompatibleFirmware.
  ///
  /// In en, this message translates to:
  /// **'Firmware incompatible. Please update!'**
  String get incompatibleFirmware;

  /// No description provided for @tokenFailed.
  ///
  /// In en, this message translates to:
  /// **'Getting new token failed!'**
  String get tokenFailed;

  /// No description provided for @readingsLeft.
  ///
  /// In en, this message translates to:
  /// **'Readings left with current token:'**
  String get readingsLeft;
}

class _SecLocalizationsDelegate extends LocalizationsDelegate<SecLocalizations> {
  const _SecLocalizationsDelegate();

  @override
  Future<SecLocalizations> load(Locale locale) {
    return SynchronousFuture<SecLocalizations>(lookupSecLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_SecLocalizationsDelegate old) => false;
}

SecLocalizations lookupSecLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return SecLocalizationsDe();
    case 'en': return SecLocalizationsEn();
  }

  throw FlutterError(
    'SecLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
