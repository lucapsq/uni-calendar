import 'package:flutter/material.dart';
import 'package:uni_calendar/course_selection_page.dart';
import 'package:uni_calendar/filter_zones_page.dart';
import 'package:uni_calendar/widgets/advanced_settings_button.dart';
import 'package:uni_calendar/widgets/filter_lessons_button.dart';

class SettingsPage extends StatelessWidget {
  final Image settingsImage;

  const SettingsPage(this.settingsImage, {super.key});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Container(
      child: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              width: mediaQuery.size.width * 0.7,
              child: settingsImage,
            ),
            const Padding(padding: EdgeInsets.all(20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(
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
                    child: const Text(
                      "Modifica Corso",
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
                        child: const Text(
                          "Modifica Sede",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ))),
                const SizedBox(
                  width: 30,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(
                  width: 30,
                ),
                FilterLessonButton(mediaQuery),
                AdvancedSettingsButton(mediaQuery),
                const SizedBox(
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
