import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_calendar/course_selection_page.dart';
import 'package:uni_calendar/filter_lesson_page.dart';

class SettingsPage extends StatelessWidget {
  Image settingsImage;

  SettingsPage(this.settingsImage);

  Future<void> resetPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('courseCode');
    await prefs.remove('courseYear');
    await prefs.remove('courseYearCode');
    await prefs.remove('excludedLessonList');
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Container(
      color: Colors.grey[100],
      child: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              width: MediaQuery.of(context).size.width * 0.7,
              child: settingsImage,
            ),
            SizedBox(
              width: mediaQuery.size.height * 0.15,
              height: mediaQuery.size.height * 0.09,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CourseSelectionPage()),
                  );
                },
                child: Text(
                  "Modifica corso",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                width: mediaQuery.size.height * 0.15,
                height: mediaQuery.size.height * 0.09,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FilterLessonPage()),
                      );
                    },
                    child: Text(
                      "Filtra lezioni",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ))),
            SizedBox(
                width: mediaQuery.size.height * 0.15,
                height: mediaQuery.size.height * 0.09,
                child: ElevatedButton(
                    onPressed: () async {
                      await resetPreferences();
                    },
                    child: Text("Azzera App",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16)))),
          ],
        ),
      ),
    );
  }
}
