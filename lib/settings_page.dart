import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:uni_calendar/configuration_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Image(image: AssetImage('assets/setting-preference.png')),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ConfigurationPage()),
                  );
                },
                child: Text("Cambia corso")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ConfigurationPage()),
                  );
                },
                child: Text("Cambia sede")),
          ],
        ),
      ),
    );
  }
}
