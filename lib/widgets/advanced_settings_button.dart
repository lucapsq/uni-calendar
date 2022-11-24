import 'package:flutter/material.dart';
import 'package:uni_calendar/advanced_settings_page.dart';

class AdvancedSettingsButton extends StatelessWidget {
  final mediaQuery;
  const AdvancedSettingsButton(this.mediaQuery, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: mediaQuery.size.height * 0.15,
        height: mediaQuery.size.height * 0.09,
        child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AdvancedSettingsPage(mediaQuery)));
            },
            child: Text("Avanzate",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16))));
  }
}
