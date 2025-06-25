// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get helloWorld => 'Hello World!';

  @override
  String get home => 'Home';

  @override
  String get settings => 'Settings';

  @override
  String get yourApiKey => 'Your api key (don\'t share this!)';

  @override
  String get apiKeyWrong => 'Ensure enter the right api key.';

  @override
  String get deleteApiKey => 'Delete API Key';

  @override
  String get submit => 'Submit';

  @override
  String get language => 'Language';
}
