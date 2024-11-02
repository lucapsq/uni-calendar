import 'package:flutter/material.dart';
import 'package:uni_calendar/widgets/credits_button.dart';
import 'package:uni_calendar/widgets/dark_mode_switch.dart';
import 'package:uni_calendar/widgets/reset_button.dart';

class AdvancedSettingsPage extends StatelessWidget {
  final mediaQuery;
  const AdvancedSettingsPage(this.mediaQuery, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Avanzate")),
      body: Container(
        width: mediaQuery.size.width,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25),
              child: Image.asset(
                "assets/advanced-settings.png",
                height: mediaQuery.size.height * 0.3,
              ),
            ),
            Text(
              "Che tema preferisci usare?",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            DarkModeSwitch(),
            SizedBox(
              height: 20,
            ),
            ResetButton(),
            SizedBox(
              height: 20,
            ),
            CreditsButton(mediaQuery),
          ],
        ),
      ),
    );
  }
}
