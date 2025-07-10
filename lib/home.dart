import 'package:f_acars/l10n/app_localizations.dart';
import 'package:fluent_ui/fluent_ui.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return FluentTheme(
      data: FluentThemeData(
        brightness: Brightness.dark,
        accentColor: Colors.blue,
      ),
      child: ScaffoldPage.scrollable(
        header: PageHeader(title: Text(AppLocalizations.of(context)!.home)),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 20.0,
            children: [
              Expanded(
                child: Column(
                  spacing: 5.0,
                  children: [
                    Text('From'),
                    TextBox(
                      readOnly: true,
                      placeholder: 'From',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 24.0,
                        color: Color(0xFF5178BE),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                spacing: 5.0,
                children: [
                  const Text(''), // empty Text widget to match height
                  Icon(FluentIcons.airplane, size: 20.0),
                ],
              ),
              Expanded(
                child: Column(
                  spacing: 5.0,
                  children: [
                    Text('To'),
                    TextBox(
                      readOnly: true,
                      placeholder: 'To',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 24.0,
                        color: Color(0xFF5178BE),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0),
          Text('Aircraft info'),
          SizedBox(height: 10.0),
          Row(
            children: [
              Expanded(
                child: TextBox(
                  readOnly: true,
                  placeholder: 'Type',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 24.0,
                    color: Color(0xFF5178BE),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              SizedBox(width: 20.0),
              Expanded(
                child: TextBox(
                  readOnly: true,
                  placeholder: 'Icao code',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 24.0,
                    color: Color(0xFF5178BE),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              SizedBox(width: 20.0),
              Expanded(
                child: TextBox(
                  readOnly: true,
                  placeholder: 'Name',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 24.0,
                    color: Color(0xFF5178BE),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              SizedBox(width: 20.0),
              Expanded(
                child: TextBox(
                  readOnly: true,
                  placeholder: 'Registration',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 24.0,
                    color: Color(0xFF5178BE),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              SizedBox(width: 20.0),
              Expanded(
                child: TextBox(
                  readOnly: true,
                  placeholder: 'Block fuel',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 24.0,
                    color: Color(0xFF5178BE),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0),
          Text('Route'),
          SizedBox(height: 10.0),
          SizedBox(
            height: 200.0,
            child: TextBox(maxLines: null, placeholder: 'Route'),
          ),
        ],
      ),
    );
  }
}
