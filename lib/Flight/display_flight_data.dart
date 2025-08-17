import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:f_acars/flight_sim_comm.dart';
// import 'package:f_acars/web_comm.dart';
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
  int eng1On;
  int eng2On;
  int eng3On;
  int eng4On;
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
    required this.eng1On,
    required this.eng2On,
    required this.eng3On,
    required this.eng4On,
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
      eng1On: 0,
      eng2On: 0,
      eng3On: 0,
      eng4On: 0,
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

  void startTimer() {
    // WebComm webComm = WebComm();
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
                  eng1On: data['eng1On'] ?? 0,
                  eng2On: data['eng2On'] ?? 0,
                  eng3On: data['eng3On'] ?? 0,
                  eng4On: data['eng4On'] ?? 0,
                  isEngOn: data['isEngOn'] ?? false,
                  landingVS: data['landingVS'] ?? 0,
                  landingG: data['landingG'] ?? 0.0,
                  flightStatus: data['flightStatus'] ?? '',
                );
              }
              _isFetchingData = false;
            });

        /*
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
                  print('Error updating position: ${result}');
                }
                stopTimer();
                showConnectionError(context, result, startTimer);
              }
            }); */
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
    stopConnector();
  }

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
            ComboBox(
              value: selectedValue,
              onChanged: (value) {
                setState(() {
                  selectedValue = value ?? FlightStatus.INI;
                });
              },
              items: [
                ComboBoxItem(value: FlightStatus.INI, child: Text('Initiated')),
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
              'Airspeed: ${flightData.airspeed} knots \nGround speed: ${flightData.groundSpeed} knots \nCalibrated altitude: ${flightData.altCalibrated} ft \nRadio altitude: ${flightData.radioAltitude} ft \nGPS Lat: ${flightData.gpsLat}° \nGPS Lon: ${flightData.gpsLon}° \nTotal fuel: ${flightData.totalFuel} lbs \nTrue heading: ${flightData.trueHeading}° \nSim zulu time: ${flightData.zuluYear}-${flightData.zuluMonth}-${flightData.zuluDay}   ${flightData.zuluHour}:${flightData.zuluMinute}:${flightData.zuluSecond} \nIs on ground: ${flightData.isOnGround == 1 ? 'True' : 'False'} \nEng1 On: ${flightData.eng1On == 1 ? 'True' : 'False'} \nEng2 On: ${flightData.eng2On == 1 ? 'True' : 'False'} \nEng3 On: ${flightData.eng3On == 1 ? 'True' : 'False'} \nEng4 On: ${flightData.eng4On == 1 ? 'True' : 'False'}\nIs at least one engine on: ${flightData.isEngOn}\nlandingVS: ${flightData.landingVS} \nlandingG: ${flightData.landingG}\nflight status: ${flightData.flightStatus}',
            ),
          ],
        );
      },
    );
  }
}
