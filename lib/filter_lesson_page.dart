import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FilterLessonPage extends StatefulWidget {
  const FilterLessonPage({super.key});

  @override
  State<FilterLessonPage> createState() => _FilterLessonPageState();
}

class _FilterLessonPageState extends State<FilterLessonPage> {
  List<String> checkedItems = []; //contiene lezioni da eliminare

  Future<void> getExcludedLessons() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getStringList('excludedLessonList') != null) {
      checkedItems = prefs.getStringList('excludedLessonList')!;
    }
  }

  late Image filterLessonsImage;

  @override
  void didChangeDependencies() {
    precacheImage(filterLessonsImage.image, context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

    getExcludedLessons();
    filterLessonsImage = Image.asset("assets/filter-lessons.png");
  }

  Future<List<String>> fetchLessons() async {
    final prefs = await SharedPreferences.getInstance();

    String courseCode = prefs.getString('courseCode').toString();
    List<String>? courseYearList = prefs.getStringList('courseYear');

    var response = await http.get(Uri.parse(
        "https://logistica.univr.it/PortaleStudentiUnivr/combo.php?sw=ec_&aa=2022&page=corsi&_="));
    String data = response.body.toString();

    data = data.substring(19);
    data = data.substring(0, data.length - 60);

    List dataList = jsonDecode(
        data); //metto tutti i dati in una lista per facilitare la lettura

    List<String> lessons = [];

    for (var course in dataList) {
      if (course['valore'] == courseCode) {
        for (var v in course['elenco_anni']) {
          if (courseYearList!.contains(v['label']))
            for (var i in v['elenco_insegnamenti']) {
              lessons.add(i['label']); //materie

            }
        }
      }
    }
    return lessons;
  }

  Future<void> savePreferences(List<String> checkedItems) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList('excludedLessonList', checkedItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("UniVR Calendar"),
      ),
      body: FutureBuilder(
        future: fetchLessons(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var lessons = snapshot.data;
            return Column(
              children: [
                Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: filterLessonsImage),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "ciao",
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: Card(
                    margin: EdgeInsets.fromLTRB(30, 0, 30, 10),
                    child: ListView.builder(
                        itemCount: lessons!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CheckboxListTile(
                            value: !checkedItems.contains(lessons[index]),
                            onChanged: (newValue) {
                              if (checkedItems.contains(lessons[index])) {
                                setState(() {
                                  checkedItems.remove(lessons[index]);
                                });
                              } else if (!checkedItems
                                  .contains(lessons[index])) {
                                setState(() {
                                  checkedItems.add(lessons[index]);
                                });
                              }
                            },
                            title: Text(lessons[index]),
                          );
                        }),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await savePreferences(checkedItems);
                    //Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: Text("Salva"),
                ),
              ],
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
