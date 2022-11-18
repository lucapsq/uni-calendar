import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/course.dart';

class YearSelection extends StatefulWidget {
  @override
  State<YearSelection> createState() => _YearSelectionState();
  final String selectedCourse;
  final List<Course> courses;
  final List<String> years;
  final Image yearSelectionImage;

  const YearSelection(
      this.selectedCourse, this.courses, this.years, this.yearSelectionImage,
      {super.key});
}

class _YearSelectionState extends State<YearSelection> {
  List<String> checkedItems = [];

  Future<void> savePreferences(
      String selectedCourse, List<String> selectedYears) async {
    List<String> courseYearCode = [];
    final prefs = await SharedPreferences.getInstance();
    for (var c in widget.courses) {
      if (c.name == selectedCourse) {
        await prefs.setString('courseName', c.name);
        await prefs.setString('courseCode', c.id);
        await prefs.setStringList('courseYear', selectedYears);

        c.valuesMap.forEach(
          (key, value) async {
            if (selectedYears.contains(key)) {
              courseYearCode.add(value);
            }
          },
        );
      }
      await prefs.setStringList('courseYearCode', courseYearCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("UniVR Calendar"),
        ),
        body: Column(
          children: [
            Container(
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 50),
                width: MediaQuery.of(context).size.width * 0.35,
                child: widget.yearSelectionImage),
            Text(
              "Che anni frequenti?",
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
              child: Card(
                margin: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                child: ListView.builder(
                    itemCount: widget.years.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CheckboxListTile(
                        value: checkedItems.contains(widget.years[index]),
                        onChanged: (newValue) {
                          if (checkedItems.contains(widget.years[index])) {
                            setState(() {
                              checkedItems.remove(widget.years[index]);
                            });
                          } else if (!checkedItems
                              .contains(widget.years[index])) {
                            setState(() {
                              checkedItems.add(widget.years[index]);
                            });
                          }
                        },
                        title: Text(widget.years[index]),
                      );
                    }),
              ),
            ),
            ElevatedButton(
              onPressed: checkedItems.isEmpty
                  ? null
                  : () async {
                      await savePreferences(
                          widget.selectedCourse, checkedItems);
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
              child: const Text("Salva"),
            ),
          ],
        ));
  }
}
