import 'package:flutter/material.dart';
import 'package:uni_calendar/models/course.dart';
import 'package:uni_calendar/widgets/year_selection.dart';

class CourseSelection extends StatefulWidget {
  final List<Course> courses;
  final List<String> years;
  final Image yearSelectionImage;
  const CourseSelection(this.courses, this.years, this.yearSelectionImage,
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
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        DropdownButtonHideUnderline(
          child: DropdownButton(
            dropdownColor: Theme.of(context).primaryColor,
            menuMaxHeight: MediaQuery.of(context).size.height * 0.5,
            value: selectedCourse,
            hint: Text(
              "- Seleziona -",
              style: Theme.of(context).textTheme.subtitle1,
            ),
            itemHeight: 60,
            isExpanded: true,
            items: widget.courses.map((Course value) {
              return DropdownMenuItem<String>(
                value: value.name,
                child: Text(
                  value.name,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
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
