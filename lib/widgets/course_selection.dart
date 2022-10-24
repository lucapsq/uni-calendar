import 'package:flutter/material.dart';
import 'package:uni_calendar/models/course.dart';
import 'package:uni_calendar/widgets/year_selection.dart';

class CourseSelection extends StatefulWidget {
  List<Course> courses;
  List<String> years;
  Image yearSelectionImage;
  CourseSelection(this.courses, this.years, this.yearSelectionImage,
      {super.key});

  @override
  State<CourseSelection> createState() => _CourseSelectionState();
}

class _CourseSelectionState extends State<CourseSelection> {
  String? selectedCourse;

  Map<String, bool> createMap(List<String> years) {
    Map<String, bool> yearsMap = {};
    for (var y in years) {
      yearsMap.addAll({y: false});
    }

    return yearsMap;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(
            "Che corso frequenti?",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        DropdownButtonHideUnderline(
          child: DropdownButton(
            value: selectedCourse,
            hint: Text("- Seleziona -"),
            itemHeight: 60,
            isExpanded: true,
            items: widget.courses.map((Course value) {
              return DropdownMenuItem<String>(
                value: value.name,
                child: Text(value.name),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                selectedCourse = newValue!;

                for (Course c in widget.courses) {
                  if (newValue == c.name) {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => YearSelection(
                            newValue,
                            widget.courses,
                            c.yearsList,
                            widget.yearSelectionImage),
                      ),
                    );
                    ;
                  }
                }
              });
            },
          ),
        ),
      ],
    );
  }
}
