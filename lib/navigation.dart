import 'package:fluent_ui/fluent_ui.dart';
import 'package:f_acars/home.dart';
import 'package:f_acars/settings.dart';
import 'package:f_acars/l10n/app_localizations.dart';

class Navigation extends StatefulWidget {
  final Function(Locale) onLocaleChanged;
  final int buildNumber;
  const Navigation({
    super.key,
    required this.onLocaleChanged,
    required this.buildNumber,
  });
  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int index = 0;
  Locale? _selectedLocale;
  void onLocaleChanged(Locale locale) {
    setState(() {
      _selectedLocale = locale;
    });
    widget.onLocaleChanged(_selectedLocale!);
  }

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      appBar: NavigationAppBar(automaticallyImplyLeading: false),
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
            body: HomePage(buildNumber: widget.buildNumber),
            title: Text(AppLocalizations.of(context)!.home),
          ),
          PaneItem(
            icon: Icon(FluentIcons.settings),
            body: SettingsPage(onLocaleChanged: onLocaleChanged),
            title: Text(AppLocalizations.of(context)!.settings),
          ),
        ],
      ),
    );
  }
}
