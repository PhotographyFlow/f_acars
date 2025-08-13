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
    ),
  );

  @override
  void initState() {
    super.initState();
    _startTimer();
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

  void _startTimer() {
    WebComm webComm = WebComm();
    startConnector();
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (!_isFetchingData) {
        _isFetchingData = true;
        FlightSimComm()
            .getFlightData(context, onError: _stopTimer, onRetry: _startTimer)
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
                );
              }
              _isFetchingData = false;
            });

        webComm.updatePosition(
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
        );
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
    stopConnector();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [AirspeedText(flightDataNotifier: _flightDataNotifier)],
    );
  }
}

class AirspeedText extends StatelessWidget {
  final ValueNotifier<FlightData> flightDataNotifier;
  const AirspeedText({super.key, required this.flightDataNotifier});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: flightDataNotifier,
      builder: (context, flightData, child) {
        return Column(
          children: [
            Text(
              'Airspeed: ${flightData.airspeed} knots\nGround speed: ${flightData.groundSpeed} knots\nCalibrated altitude: ${flightData.altCalibrated} ft\nRadio altitude: ${flightData.radioAltitude} ft\nGPS Lat: ${flightData.gpsLat}°\nGPS Lon: ${flightData.gpsLon}°\nTotal fuel: ${flightData.totalFuel} lbs\nTrue heading: ${flightData.trueHeading}°\nSim zulu time: ${flightData.zuluYear}-${flightData.zuluMonth}-${flightData.zuluDay}   ${flightData.zuluHour}:${flightData.zuluMinute}:${flightData.zuluSecond}',
            ),
          ],
        );
      },
    );
  }
}
