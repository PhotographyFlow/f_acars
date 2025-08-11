import 'package:fluent_ui/fluent_ui.dart';
import 'flight.dart';
import 'package:f_acars/web_comm.dart';

class FlightLoadingPage extends StatelessWidget {
  final TextEditingController vaUrlController;
  final TextEditingController apiKeyController;
  final int airlineID;
  final int aircraftID;
  final String airlineIcao;
  final String airlineIata;
  final String flightNumber;
  final int blockFuel;
  final String depAirport;
  final String arrAirport;
  final String route;
  final List<dynamic> fares;
  final String bidID;
  final num plannedDistance;
  final int plannedFlightTime;

  final int weightUnit;

  const FlightLoadingPage({
    super.key,
    required this.vaUrlController,
    required this.apiKeyController,
    required this.airlineID,
    required this.aircraftID,
    required this.airlineIcao,
    required this.airlineIata,
    required this.flightNumber,
    required this.blockFuel,
    required this.depAirport,
    required this.arrAirport,
    required this.route,
    required this.fares,
    required this.bidID,
    required this.plannedDistance,
    required this.plannedFlightTime,

    required this.weightUnit,
  });

  @override
  Widget build(BuildContext context) {
    int blockFuelConverted = blockFuel;
    if (weightUnit == 1) {
      //if is kg, to lbs
      blockFuelConverted = (blockFuel * 2.2046226218).toInt();
    }
    WebComm()
        .prefilePireps(
          vaUrlController.text,
          apiKeyController.text,
          context,
          airlineID,
          aircraftID,
          bidID,
          depAirport,
          arrAirport,
          flightNumber,
          route,
          plannedDistance,
          plannedFlightTime,
          blockFuelConverted,
          fares,
        )
        .then((result) {
          String flightID = result?['id'] ?? 'null';
          if (flightID != 'null') {
            Navigator.pushAndRemoveUntil(
              context,
              FluentPageRoute(
                builder: (context) => FlightPage(
                  flightID: flightID,
                  airlineIcao: airlineIcao,
                  airlineIata: airlineIata,
                  flightNumber: flightNumber,
                  depAirport: depAirport,
                  arrAirport: arrAirport,
                  blockFuel: blockFuel,
                  weightUnit: weightUnit,
                  route: route,
                  fares: fares,
                  vaUrl: vaUrlController.text,
                  apiKey: apiKeyController.text,
                ),
              ),
              (route) => false,
            );
          }
        });
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 20,
      children: [
        SizedBox(height: 50, width: 50, child: ProgressRing()),
        Text('Prefiling pirep, please wait...'),
      ],
    );
  }
}
