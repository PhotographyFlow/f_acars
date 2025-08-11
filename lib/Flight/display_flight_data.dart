import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:f_acars/flight_sim_comm.dart';
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

  FlightData({
    required this.airspeed,
    required this.groundSpeed,
    required this.altCalibrated,
    required this.radioAltitude,
    required this.gpsLat,
    required this.gpsLon,
    required this.totalFuel,
  });
}

class FlightDataDisplay extends StatefulWidget {
  final String vaUrl;
  final String apiKey;

  const FlightDataDisplay({
    super.key,
    required this.vaUrl,
    required this.apiKey,
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
    try {
      Process.run('UIPCDemo32.exe', [])
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
    try {
      Process.run('cmd', ['/c', 'taskkill /F /IM UIPCDemo32.exe'])
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
    startConnector();
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
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
                );
              }
              _isFetchingData = false;
            });
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
              'Airspeed: ${flightData.airspeed} knots\nGround speed: ${flightData.groundSpeed} knots\nCalibrated altitude: ${flightData.altCalibrated} m\nRadio altitude: ${flightData.radioAltitude} metres\nGPS Lat: ${flightData.gpsLat}°\nGPS Lon: ${flightData.gpsLon}°\nTotal fuel: ${flightData.totalFuel} lbs',
            ),
          ],
        );
      },
    );
  }
}
