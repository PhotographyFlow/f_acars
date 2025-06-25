import 'package:fluent_ui/fluent_ui.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final apiKeyController = TextEditingController();
  String? validationError = '';

  @override
  void initState() {
    super.initState();
    apiKeyController.addListener(() {
      _validateApiKey(apiKeyController.text);
    });
  }

  void _validateApiKey(String text) {
    if (text.length != 20) {
      setState(() => validationError = 'Ensure enter the right api key.');
    } else {
      setState(() => validationError = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    FluentThemeData(brightness: Brightness.dark, accentColor: Colors.blue);

    return ScaffoldPage.scrollable(
      header: const PageHeader(title: Text('Settings')),
      children: [
        Text("Your api key (don't share this!)"),
        PasswordFormBox(
          controller: apiKeyController,
          revealMode: PasswordRevealMode.peekAlways,
          autovalidateMode: AutovalidateMode.always,
          validator: (text) => validationError,
        ),
        Button(
          onPressed: validationError == null
              ? () {
                  final apiKey = apiKeyController.text;
                  print('API Key saved: $apiKey');
                }
              : null,
          child: Text("Submmit"),
        ),
      ],
    );
  }
}
