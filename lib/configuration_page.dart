import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

import './models/course.dart';
import './widgets/dropdown_choice.dart';

class ConfigurationPage extends StatefulWidget {
  const ConfigurationPage({super.key});

  @override
  State<ConfigurationPage> createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  List<String> years = [];
  List<Course> courses = [];

  Future<List<Course>> fetchCourses() async {
    var response = await http.get(Uri.parse(
        "https://logistica.univr.it/PortaleStudentiUnivr/combo.php?sw=ec_&aa=2022&page=corsi&_="));
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
        years.add(v['label']);
        yearsvalues.addAll({v['label']: v['valore']});
      }

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
        backgroundColor: Colors.blue,
        title: const Text("UniVR Calendar"),
        centerTitle: true,
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
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: const Image(
                        image: AssetImage('assets/student.png'),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.07,
                    ),
                    DropdownChoice(courses, years),
                  ],
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
