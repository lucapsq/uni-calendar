import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResetButton extends StatefulWidget {
  const ResetButton({super.key});

  @override
  State<ResetButton> createState() => _ResetButtonState();
}

class _ResetButtonState extends State<ResetButton> {
  Future<void> resetPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('courseCode');
    await prefs.remove('courseYear');
    await prefs.remove('courseYearCode');
    await prefs.remove('excludedLessonList');
    await prefs.remove('zonesList');
    setState(() {
      surePhrase = "Azzerata!";
    });
    await Future.delayed(Duration(seconds: 1));
    _pressCount = 0;
  }

  Color sureColor = Colors.blue;
  int _pressCount = 0;
  String surePhrase = "Azzera App";
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return SizedBox(
        width: mediaQuery.size.height * 0.15,
        height: mediaQuery.size.height * 0.09,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: sureColor,
            ),
            onPressed: () async {
              if (_pressCount == 0) {
                setState(() {
                  sureColor = Colors.red;
                  surePhrase = "Sei sicuro?";
                });
                _pressCount++;
              } else {
                await resetPreferences();

                setState(() {
                  sureColor = Colors.blue;
                  surePhrase = "Azzera App";
                });
              }
            },
            child: Text(surePhrase,
                textAlign: TextAlign.center, style: TextStyle(fontSize: 16))));
  }
}
