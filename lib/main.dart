import 'package:f_acars/l10n/app_localizations.dart';
import 'package:f_acars/navigation.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'l10n/l10n.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Window.initialize();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int index = 0;
  Locale? _selectedLocale;
  final apiKeyController = TextEditingController();
  final _storage = FlutterSecureStorage();
  void onLocaleChanged(Locale locale) {
    setState(() {
      _selectedLocale = locale;
    });
  }

  WindowEffect effect = WindowEffect.transparent;

  @override
  void initState() {
    super.initState();
    _loadLang();
    // Load settings on launch
  }

  Future<void> _loadLang() async {
    final settings = await _storage.read(key: 'settings');
    if (settings != null) {
      final jsonSettings = jsonDecode(settings);
      final localeCode = jsonSettings['locale'];
      if (localeCode != null) {
        _selectedLocale = Locale(localeCode);
        onLocaleChanged(_selectedLocale!);
      }
    }
  }

  void setEffect(WindowEffect effect, BuildContext context) {
    Window.setEffect(effect: effect, color: Colors.transparent, dark: true);
  }

  @override
  Widget build(BuildContext context) {
    setEffect(WindowEffect.mica, context);
    return FluentApp(
      locale: _selectedLocale,
      localizationsDelegates: [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        AppLocalizations.delegate,
      ],
      supportedLocales: L10n.all,
      title: 'F-ACARS',
      theme: FluentThemeData(
        brightness: Brightness.dark,
        accentColor: Colors.blue,
        navigationPaneTheme: NavigationPaneThemeData(
          backgroundColor: Colors.transparent,
        ),
      ),
      home: Navigation(onLocaleChanged: onLocaleChanged),
    );
  }
}

class SetEffect {
  static void setEffect(WindowEffect effect, BuildContext context) {
    Window.setEffect(effect: effect, color: Colors.transparent, dark: true);
  }
}
