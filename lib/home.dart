import 'package:f_acars/web_comm.dart';
import 'package:flutter/foundation.dart';
import 'package:f_acars/l10n/app_localizations.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> fares = [
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

    //these are for test only
    */
  ];

  Timer? _timer;
  AnimationController? _animationController;
  Future? _testFuture;

  final _storage = const FlutterSecureStorage();

  final apiKeyController = TextEditingController();
  final vaUrlController = TextEditingController();
  String? airlineIcao;
  String? flightNumber;
  String? depAirport;
  String? arrAirport;
  String? aircraftType;
  String? aircraftIcao;
  String? aircraftName;
  String? aircraftReg;

  @override
  void initState() {
    super.initState();
    vaUrlController.text = '';
    _loadSettings();
    vaUrlController.addListener(() {
      vaUrlController.text;
    });
    apiKeyController.addListener(() {
      apiKeyController.text;
    });

    _timer?.cancel();
    _animationController?.removeListener(() {});
    _animationController?.dispose();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController?.removeListener(() {});
    _animationController?.dispose();
    _testFuture?.then((_) => null).catchError((_) => null);
    super.dispose();
  }

  Future<void> _loadBids() async {
    WebComm webComm = WebComm();
    webComm.getBids(vaUrlController.text, apiKeyController.text, context).then((
      result,
    ) async {
      if (kDebugMode) {
        print('Result: $result');
      }
      if (result.isEmpty) {
        await displayInfoBar(
          context,
          builder: (context, close) {
            return InfoBar(
              title: const Text('No bids found :('),
              content: const Text(
                'Looks like you don\'t have any yet. Add one bid at your VA website and try again.',
              ),
              action: IconButton(
                icon: const Icon(FluentIcons.clear),
                onPressed: close,
              ),
              severity: InfoBarSeverity.warning,
            );
          },
        );
      } else {
        if (mounted) {
          setState(() {
            airlineIcao = result[0]['flight']['callsign'];
            flightNumber = result[0]['flight']['flight_number'].toString();
            depAirport = result[0]['flight']['dpt_airport_id'];
            arrAirport = result[0]['flight']['arr_airport_id'];
            aircraftType = result[0]['flight']['subfleets'][0]['type'];
            aircraftIcao =
                result[0]['flight']['subfleets'][0]['aircraft'][0]['icao'];
            aircraftName = result[0]['flight']['subfleets'][0]['name'];
            aircraftReg =
                result[0]['flight']['subfleets'][0]['aircraft'][0]['registration'];
            fares = result[0]['flight']['subfleets'][0]['fares'];
          });
        }
      }
    });
  }

  Future<void> _clearBids() async {
    setState(() {
      airlineIcao = null;
      flightNumber = null;
      depAirport = null;
      arrAirport = null;
      aircraftType = null;
      aircraftIcao = null;
      aircraftName = null;
      aircraftReg = null;
      fares = [];
    });
  }

  Future<void> _loadSettings() async {
    final settings = await _storage.read(key: 'settings');
    if (settings != null) {
      final jsonSettings = jsonDecode(settings);
      vaUrlController.text = jsonSettings['vaUrl'] ?? '';
      apiKeyController.text = jsonSettings['apiKey'] ?? '';
      if (kDebugMode) {
        print(vaUrlController.text);
        print(apiKeyController.text);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FluentTheme(
      data: FluentThemeData(
        brightness: Brightness.dark,
        accentColor: Colors.blue,
      ),
      child: ScaffoldPage.scrollable(
        header: PageHeader(
          title: Text(
            AppLocalizations.of(context)!.home,
            style: FluentTheme.of(context).typography.title,
          ),
        ),
        bottomBar: Column(
          children: [
            SizedBox(height: 15),
            Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [
                Button(
                  onPressed: _clearBids,
                  child: Row(
                    children: [
                      Text('Clear'),
                      SizedBox(width: 7),
                      Icon(FluentIcons.clear),
                    ],
                  ),
                ),

                Button(
                  onPressed: _loadBids,
                  child: Row(
                    children: [
                      Text('Refresh'),
                      SizedBox(width: 7),
                      Icon(FluentIcons.refresh),
                    ],
                  ),
                ),

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
                SizedBox(width: 10),
              ],
            ),
            SizedBox(height: 15),
          ],
        ),
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
                      enabled: false,
                      readOnly: true,
                      style: TextStyle(fontSize: 24.0),
                      placeholder: airlineIcao,
                      placeholderStyle: TextStyle(
                        color: Colors.grey[100],
                        fontSize: 24.0,
                      ),
                      textAlign: TextAlign.center,
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
                      enabled: false,
                      readOnly: true,
                      style: TextStyle(fontSize: 24.0),
                      placeholder: flightNumber,
                      placeholderStyle: TextStyle(
                        color: Colors.grey[100],
                        fontSize: 24.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  spacing: 5.0,
                  children: [
                    Text('DEP'),
                    TextBox(
                      enabled: false,
                      readOnly: true,
                      style: TextStyle(fontSize: 24.0),
                      placeholder: depAirport,
                      placeholderStyle: TextStyle(
                        color: Colors.grey[100],
                        fontSize: 24.0,
                      ),
                      textAlign: TextAlign.center,
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
                    Text('ARR'),
                    TextBox(
                      enabled: false,
                      readOnly: true,
                      style: TextStyle(fontSize: 24.0),
                      placeholder: arrAirport,
                      placeholderStyle: TextStyle(
                        color: Colors.grey[100],
                        fontSize: 24.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0),
          Row(
            spacing: 20.0,
            children: [
              Expanded(
                child: Column(
                  spacing: 5.0,
                  children: [
                    Text('Aircraft type'),
                    TextBox(
                      enabled: false,
                      readOnly: true,
                      style: TextStyle(fontSize: 24.0),
                      placeholder: aircraftType,
                      placeholderStyle: TextStyle(
                        color: Colors.grey[100],
                        fontSize: 24.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Column(
                  spacing: 5.0,
                  children: [
                    Text('Aircraft icao code'),
                    TextBox(
                      enabled: false,
                      readOnly: true,
                      style: TextStyle(fontSize: 24.0),
                      placeholder: aircraftIcao,
                      placeholderStyle: TextStyle(
                        color: Colors.grey[100],
                        fontSize: 24.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Column(
                  spacing: 5.0,
                  children: [
                    Text('Name'),
                    TextBox(
                      enabled: false,
                      readOnly: true,
                      style: TextStyle(fontSize: 24.0),
                      placeholder: aircraftName,
                      placeholderStyle: TextStyle(
                        color: Colors.grey[100],
                        fontSize: 24.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Column(
                  spacing: 5.0,
                  children: [
                    Text('Registration'),
                    TextBox(
                      enabled: false,
                      readOnly: true,
                      style: TextStyle(fontSize: 24.0),
                      placeholder: aircraftReg,
                      placeholderStyle: TextStyle(
                        color: Colors.grey[100],
                        fontSize: 24.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Column(
                  spacing: 5.0,
                  children: [
                    Text('Block fuel'),
                    TextBox(
                      style: TextStyle(fontSize: 24.0),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
          //fares
          SizedBox(height: 20.0),

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
                                child: Column(
                                  spacing: 5.0,
                                  children: [
                                    TextBox(
                                      enabled: false,
                                      readOnly: true,
                                      placeholder: entry.value['name'],
                                      placeholderStyle: TextStyle(
                                        color: Colors.grey[100],
                                        fontSize: 24.0,
                                      ),
                                      style: TextStyle(fontSize: 24.0),
                                    ),
                                  ],
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
                            enabled: false,
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
                                child: NumberFormBox(
                                  mode: SpinButtonPlacementMode.inline,
                                  clearButton: false,
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
        ],
      ),
    );
  }
}
