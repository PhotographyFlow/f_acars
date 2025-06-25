import 'package:f_acars/l10n/app_localizations.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'l10n/locale_names.dart';
import 'dart:convert';

class SettingsPage extends StatefulWidget {
  final Function(Locale) onLocaleChanged;

  const SettingsPage({super.key, required this.onLocaleChanged});

  @override
  State<SettingsPage> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  final apiKeyController = TextEditingController();
  String? validationError = '';
  final _storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _selectedLocale = Locale('en');
    _loadSettings();
    apiKeyController.addListener(() {
      _validateApiKey(apiKeyController.text);
    });
  }

  Future<void> _loadSettings() async {
    final settings = await _storage.read(key: 'settings');
    if (settings != null) {
      final jsonSettings = jsonDecode(settings);
      apiKeyController.text = jsonSettings['apiKey'];
      final localeCode = jsonSettings['locale'];
      if (localeCode != null) {
        _selectedLocale = Locale(localeCode);
        _changeLocale(_selectedLocale);
      }
    }
  }

  Future<void> _saveSettings() async {
    final settings = {
      'apiKey': apiKeyController.text,
      'locale': _selectedLocale?.languageCode,
      // Add more settings as needed, for example:
      // 'locale': localeController.text,
      // 'theme': themeController.text,
    };
    await _storage.write(key: 'settings', value: jsonEncode(settings));
  }

  void _validateApiKey(String text) {
    if (text.length != 20) {
      setState(
        () => validationError = AppLocalizations.of(context)!.apiKeyWrong,
      );
    } else {
      setState(() => validationError = null);
    }
  }

  Locale? _selectedLocale;

  void _changeLocale(Locale? locale) {
    if (locale != null) {
      widget.onLocaleChanged.call(locale);
    }
  }

  //Settings page
  @override
  Widget build(BuildContext context) {
    FluentThemeData(brightness: Brightness.dark, accentColor: Colors.blue);

    return ScaffoldPage.scrollable(
      header: PageHeader(title: Text(AppLocalizations.of(context)!.settings)),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.yourApiKey),
            SizedBox(height: 10),
            PasswordFormBox(
              controller: apiKeyController,
              revealMode: PasswordRevealMode.peekAlways,
              autovalidateMode: AutovalidateMode.always,
              validator: (text) => validationError,
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Button(
                  onPressed: validationError == null
                      ? () {
                          _saveSettings();
                        }
                      : null,
                  child: Text(AppLocalizations.of(context)!.deleteApiKey),
                ),
                SizedBox(width: 10),
                Button(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.red),
                  ),
                  onPressed: () async {
                    await _storage.delete(key: 'apiKey');
                    apiKeyController.clear();
                    await _saveSettings();
                    setState(() {
                      validationError = '';
                    });
                  },
                  child: Text(AppLocalizations.of(context)!.deleteApiKey),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(AppLocalizations.of(context)!.language),
            SizedBox(height: 10),
            ComboBox(
              value: _selectedLocale,
              onChanged: (Locale? locale) {
                setState(() {
                  _selectedLocale = locale;
                  _changeLocale(locale!);
                  _saveSettings();
                });
              },
              items: AppLocalizations.supportedLocales
                  .map(
                    (locale) => ComboBoxItem(
                      value: locale,
                      child: Text(LocaleNames.names[locale.languageCode]!),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ],
    );
  }
}
