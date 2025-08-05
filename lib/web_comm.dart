import 'package:f_acars/Flight/prefile_error.dart';
import 'package:http/http.dart';
import 'package:flutter/foundation.dart';
import 'package:f_acars/l10n/app_localizations.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'dart:convert';
import 'dart:async';

class WebComm {
  Future testConnection(
    TextEditingController vaUrlController,
    TextEditingController apiKeyController,
    String? apiKeyValidationError,
    String? vaUrlValidationError,
    Text? testConnnectionError,
    BuildContext context,
  ) async {
    try {
      final response = await get(
        Uri.parse('${vaUrlController.text}/api/user'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': apiKeyController.text,
        },
      );
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final responseData = responseBody['data'];
        if (kDebugMode) {
          print(responseData);
        }
        if (responseData.containsKey('id') &&
            responseData.containsKey('pilot_id') &&
            responseData.containsKey('ident')) {
          testConnnectionError = Text(
            AppLocalizations.of(context)!.testOK,
            style: TextStyle(color: Colors.successPrimaryColor),
          );
          return testConnnectionError;
        } else {
          testConnnectionError = Text(
            '\u2717${AppLocalizations.of(context)!.eCheckVA}',
            style: TextStyle(color: Colors.errorPrimaryColor),
          );
          return testConnnectionError;
        }
      }
      if (response.statusCode == 401) {
        testConnnectionError = Text(
          '\u2717${AppLocalizations.of(context)!.e401}',
          style: TextStyle(color: Colors.errorPrimaryColor),
        );
        return testConnnectionError;
      }
      if (response.statusCode == 404) {
        testConnnectionError = Text(
          '\u2717${AppLocalizations.of(context)!.e404}',
          style: TextStyle(color: Colors.errorPrimaryColor),
        );
        return testConnnectionError;
      }
      if (response.statusCode == 400) {
        testConnnectionError = Text(
          '\u2717${AppLocalizations.of(context)!.e400}',
          style: TextStyle(color: Colors.errorPrimaryColor),
        );
        return testConnnectionError;
      }
    } catch (e) {
      testConnnectionError = Text(
        AppLocalizations.of(context)!.eInternet,
        style: TextStyle(color: Colors.errorPrimaryColor),
      );

      if (kDebugMode) {
        print(e);
      }
    }
    return testConnnectionError;
  }

  Future getBids(
    String vaUrlController,
    String apiKeyController,
    BuildContext context,
  ) async {
    try {
      final response = await get(
        Uri.parse('$vaUrlController/api/user/bids'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': apiKeyController,
        },
      );
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final responseData = responseBody['data'][0];
        if (kDebugMode) {
          print(responseData);
        }
        if (responseData.containsKey('id') &&
            responseData.containsKey('flight_id') &&
            responseData.containsKey('aircraft_id')) {
          return responseData;
        }
      }
      if (response.statusCode == 401) {
        await displayInfoBar(
          context,
          builder: (context, close) {
            return InfoBar(
              title: const Text('Error'),
              content: Text(AppLocalizations.of(context)!.e401),
              action: IconButton(
                icon: const Icon(FluentIcons.clear),
                onPressed: close,
              ),
              severity: InfoBarSeverity.error,
            );
          },
        );
      }
      if (response.statusCode == 404) {
        await displayInfoBar(
          context,
          builder: (context, close) {
            return InfoBar(
              title: const Text('Error'),
              content: Text(AppLocalizations.of(context)!.e404),
              action: IconButton(
                icon: const Icon(FluentIcons.clear),
                onPressed: close,
              ),
              severity: InfoBarSeverity.error,
            );
          },
        );
      }
      if (response.statusCode == 400) {
        await displayInfoBar(
          context,
          builder: (context, close) {
            return InfoBar(
              title: const Text('Error'),
              content: Text(AppLocalizations.of(context)!.e400),
              action: IconButton(
                icon: const Icon(FluentIcons.clear),
                onPressed: close,
              ),
              severity: InfoBarSeverity.error,
            );
          },
        );
      }
    } catch (e) {
      await displayInfoBar(
        context,
        builder: (context, close) {
          return InfoBar(
            title: const Text('No bids found :('),
            content: const Text(
              'Couldn\'t find any bids. Check your settings and internet connection or add one bid at your VA website.',
            ),
            action: IconButton(
              icon: const Icon(FluentIcons.clear),
              onPressed: close,
            ),
            severity: InfoBarSeverity.warning,
          );
        },
      );
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future prefilePireps(
    String vaUrlController,
    String apiKeyController,
    BuildContext context,
    int airlineID,
    int aircraftID,
    String bidID,
    String depAirport,
    String arrAirport,
    String flightNumber,
    String route,
    num plannedDistance,
    int plannedFlightTime,
    int blockFuel,
    List<dynamic> fares,
  ) async {
    try {
      final response = await post(
        Uri.parse('$vaUrlController/api/pireps/prefile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': apiKeyController,
        },
        body: jsonEncode({
          "airline_id": airlineID,
          "aircraft_id": aircraftID,
          "flight_id": bidID,
          "dpt_airport_id": depAirport,
          "arr_airport_id": arrAirport,
          "flight_number": flightNumber,
          "route": route,
          "planned_distance": plannedDistance,
          "distance": 0.01,
          "planned_flight_time": plannedFlightTime,
          "flight_time": 0,
          "block_fuel": blockFuel,
          "fares": fares,
          "source_name": "F-ACARS",
        }),
      );
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final responseData = responseBody['data'];
        if (kDebugMode) {
          print(responseData);
        }
        if (responseData.containsKey('id') &&
            responseData.containsKey('flight_id') &&
            responseData.containsKey('aircraft_id')) {
          return responseData;
        } else {
          throw Exception('Prefiling failed');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      Navigator.of(context, rootNavigator: true).push(
        FluentPageRoute(
          builder: (context) {
            return PrefileErrorPage();
          },
        ),
      );
      showPrefileError(context, e);
    }
  }
}

void showPrefileError(BuildContext context, e) async {
  await showDialog<String>(
    context: context,
    builder: (context) => ContentDialog(
      title: const Text('Prefiling error!'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 10,
        children: [
          Text(
            'There is an error occurred while prefiling. Please check your settings and internet connection.',
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
          child: const Text('Back'),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}
