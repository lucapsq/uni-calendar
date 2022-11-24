import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:uni_calendar/main.dart';

class DarkModeSwitch extends StatefulWidget {
  const DarkModeSwitch({super.key});

  @override
  State<DarkModeSwitch> createState() => _DarkModeSwitchState();
}

class _DarkModeSwitchState extends State<DarkModeSwitch> {
  int selectedTheme = 1;

  Future<void> savePreferences(int mode) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt('themeMode', mode);
  }

  void getPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getInt('themeMode') != null &&
        prefs.getInt('themeMode') != selectedTheme)
      setState(() {
        selectedTheme = prefs.getInt('themeMode')!;
      });
    else if (prefs.getInt('themeMode') == null)
      setState(() {
        selectedTheme = 1;
      });
  }

  @override
  Widget build(BuildContext context) {
    getPreferences();
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: ToggleSwitch(
        minWidth: 90.0,
        minHeight: 60.0,
        fontSize: 18.0,
        initialLabelIndex: selectedTheme,
        activeBgColor: [Colors.blue],
        inactiveBgColor: Colors.grey[400],
        inactiveFgColor: Colors.grey[900],
        activeFgColor: Colors.white,
        totalSwitches: 3,
        labels: ['Chiaro', 'Sistema', 'Scuro'],
        onToggle: (index) async {
          await savePreferences(index!);
          MyApp.of(context).changeTheme();
        },
      ),
    );
  }
}
