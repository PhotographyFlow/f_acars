import 'package:flutter/foundation.dart';
import 'package:f_acars/l10n/app_localizations.dart';
import 'package:fluent_ui/fluent_ui.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> fares = [
    /*
    {
      "id": 1,
      "code": "Y",
      "name": "Economy",
      "capacity": 180,
      "cost": null,
      "count": null,
      "price": 100,
      "type": 0,
      "notes": null,
      "active": true,
    },

    {
      "id": 2,
      "code": "Cargo",
      "name": "Cargo",
      "capacity": 9440,
      "cost": null,
      "count": null,
      "price": 15,
      "type": 1,
      "notes": null,
      "active": true,
    },
    */
  ];

  @override
  Widget build(BuildContext context) {
    return FluentTheme(
      data: FluentThemeData(
        brightness: Brightness.dark,
        accentColor: Colors.blue,
      ),
      child: ScaffoldPage.scrollable(
        header: PageHeader(title: Text(AppLocalizations.of(context)!.home)),
        /*
        bottomBar: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Button(
                  child: Row(
                    children: [
                      Text('Refresh'),
                      SizedBox(width: 5),
                      Icon(FluentIcons.refresh),
                    ],
                  ),
                  onPressed: () {},
                ),
                SizedBox(width: 10),
                Button(
                  child: Row(
                    children: [
                      Text('Start flight'),
                      SizedBox(width: 5),
                      Icon(FluentIcons.chevron_right),
                    ],
                  ),
                  onPressed: () {},
                ),
                SizedBox(width: 20),
              ],
            ),
            SizedBox(height: 30),
          ],
        ),*/
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
                    Text('Airline'),
                    TextBox(
                      readOnly: true,
                      placeholder: 'Airline Icao',
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
              Expanded(
                child: Column(
                  spacing: 5.0,
                  children: [
                    Text('Flight number'),
                    TextBox(
                      readOnly: true,
                      placeholder: 'Flight number',
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
          //fares
          SizedBox(height: 20.0),

          /*
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: fares.isNotEmpty
                ? fares
                      .asMap()
                      .entries
                      .map(
                        (entry) => [
                          Expanded(
                            child: TextBox(
                              readOnly: true,
                              placeholder: entry.value['name'],
                              style: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: 24.0,
                                color: Color(0xFF5178BE),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                          entry.key < fares.length - 1
                              ? SizedBox(width: 20)
                              : Container(), // spacer
                        ],
                      )
                      .toList()
                      .expand((element) => element)
                      .toList()
                : [
                    Expanded(
                      child: TextBox(
                        maxLines: 2,
                        readOnly: true,
                        placeholder: 'No fares available',
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
          */
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: fares.isNotEmpty
                    ? fares
                          .asMap()
                          .entries
                          .map(
                            (entry) => [
                              Expanded(
                                child: TextBox(
                                  readOnly: true,
                                  placeholder: entry.value['name'],
                                  style: TextStyle(
                                    fontFamily: 'Arial',
                                    fontSize: 24.0,
                                    color: Color(0xFF5178BE),
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                              entry.key < fares.length - 1
                                  ? SizedBox(width: 20)
                                  : Container(), // spacer
                            ],
                          )
                          .toList()
                          .expand((element) => element)
                          .toList()
                    : [
                        Expanded(
                          child: TextBox(
                            maxLines: 2,
                            readOnly: true,
                            placeholder: 'No fares available',
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: fares.isNotEmpty
                    ? fares
                          .asMap()
                          .entries
                          .map(
                            (entry) => [
                              Expanded(
                                child: NumberBox(
                                  mode: SpinButtonPlacementMode.inline,
                                  min: 0,
                                  max: entry.value['capacity'],
                                  value: 0,
                                  onChanged: (value) {
                                    // Handle the changed value
                                    if (kDebugMode) {
                                      print('Changed value: $value');
                                    }
                                  },
                                ),
                              ),
                              entry.key < fares.length - 1
                                  ? SizedBox(width: 20)
                                  : Container(), // spacer
                            ],
                          )
                          .toList()
                          .expand((element) => element)
                          .toList()
                    : [
                        Expanded(
                          child: Container(), // spacer
                        ),
                      ],
              ),
            ],
          ),
          SizedBox(height: 20.0),
          //route
          Text('Route'),
          SizedBox(height: 10.0),
          SizedBox(
            height: 200.0,
            child: TextBox(maxLines: null, placeholder: 'Route'),
          ),
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Button(
                child: Row(
                  children: [
                    Text('Refresh'),
                    SizedBox(width: 7),
                    Icon(FluentIcons.refresh),
                  ],
                ),
                onPressed: () {},
              ),
              SizedBox(width: 10),
              Button(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.green),
                ),
                child: Row(
                  children: [
                    Text('Start flight'),
                    SizedBox(width: 5),
                    Icon(FluentIcons.chevron_right),
                  ],
                ),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
