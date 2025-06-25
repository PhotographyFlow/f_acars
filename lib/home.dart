import 'package:f_acars/l10n/app_localizations.dart';
import 'package:fluent_ui/fluent_ui.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    /*    FluentThemeData(brightness: Brightness.dark, accentColor: Colors.blue);

    return ScaffoldPage.scrollable(
      header: const PageHeader(title: Text('Home')),
      children: /*[Text(AppLocalizations.of(context)!.helloWorld)],*/ [
        StatefulBuilder(
          builder: (context, setState) {
            return Text(AppLocalizations.of(context)!.helloWorld);
          },
        ),
      ],
    );
  }
}
*/
    return FluentTheme(
      data: FluentThemeData(
        brightness: Brightness.dark,
        accentColor: Colors.blue,
      ),
      child: ScaffoldPage.scrollable(
        header: const PageHeader(title: Text('Home')),
        children: [
          Builder(
            builder: (context) {
              return Text(AppLocalizations.of(context)!.helloWorld);
            },
          ),
        ],
      ),
    );
  }
}
