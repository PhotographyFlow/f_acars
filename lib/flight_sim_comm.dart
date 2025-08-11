import 'package:http/http.dart';
import 'package:flutter/foundation.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'dart:convert';
import 'dart:async';

class FlightSimComm {
  final String flightSimUrl = 'http://localhost:8000';

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
              "name": "AIRSPEED INDICATED (knots mult.ed by. 128)",
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
              "name": " Radio altitude (metres)",
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
          ],
        }),
      );
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final responseData = responseBody['dataResults'];
        if (kDebugMode) {
          print(responseData);
        }
        final airspeed = (((responseData[0]['convertedValue']) ?? 0) / 128)
            .toInt();
        final groundSpeed =
            (((responseData[1]['convertedValue']) ?? 0.0) * 1.94)
                .toInt(); //conveted from m/s to knots
        final altCalibrated = ((responseData[2]['convertedValue']) ?? 0.0)
            .toInt();
        final radioAltitude =
            (((responseData[3]['convertedValue']) ?? 0) / 65536).toInt();
        final gpsLat = double.parse(
          (responseData[4]['convertedValue'] ?? 0.0).toStringAsFixed(4),
        );
        final gpsLon = double.parse(
          (responseData[5]['convertedValue'] ?? 0.0).toStringAsFixed(4),
        );
        final totalFuel = (responseData[6]['convertedValue']) ?? 0;
        return {
          'airspeed': airspeed,
          'groundSpeed': groundSpeed,
          'altCalibrated': altCalibrated,
          'radioAltitude': radioAltitude,
          'gpsLat': gpsLat,
          'gpsLon': gpsLon,
          'totalFuel': totalFuel,
        };
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
        if (context.mounted) {
          onError?.call();
          showConnectionError(context, e, onRetry);
        }
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
          Text('There is an error occurred while connection to the game.'),
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
