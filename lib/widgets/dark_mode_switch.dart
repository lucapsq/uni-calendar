import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';

class DarkModeSwitch extends StatefulWidget {
  const DarkModeSwitch({super.key});

  @override
  State<DarkModeSwitch> createState() => _DarkModeSwitchState();
}

Future<void> savePreferences(int mode) async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setInt('themeMode', mode);
}

class _DarkModeSwitchState extends State<DarkModeSwitch> {
  @override
  Widget build(BuildContext context) {
    return ToggleSwitch(
      minWidth: 90.0,
      minHeight: 90.0,
      fontSize: 17.0,
      initialLabelIndex: 1,
      activeBgColor: [Colors.blue],
      inactiveBgColor: Colors.grey,
      inactiveFgColor: Colors.grey[900],
      totalSwitches: 3,
      labels: ['Chiaro', 'Sistema', 'Scuro'],
      onToggle: (index) async {
        await savePreferences(index!);
        print('switched to: $index');
      },
    );
  }
}
