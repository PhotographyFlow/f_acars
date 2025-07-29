import 'package:http/http.dart';
import 'package:flutter/foundation.dart';
import 'package:f_acars/l10n/app_localizations.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'dart:convert';

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
}
