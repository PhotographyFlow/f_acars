import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:f_acars/flight_sim_comm.dart';
import 'package:f_acars/web_comm.dart';
import 'dart:async';
import 'dart:io';

class FlightData {
  int airspeed;
  int groundSpeed;
  int altCalibrated;
  int radioAltitude;
  double gpsLat;
  double gpsLon;
  int totalFuel;
  int trueHeading;
  int zuluYear;
  int zuluMonth;
  int zuluDay;
  int zuluHour;
  int zuluMinute;
  int zuluSecond;
  bool isOnGround;
  bool isEngOn;
  int landingVS;
  double landingG;
  String flightStatus;

  FlightData({
    required this.airspeed,
    required this.groundSpeed,
    required this.altCalibrated,
    required this.radioAltitude,
    required this.gpsLat,
    required this.gpsLon,
    required this.totalFuel,
    required this.trueHeading,
    required this.zuluYear,
    required this.zuluMonth,
    required this.zuluDay,
    required this.zuluHour,
    required this.zuluMinute,
    required this.zuluSecond,
    required this.isOnGround,
    required this.isEngOn,
    required this.landingVS,
    required this.landingG,
    required this.flightStatus,
  });
}

class FlightDataDisplay extends StatefulWidget {
  final String vaUrl;
  final String apiKey;
  final String pirepID;
  final int connectionType;
  static int webUploadDelay = 1;

  const FlightDataDisplay({
    super.key,
    required this.vaUrl,
    required this.apiKey,
    required this.pirepID,
    required this.connectionType,
  });

  @override
  FlightDataDisplayState createState() => FlightDataDisplayState();
}

class FlightDataDisplayState extends State<FlightDataDisplay> {
  static bool statusAutoUpdate = true;
  bool _isFetchingData = false;
  Timer? _timer;
  final ValueNotifier<FlightData> _flightDataNotifier = ValueNotifier(
    FlightData(
      airspeed: 0,
      groundSpeed: 0,
      altCalibrated: 0,
      radioAltitude: 0,
      gpsLat: 0.0,
      gpsLon: 0.0,
      totalFuel: 0,
      trueHeading: 0,
      zuluYear: 0,
      zuluMonth: 0,
      zuluDay: 0,
      zuluHour: 0,
      zuluMinute: 0,
      zuluSecond: 0,
      isOnGround: false,
      isEngOn: false,
      landingVS: 0,
      landingG: 0.0,
      flightStatus: '',
    ),
  );
  FlightStatus selectedValue = FlightStatus.INI;

  @override
  void initState() {
    super.initState();
    statusAutoUpdate = true;
    startTimer();
  }

  @override
  void dispose() {
    stopConnector();
    _timer?.cancel();
    super.dispose();
  }

  bool startConnector() {
    late String command;
    if (widget.connectionType == 0) {
      command = 'UIPCDemo64.exe';
    }
    if (widget.connectionType == 1) {
      command = 'UIPCDemo32.exe';
    }
    try {
      Process.run(command, [])
          .then((process) {
            if (kDebugMode) {
              print('Command executed successfully');
            }
          })
          .catchError((error) {
            if (kDebugMode) {
              print('Error executing command: $error');
            }
          });
      return true;
    } catch (_) {
      return false;
    }
  }

  bool stopConnector() {
    late String command;
    if (widget.connectionType == 0) {
      command = 'taskkill /F /IM UIPCDemo64.exe';
    }
    if (widget.connectionType == 1) {
      command = 'taskkill /F /IM UIPCDemo32.exe';
    }
    try {
      Process.run('cmd', ['/c', command])
          .then((process) {
            if (kDebugMode) {
              print('Command executed successfully');
              print(process.stdout);
              print(process.stderr);
            }
          })
          .catchError((error) {
            if (kDebugMode) {
              print('Error executing command: $error');
            }
          });
      return true;
    } catch (_) {
      return false;
    }
  }

  static void resetWebUploadDelay() {
    /*Read data from game every 3 sec, so if you want to upload data to web, for example,every 5 min = 5*60/3 = 100 */
    if (FlightStatusUpdate.currentStatus == FlightStatus.INI) {
      FlightDataDisplay.webUploadDelay = 200;
    }
    if (FlightStatusUpdate.currentStatus == FlightStatus.BST) {
      FlightDataDisplay.webUploadDelay = 100;
    }
    if (FlightStatusUpdate.currentStatus == FlightStatus.TXI) {
      FlightDataDisplay.webUploadDelay = 2;
    }
    if (FlightStatusUpdate.currentStatus == FlightStatus.TOF) {
      FlightDataDisplay.webUploadDelay = 2;
    }
    if (FlightStatusUpdate.currentStatus == FlightStatus.ICL) {
      FlightDataDisplay.webUploadDelay = 5;
    }
    if (FlightStatusUpdate.currentStatus == FlightStatus.ENR) {
      FlightDataDisplay.webUploadDelay = 100;
    }
    if (FlightStatusUpdate.currentStatus == FlightStatus.TEN) {
      FlightDataDisplay.webUploadDelay = 10;
    }
    if (FlightStatusUpdate.currentStatus == FlightStatus.LDG) {
      FlightDataDisplay.webUploadDelay = 5;
    }
    if (FlightStatusUpdate.currentStatus == FlightStatus.LAN) {
      FlightDataDisplay.webUploadDelay = 2;
    }
    if (FlightStatusUpdate.currentStatus == FlightStatus.ARR) {
      FlightDataDisplay.webUploadDelay = 100;
    }
  }

  void startTimer() {
    WebComm webComm = WebComm();
    startConnector();
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (!_isFetchingData) {
        _isFetchingData = true;
        FlightSimComm()
            .getFlightData(context, onError: stopTimer, onRetry: startTimer)
            .then((data) {
              if (data != null) {
                _flightDataNotifier.value = FlightData(
                  airspeed: data['airspeed'] ?? 0,
                  groundSpeed: data['groundSpeed'] ?? 0,
                  altCalibrated: data['altCalibrated'] ?? 0,
                  radioAltitude: data['radioAltitude'] ?? 0,
                  gpsLat: data['gpsLat'] ?? 0.0,
                  gpsLon: data['gpsLon'] ?? 0.0,
                  totalFuel: data['totalFuel'] ?? 0,
                  trueHeading: data['trueHeading'] ?? 0,
                  zuluYear: data['zuluYear'] ?? 0,
                  zuluMonth: data['zuluMonth'] ?? 0,
                  zuluDay: data['zuluDay'] ?? 0,
                  zuluHour: data['zuluHour'] ?? 0,
                  zuluMinute: data['zuluMinute'] ?? 0,
                  zuluSecond: data['zuluSecond'] ?? 0,
                  isOnGround: data['isOnGround'] ?? false,
                  isEngOn: data['isEngOn'] ?? false,
                  landingVS: data['landingVS'] ?? 0,
                  landingG: data['landingG'] ?? 0.0,
                  flightStatus: data['flightStatus'] ?? '',
                );
              }
              _isFetchingData = false;
            });
        if (FlightDataDisplay.webUploadDelay > 1) {
          FlightDataDisplay.webUploadDelay =
              FlightDataDisplay.webUploadDelay - 1;
        } else {
          resetWebUploadDelay();
          webComm
              .updatePosition(
                widget.vaUrl,
                widget.apiKey,
                widget.pirepID,
                _flightDataNotifier.value.gpsLat,
                _flightDataNotifier.value.gpsLon,
                _flightDataNotifier.value.altCalibrated,
                _flightDataNotifier.value.groundSpeed,
                _flightDataNotifier.value.trueHeading,
                _flightDataNotifier.value.totalFuel,
                _flightDataNotifier.value.zuluYear,
                _flightDataNotifier.value.zuluMonth,
                _flightDataNotifier.value.zuluDay,
                _flightDataNotifier.value.zuluHour,
                _flightDataNotifier.value.zuluMinute,
                _flightDataNotifier.value.zuluSecond,
                context,
              )
              .then((result) {
                if (result is Exception) {
                  if (kDebugMode) {
                    print('Error updating position: $result');
                  }
                  stopTimer();
                  showConnectionError(context, result, startTimer);
                }
              });
        }
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
    stopConnector();
  }

  //
  //
  //
  //
  // UI
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 15,
      children: [
        FlightDataText(flightDataNotifier: _flightDataNotifier),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            Text('Status auto update'),
            ToggleSwitch(
              checked: statusAutoUpdate,
              onChanged: (v) => setState(() => statusAutoUpdate = v),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            ComboBox(
              value: selectedValue,
              onChanged: (value) {
                setState(() {
                  selectedValue = value ?? FlightStatus.BST;
                });
              },
              items: [
                ComboBoxItem(value: FlightStatus.BST, child: Text('Boarding')),
                ComboBoxItem(value: FlightStatus.TXI, child: Text('Taxi')),
                ComboBoxItem(value: FlightStatus.TOF, child: Text('Takeoff')),
                ComboBoxItem(
                  value: FlightStatus.ICL,
                  child: Text('Initial climb'),
                ),
                ComboBoxItem(value: FlightStatus.ENR, child: Text('Enroute')),
                ComboBoxItem(value: FlightStatus.TEN, child: Text('Approach')),
                ComboBoxItem(value: FlightStatus.LDG, child: Text('Landing')),
                ComboBoxItem(value: FlightStatus.LAN, child: Text('Landed')),
                ComboBoxItem(value: FlightStatus.ARR, child: Text('Arrived')),
                ComboBoxItem(value: FlightStatus.PSD, child: Text('Paused')),
              ],
            ),
            Button(
              child: Text('Update'),
              onPressed: () {
                setState(() {
                  FlightStatusUpdate.currentStatus = selectedValue;
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}

class FlightDataText extends StatelessWidget {
  final ValueNotifier<FlightData> flightDataNotifier;
  const FlightDataText({super.key, required this.flightDataNotifier});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: flightDataNotifier,
      builder: (context, flightData, child) {
        return Column(
          children: [
            Text(
              'Airspeed: ${flightData.airspeed} kts \nGround speed: ${flightData.groundSpeed} kts \nCalibrated altitude: ${flightData.altCalibrated} ft \nRadio altitude: ${flightData.radioAltitude} ft \nLat: ${flightData.gpsLat}° \nLon: ${flightData.gpsLon}° \nTotal fuel: ${flightData.totalFuel} lbs \nTrue heading: ${flightData.trueHeading}° \nSim zulu time: ${flightData.zuluYear}-${flightData.zuluMonth}-${flightData.zuluDay}   ${flightData.zuluHour}:${flightData.zuluMinute}:${flightData.zuluSecond} \nOn ground: ${flightData.isOnGround == true ? 'True' : 'False'} \nEngine running: ${flightData.isEngOn == true ? 'True' : 'False'}\nLandingVS: ${flightData.landingVS} fpm\nLandingG: ${flightData.landingG} g\n\nflight status: ${flightData.flightStatus}\nWeb upload delay: ${FlightDataDisplay.webUploadDelay}',
              style: const TextStyle(fontSize: 15, height: 1.7),
            ),
          ],
        );
      },
    );
  }
}
