import 'package:f_acars/l10n/app_localizations.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/l10n.dart';
import 'settings.dart';
import 'home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int index = 0;
  Locale? _selectedLocale;
  void onLocaleChanged(Locale locale) {
    setState(() {
      _selectedLocale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
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
      ),
      home: NavigationView(
        appBar: NavigationAppBar(),
        pane: NavigationPane(
          size: NavigationPaneSize(openWidth: 200),
          selected: index,
          onChanged: (newIndex) {
            setState(() {
              index = newIndex;
              _selectedLocale = _selectedLocale;
            });
          },
          displayMode: PaneDisplayMode.auto,
          items: [
            PaneItem(
              icon: Icon(FluentIcons.home),
              body: HomePage(),
              title: Text("Home"),
            ),
            PaneItem(
              icon: Icon(FluentIcons.settings),
              body: SettingsPage(onLocaleChanged: onLocaleChanged),
              title: Text("Settings"),
            ),
          ],
        ),
      ),
    );
  }
}
