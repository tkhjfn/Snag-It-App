import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _darkThemeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.blueAccent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SwitchListTile(
            title: const Text("Enable Notifications"),
            subtitle: const Text("Receive alerts for new listings"),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
            secondary: const Icon(Icons.notifications, color: Colors.blueAccent),
          ),
          SwitchListTile(
            title: const Text("Dark Theme"),
            subtitle: const Text("Reduce eye strain in low light"),
            value: _darkThemeEnabled,
            onChanged: (bool value) {
              setState(() {
                _darkThemeEnabled = value;
              });
              // Change theme globally (assuming use of a provider or similar)
              Provider.of<ThemeProvider>(context, listen: false).setDarkTheme(value);
            },
            secondary: const Icon(Icons.brightness_6, color: Colors.blueAccent),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info, color: Colors.blueAccent),
            title: const Text("About"),
            subtitle: const Text("Learn more about the app."),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Food Sharing App',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(Icons.fastfood, color: Colors.blueAccent),
                children: const [
                  Text(
                    "This app helps reduce food waste and addresses food insecurity by "
                    "connecting people willing to share surplus food with those in need.",
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class ThemeProvider extends ChangeNotifier {
  bool isDarkTheme = false;

  void setDarkTheme(bool value) {
    isDarkTheme = value;
    notifyListeners();
  }
}
