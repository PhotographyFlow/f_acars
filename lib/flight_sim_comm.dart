import 'package:http/http.dart';
import 'package:flutter/foundation.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'dart:convert';
import 'dart:async';

class FlightSimComm {
  final String flightSimUrl = 'http://localhost:8000';
  final recorder = LandingDataRecorder();

  Future getFlightData(
    BuildContext context, {
    VoidCallback? onError,
    VoidCallback? onRetry,
  }) async {
    try {
      final response = await post(
        Uri.parse('$flightSimUrl/api/uipc'),
        body: jsonEncode({
          "requestId": "1",
          "apiVersion": "1.0",
          "dataQueries": [
            {
              "name": "AIRSPEED INDICATED (knots multed by 128)",
              "offset": "  0x02BC",
              "size": 4,
              "targetType": "int32",
            },
            {
              "name": "GPS GROUND SPEED (m per s)",
              "offset": "0x6030",
              "size": 8,
              "targetType": "float64",
            },
            {
              "name": "INDICATED ALTITUDE CALIBRATED SEA LEVEL(m)",
              "offset": "0x34B0",
              "size": 8,
              "targetType": "float64",
            },
            {
              "name": " Radio altitude (m)",
              "offset": "0x31E4",
              "size": 4,
              "targetType": "int32",
            },
            {
              "name": "GPS POSITION LAT (deg)",
              "offset": "0x6010",
              "size": 8,
              "targetType": "float64",
            },
            {
              "name": "GPS POSITION LON (deg)",
              "offset": "0x6018",
              "size": 8,
              "targetType": "float64",
            },
            {
              "name": " total fuel quantity weight in pounds",
              "offset": "0x126C",
              "size": 4,
              "targetType": "int32",
            },
            {
              "name": "TRUE heading",
              "offset": "0x0580",
              "size": 4,
              "targetType": "int32",
            },
            {
              "name": "Zulu year",
              "offset": "0x0240",
              "size": 2,
              "targetType": "int16",
            },
            {
              "name": "Zulu month",
              "offset": "0x0242",
              "size": 1,
              "targetType": "int8",
            },
            {
              "name": "Zulu day",
              "offset": "0x023D",
              "size": 1,
              "targetType": "int8",
            },
            {
              "name": "Zulu hour",
              "offset": "0x023B",
              "size": 1,
              "targetType": "int8",
            },
            {
              "name": "Zulu minute",
              "offset": "0x023C",
              "size": 1,
              "targetType": "int8",
            },
            {
              "name": "Zulu second",
              "offset": "0x023A",
              "size": 1,
              "targetType": "int8",
            },
            {
              "name": "Aircraft on ground flag",
              "offset": "0x0366",
              "size": 2,
              "targetType": "int16",
            },
            {
              "name": "Eng1 on flag",
              "offset": "0x0894",
              "size": 2,
              "targetType": "int16",
            },
            {
              "name": "Eng2 on flag",
              "offset": "0x092C",
              "size": 2,
              "targetType": "int16",
            },
            {
              "name": "Eng3 on flag",
              "offset": "0x09C4",
              "size": 2,
              "targetType": "int16",
            },
            {
              "name": "Eng4 on flag",
              "offset": "0x0A5C",
              "size": 2,
              "targetType": "int16",
            },
            {
              "name": "Landing V/S (mps)",
              "offset": "0x030C",
              "size": 4,
              "targetType": "int32",
            },
            {
              "name": "Landing G (*624)",
              "offset": "0x11B8",
              "size": 2,
              "targetType": "int16",
            },
          ],
        }),
      );
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final responseData = responseBody['dataResults'];
        /*
        if (kDebugMode) {
          print(responseData);
        }
        */
        final String isSucceeded = responseBody['status'] ?? 'failed';
        if (isSucceeded == 'success') {
          final airspeed = (((responseData[0]['convertedValue']) ?? 0) / 128)
              .toInt();
          final groundSpeed =
              (((responseData[1]['convertedValue']) ?? 0.0) * 1.94)
                  .toInt(); //conveted from m/s to knots
          final altCalibrated =
              (((responseData[2]['convertedValue']) ?? 0.0) * 3.28).toInt();
          final radioAltitude =
              ((((responseData[3]['convertedValue']) ?? 0) / 65536) * 3.28)
                  .toInt();
          final gpsLat = double.parse(
            (responseData[4]['convertedValue'] ?? 0.0).toStringAsFixed(4),
          );
          final gpsLon = double.parse(
            (responseData[5]['convertedValue'] ?? 0.0).toStringAsFixed(4),
          );
          final totalFuel = (responseData[6]['convertedValue']) ?? 0;
          final trueHeading =
              (((((responseData[7]['convertedValue']) ?? 0) * 360) /
                          (65536 * 65536))
                      .toInt() +
                  360) %
              360;
          final zuluYear = (responseData[8]['convertedValue']) ?? 0;
          final zuluMonth = (responseData[9]['convertedValue']) ?? 0;
          final zuluDay = (responseData[10]['convertedValue']) ?? 0;
          final zuluHour = (responseData[11]['convertedValue']) ?? 0;
          final zuluMinute = (responseData[12]['convertedValue']) ?? 0;
          final zuluSecond = (responseData[13]['convertedValue']) ?? 0;
          final isOnGround = (responseData[14]['convertedValue']) ?? 0;
          final eng1On = (responseData[15]['convertedValue']) ?? 0;
          final eng2On = (responseData[16]['convertedValue']) ?? 0;
          final eng3On = (responseData[17]['convertedValue']) ?? 0;
          final eng4On = (responseData[18]['convertedValue']) ?? 0;
          final bool isEngOn =
              eng1On == 1 || eng2On == 1 || eng3On == 1 || eng4On == 1;

          if (radioAltitude < 200 && context.mounted) {
            recorder.start(context);
          }
          if (radioAltitude > 200) {
            recorder.stop();
          }
          if (kDebugMode) {
            print(
              'maxLandingVS: ${LandingDataRecorder.landingVS}, maxLandingG: ${LandingDataRecorder.landingG}',
            );
          }

          return {
            'airspeed': airspeed,
            'groundSpeed': groundSpeed,
            'altCalibrated': altCalibrated,
            'radioAltitude': radioAltitude,
            'gpsLat': gpsLat,
            'gpsLon': gpsLon,
            'totalFuel': totalFuel,
            'trueHeading': trueHeading,
            'zuluYear': zuluYear,
            'zuluMonth': zuluMonth,
            'zuluDay': zuluDay,
            'zuluHour': zuluHour,
            'zuluMinute': zuluMinute,
            'zuluSecond': zuluSecond,
            'isOnGround': isOnGround,
            'eng1On': eng1On,
            'eng2On': eng2On,
            'eng3On': eng3On,
            'eng4On': eng4On,
            'isEngOn': isEngOn,
            'landingVS': LandingDataRecorder.landingVS,
            'landingG': LandingDataRecorder.landingG,
          };
        } else {
          throw Exception(
            'Failed to get flight data. Disconnect from the game.',
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      if (context.mounted) {
        onError?.call();
        showConnectionError(context, e, onRetry);
      }
    }
  }
}

void showConnectionError(BuildContext context, e, VoidCallback? onRetry) async {
  await showDialog<String>(
    context: context,
    builder: (context) => ContentDialog(
      title: const Text('Connection error!'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 10,
        children: [
          Text(
            'There is an error occurred while get data and send to the server.',
          ),
          Container(
            decoration: BoxDecoration(
              color: FluentTheme.of(
                context,
              ).resources.controlStrokeColorSecondary,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: FluentTheme.of(
                  context,
                ).resources.controlStrokeColorSecondary,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(7.0),
              child: Text(e.toString()),
            ),
          ),
        ],
      ),
      actions: [
        Button(
          child: const Text('Retry'),
          onPressed: () {
            Navigator.pop(context);
            onRetry?.call();
          },
        ),
      ],
    ),
  );
}

class LandingDataRecorder {
  final String flightSimUrl = 'http://localhost:8000';
  Timer? _timer;
  bool _isStarted = false;
  BuildContext? context;

  static int landingVS = 1;
  static double landingG = 1;

  Future start(
    BuildContext context, {
    VoidCallback? onError,
    VoidCallback? onRetry,
  }) async {
    if (!_isStarted) {
      _isStarted = true;
      _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) async {
        try {
          final response = await post(
            Uri.parse('$flightSimUrl/api/uipc'),
            body: jsonEncode({
              "requestId": "1",
              "apiVersion": "1.0",
              "dataQueries": [
                {
                  "name": "Landing V/S (mps)",
                  "offset": "0x030C",
                  "size": 4,
                  "targetType": "int32",
                },
                {
                  "name": "Landing G (*624)",
                  "offset": "0x11B8",
                  "size": 2,
                  "targetType": "int16",
                },
                {
                  "name": "Aircraft on ground flag",
                  "offset": "0x0366",
                  "size": 2,
                  "targetType": "int16",
                },
              ],
            }),
          );
          if (response.statusCode == 200) {
            final responseBody = jsonDecode(response.body);
            final responseData = responseBody['dataResults'];
            final isOnGround = (responseData[2]['convertedValue']) ?? 0;
            if (isOnGround == 1) {
              final landingVSNew =
                  (((responseData[0]['convertedValue']) ?? 0) *
                          (60 * 3.28084 / 256))
                      .toInt();
              final landingGNew = double.parse(
                ((responseData[1]['convertedValue'] ?? 0.0) / 624)
                    .toStringAsFixed(2),
              );
              if (landingVSNew < landingVS) {
                landingVS = landingVSNew;
                print('landingVS: $landingVS');
              }
              if (landingGNew > landingG) {
                landingG = landingGNew;
                print('landingG: $landingG');
              }
            }
          }
        } catch (e) {
          stop();
          if (kDebugMode) {
            print(e);
          }
          if (context.mounted) {
            onError?.call();
            showConnectionError(context, e, onRetry);
          }
        }
      });
    }
  }

  void stop() {
    if (_isStarted) {
      _isStarted = false;
      _timer?.cancel();
    }
  }
}
