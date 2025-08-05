import 'package:f_acars/main.dart';
import 'package:fluent_ui/fluent_ui.dart';

class FlightPage extends StatefulWidget {
  final String flightID;

  const FlightPage({super.key, required this.flightID});

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
        children: [
          Column(
            children: [
              Text('this is flight page.'),
              Text('flightID:${widget.flightID}'),
              Button(
                child: Text('quit'),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    FluentPageRoute(builder: (context) => MyApp()),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
