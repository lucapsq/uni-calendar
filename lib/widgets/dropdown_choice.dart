import 'package:flutter/material.dart';
import 'package:uni_calendar/models/course.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DropdownChoice extends StatefulWidget {
  List<Course> courses;
  List<String> years;
  DropdownChoice(this.courses, this.years);

  @override
  State<DropdownChoice> createState() => _DropdownChoiceState();
}

class _DropdownChoiceState extends State<DropdownChoice> {
  String selectedCourse = 'CENTRO LINGUISTICO DI ATENEO';
  String selectedYear = '1 - Interlingua';

  void updateDropdown() async {
    //controllare
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      //non funziona perchè dropdown items non esiste ancora
      selectedCourse = prefs.getString('courseName').toString();
      selectedYear = prefs.getString('courseYear').toString();
    });
  }

  void savePreferences(String selectedCourse, String selectedYear) async {
    final prefs = await SharedPreferences.getInstance();
    for (var c in widget.courses) {
      if (c.name == selectedCourse) {
        print("sto settando le preferenze");
        await prefs.setString('courseName', c.name);
        await prefs.setString('courseCode', c.id);
        await prefs.setString('courseYear', selectedYear);

        c.valuesMap.forEach(
          (key, value) async {
            if (key == selectedYear) {
              await prefs.setString('courseYearCode', value);
              print("preferenze settate");
            }
          },
        );

        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            "Corso",
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
        ),
        DropdownButtonHideUnderline(
          child: DropdownButton(
            //dropdown dei corsi
            value: selectedCourse,
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
                    widget.years = c.yearsList;
                    selectedYear = widget.years.first;
                  }
                }
              });
            },
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            "Anno",
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
        ),
        DropdownButtonHideUnderline(
          child: DropdownButton(
            //dropdown degli anni
            value: selectedYear,

            onChanged: (newValue) {
              setState(() {
                selectedYear = newValue!;
              });
            },

            isExpanded: true,

            items: widget.years.map((value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        ElevatedButton(
          onPressed: () {
            savePreferences(selectedCourse, selectedYear);
            Navigator.pop(context, 'dummy');
          },
          child: Text("Salva"),
        ),
      ],
    );
  }
}
