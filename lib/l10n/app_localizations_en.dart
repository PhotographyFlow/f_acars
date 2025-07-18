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
  String get yourVaUrl => 'Your VA URL (without\'/\' on end)';

  @override
  String get invalidUrl => 'invalid url';

  @override
  String get delete => 'Delete';

  @override
  String get submit => 'Submit';

  @override
  String get save => 'Save';

  @override
  String get testConnection => 'Test connection';

  @override
  String get test => 'Test';

  @override
  String get testOK => '✓ OK';

  @override
  String get eCheckVA => '✗ ERROR, check your VA URL';

  @override
  String get e401 => '✗ ERROR 401 Unauthorized, check your API key and VA URL';

  @override
  String get e404 => '✗ ERROR 404 Not Found, check your VA URL';

  @override
  String get e400 => '✗ ERROR 400 Validation Errors, contact developer';

  @override
  String get eInternet => '✗ ERROR, check your internet connection and VA URL setting';

  @override
  String get language => 'Language';
}
