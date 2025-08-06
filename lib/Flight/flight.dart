import 'package:f_acars/main.dart';
import 'package:fluent_ui/fluent_ui.dart';

class FlightPage extends StatefulWidget {
  final String flightID;
  final String airlineIcao;
  final String airlineIata;
  final String flightNumber;
  final String depAirport;
  final String arrAirport;
  final int blockFuel;
  final int weightUnit;
  final String route;
  final List<dynamic> fares;
  const FlightPage({
    super.key,
    required this.flightID,
    required this.airlineIcao,
    required this.airlineIata,
    required this.flightNumber,
    required this.depAirport,
    required this.arrAirport,
    required this.blockFuel,
    required this.weightUnit,
    required this.route,
    required this.fares,
  });

  @override
  State<FlightPage> createState() => _FlightPageState();
}

class _FlightPageState extends State<FlightPage> {
  @override
  Widget build(BuildContext context) {
    return FluentTheme(
      data: FluentThemeData(
        micaBackgroundColor: Colors.transparent,
        brightness: Brightness.dark,
        accentColor: Colors.blue,
        scaffoldBackgroundColor: Colors.transparent,
      ),
      child: ScaffoldPage.scrollable(
        header: PageHeader(
          title: Text(
            '${widget.airlineIcao} / ${widget.airlineIata} ${widget.flightNumber}',
            style: FluentTheme.of(context).typography.titleLarge,
          ),
        ),
        bottomBar: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              child: Button(
                child: Row(
                  spacing: 7,
                  children: [Text('Quit'), Icon(FluentIcons.clear)],
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    FluentPageRoute(builder: (context) => MyApp()),
                    (route) => false,
                  );
                },
              ),
            ),
          ],
        ),
        children: [
          SizedBox(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              spacing: 20,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(right: 30),
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(
                              color: FluentTheme.of(
                                context,
                              ).resources.controlStrokeColorSecondary,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Column(
                          spacing: 20,
                          children: [
                            Row(
                              spacing: 30,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.depAirport,
                                  style: FluentTheme.of(
                                    context,
                                  ).typography.title,
                                ),
                                Icon(FluentIcons.airplane, size: 20.0),
                                Text(
                                  widget.arrAirport,
                                  style: FluentTheme.of(
                                    context,
                                  ).typography.title,
                                ),
                              ],
                            ),

                            //show block fuel
                            Text(
                              'Block fuel:  ${widget.blockFuel}  ${widget.weightUnit == 1 ? 'kg' : 'lbs'}',
                              style: FluentTheme.of(
                                context,
                              ).typography.subtitle,
                            ),

                            Text(
                              'Fares:',
                              style: FluentTheme.of(
                                context,
                              ).typography.subtitle,
                            ),
                            //show fares in a table
                            Table(
                              border: TableBorder(
                                top: BorderSide(
                                  color: FluentTheme.of(
                                    context,
                                  ).resources.controlStrokeColorSecondary,
                                  width: 2,
                                ),
                                horizontalInside: BorderSide(
                                  color: FluentTheme.of(
                                    context,
                                  ).resources.controlStrokeColorSecondary,
                                ),
                                bottom: BorderSide(
                                  color: FluentTheme.of(
                                    context,
                                  ).resources.controlStrokeColorSecondary,
                                  width: 2,
                                ),
                              ),

                              children: [
                                TableRow(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(7.0),
                                      child: Text(
                                        'Name',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(7.0),
                                      child: Text(
                                        'Code',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(7.0),
                                      child: Text(
                                        'Count',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                ...widget.fares.map((fare) {
                                  return TableRow(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(5.0),
                                        child: Text(fare['name'].toString()),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(5.0),
                                        child: Text(fare['code'].toString()),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(5.0),
                                        child: Text(fare['count'].toString()),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ],
                            ),

                            Text(
                              'Route:',
                              style: FluentTheme.of(
                                context,
                              ).typography.subtitle,
                            ),
                            //show high lighted routes
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey[140].withAlpha(90),
                                      ),
                                      borderRadius: BorderRadius.circular(5.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey[120].withAlpha(32),
                                          spreadRadius: 1,
                                          blurRadius: 2,
                                          offset: Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                    padding: EdgeInsets.all(5.0),
                                    child:
                                        //highlight airways, assume airways are contain numbers
                                        //I think this is the best way so far :(
                                        //Anyone have better way?
                                        Center(
                                          child: Text.rich(
                                            TextSpan(
                                              children: widget.route
                                                  .split(' ')
                                                  .map((part) {
                                                    if (part.contains(
                                                      RegExp(r'\d'),
                                                    )) {
                                                      return TextSpan(
                                                        text: '$part ',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15.0,
                                                        ),
                                                      );
                                                    } else {
                                                      return TextSpan(
                                                        text: '$part ',
                                                        style: TextStyle(
                                                          color:
                                                              Colors.grey[100],
                                                          fontSize: 15.0,
                                                        ),
                                                      );
                                                    }
                                                  })
                                                  .toList(),
                                            ),
                                          ),
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(child: Column(children: [Text('Airspeed:N/A')])),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
