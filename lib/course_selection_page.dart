import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

import './models/course.dart';
import 'widgets/course_selection.dart';

class CourseSelectionPage extends StatefulWidget {
  const CourseSelectionPage({super.key});

  @override
  State<CourseSelectionPage> createState() => _CourseSelectionPageState();
}

class _CourseSelectionPageState extends State<CourseSelectionPage> {
  List<String> years = [];
  List<Course> courses = [];

  late Image studentImage;
  late Image yearSelectionImage;

  @override
  void initState() {
    super.initState();
    studentImage = Image.asset("assets/student.png");
    yearSelectionImage = Image.asset("assets/year-select.png");
  }

  @override
  void didChangeDependencies() {
    precacheImage(studentImage.image, context);
    precacheImage(yearSelectionImage.image, context);
    super.didChangeDependencies();
  }

  Future<List<Course>> fetchCourses() async {
    DateTime todayDateTime = DateTime.now();
    var year;
    if (todayDateTime.month >= 8 && todayDateTime.month <= 12) {
      year = todayDateTime.year.toString();
    } else {
      year = (todayDateTime.year - 1).toString();
    }

    var response = await http.get(Uri.parse(
        "https://logistica.univr.it/PortaleStudentiUnivr/combo.php?sw=ec_&aa=$year&page=corsi&_="));
    String data = response.body.toString();

    data = data.substring(19);
    data = data.substring(0, data.length - 60);

    List dataList = jsonDecode(
        data); //metto tutti i dati in una lista per facilitare la lettura

    List<Course> courses = [];

    for (var course in dataList) {
      List<String> years = [];
      Map<String, String> yearsvalues = {};

      for (var v in course['elenco_anni']) {
        //print(v['label'] + v['valore']); 1 - Lingua tedesca B2 TEDB2|1
        if (!years.contains(v['label'])) years.add(v['label']);

        yearsvalues.addAll({v['label']: v['valore']});
      }
      //print(course['label'] + course['valore']);

      courses.add(Course(
          id: course['valore'],
          name: course['label'],
          yearsList: years,
          valuesMap: yearsvalues));
    }

    return courses;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Seleziona corso"),
      ),
      body: FutureBuilder(
          future: fetchCourses(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              courses = snapshot.data!;
              years = snapshot.data![0].yearsList;

              return Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  children: [
                    Container(
                        margin: const EdgeInsets.fromLTRB(0, 20, 0, 50),
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: studentImage),
                    CourseSelection(courses, years, yearSelectionImage),
                  ],
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
