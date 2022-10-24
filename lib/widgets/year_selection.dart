import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/course.dart';

class YearSelection extends StatefulWidget {
  @override
  State<YearSelection> createState() => _YearSelectionState();
  String selectedCourse;
  List<Course> courses;
  List<String> years;

  YearSelection(this.selectedCourse, this.courses, this.years);
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
          title: Text("UniVR Calendar"),
          centerTitle: true,
        ),
        body: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            Text(
              "Che anni frequenti?",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Card(
                margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
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
              child: Text("Salva"),
            ),
          ],
        ));
  }
}
