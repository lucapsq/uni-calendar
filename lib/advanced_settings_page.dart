import 'package:flutter/material.dart';
import 'package:uni_calendar/widgets/dark_mode_switch.dart';
import 'package:uni_calendar/widgets/reset_button.dart';

class AdvancedSettingsPage extends StatelessWidget {
  const AdvancedSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("UniVR Calendar")),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            DarkModeSwitch(),
            ResetButton(),
          ],
        ),
      ),
    );
  }
}
