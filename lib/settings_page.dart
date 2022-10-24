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
    return Container(
      color: Colors.grey[100],
      child: Center(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              child: settingsImage,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CourseSelectionPage()),
                  );
                },
                child: Text("Cambia corso")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FilterLessonPage()),
                  );
                },
                child: Text("Filtra lezioni")),
            ElevatedButton(
                onPressed: () async {
                  await resetPreferences();
                },
                child: Text("Reset")),
          ],
        ),
      ),
    );
  }
}
