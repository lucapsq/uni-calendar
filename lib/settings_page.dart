import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_calendar/course_selection_page.dart';
import 'package:uni_calendar/filter_lesson_page.dart';
import 'package:uni_calendar/filter_zones_page.dart';
import 'package:uni_calendar/widgets/filter_lessons_button.dart';
import 'package:uni_calendar/widgets/reset_button.dart';

class SettingsPage extends StatelessWidget {
  Image settingsImage;

  SettingsPage(this.settingsImage);

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
              width: mediaQuery.size.width * 0.7,
              child: settingsImage,
            ),
            Padding(padding: EdgeInsets.all(20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 30,
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
                SizedBox(
                    width: mediaQuery.size.height * 0.15,
                    height: mediaQuery.size.height * 0.09,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const FilterZonesPage()),
                          );
                        },
                        child: Text(
                          "Filtra Sedi",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ))),
                SizedBox(
                  width: 30,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 30,
                ),
                FilterLessonButton(mediaQuery),
                ResetButton(mediaQuery),
                SizedBox(
                  width: 30,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
