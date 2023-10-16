import 'package:flutter/material.dart';
import 'package:uni_calendar/api/get_teachinglist.dart';
import 'package:uni_calendar/calendar_lesson_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './models/teaching.dart';
import 'course_selection_page.dart';

class LessonsPage extends StatefulWidget {
  const LessonsPage({super.key});

  @override
  State<LessonsPage> createState() => _LessonsPageState();
}

class _LessonsPageState extends State<LessonsPage> {
  String getFormattedDate(DateTime now) {
    String dayString = "";
    String day = "";
    String month = "";
    String year = "";

    if (now.day < 10) {
      day = "0${now.day}";
    } else {
      day = now.day.toString();
    }

    if (now.month < 10) {
      month = "0${now.month}";
    } else {
      month = now.month.toString();
    }

    year = now.year.toString();

    dayString = "$day-$month-$year";

    return dayString;
  }

  String courseCode = '';
  List<String> courseYearList = [];
  List<String> courseYearCodeList = [];
  List<String> excludedLessonList = [];

  SharedPreferences? sharedPreferences;

  Future<Map> fetchCalendar(DateTime now) async {
    String today = getFormattedDate(now);

    List<Teaching> teachingsList = await getTeachingsList(
      now,
      today,
      courseCode,
      courseYearList,
      courseYearCodeList,
      excludedLessonList,
    );

    String selectedDate = today;
    List<Teaching> dayTeachingList = [];
    Map teachingsMap = <String, List<Teaching>>{};

    for (var c in teachingsList) {
      if (c.date == selectedDate) {
        dayTeachingList.add(c);
      }

      if (c.date != selectedDate) {
        final dayTeaching = <String, List<Teaching>>{
          selectedDate: dayTeachingList,
        };

        teachingsMap.addEntries(dayTeaching.entries);

        dayTeachingList = [];
        dayTeachingList.add(c);
        selectedDate = c.date;
      }
    }
    final dayTeaching = <String, List<Teaching>>{
      selectedDate: dayTeachingList,
    };

    teachingsMap.addEntries(dayTeaching.entries);

    return teachingsMap;
  }

  @override
  void initState() {
    super.initState();
    initCourse();
  }

  selectCourse() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CourseSelectionPage()),
    ).then((value) async {
      var prefs = await SharedPreferences.getInstance();

      if (prefs.getString('courseCode') != null &&
          prefs.getStringList('courseYear') != null) {
        setState(() {
          courseCode = prefs.getString('courseCode').toString();
          courseYearList = prefs.getStringList('courseYear')!;
          courseYearCodeList = prefs.getStringList('courseYearCode')!;
        });
      }
      if (prefs.getStringList('excludedLessonList') != null) {
        setState(() {
          excludedLessonList = prefs.getStringList('excludedLessonList')!;
        });
      }
      if (prefs.getString('courseCode') == null ||
          prefs.getStringList('courseYear') == null ||
          prefs.getStringList('courseYearCode') == null) {
        selectCourse();
      }
      fetchCalendar(DateTime.now());
    });
  }

  initCourse() async {
    var prefs = await SharedPreferences.getInstance();
    setState(() => sharedPreferences = prefs);

    String? code = prefs.getString('courseCode');
    if (code == null) {
      selectCourse();
    } else {
      setState(() {
        courseCode = sharedPreferences!.getString('courseCode').toString();
        courseYearList = sharedPreferences!.getStringList('courseYear')!;
        courseYearCodeList =
            sharedPreferences!.getStringList('courseYearCode')!;
        if (sharedPreferences?.getStringList('excludedLessonList') != null) {
          excludedLessonList =
              sharedPreferences!.getStringList('excludedLessonList')!;
        } else {
          excludedLessonList = [];
        }
      });

      fetchCalendar(DateTime.now() /*.subtract(Duration(days: 7))*/);
    }
  }

  DateTime date = DateTime.now() /*.subtract(Duration(days: 7))*/;

  bool containsSelectedDay(Map data) {
    for (var key in data.keys) {
      if (key == getFormattedDate(date)) {
        return true;
      }
    }
    return false;
  }

  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchCalendar(date),
        builder: (context, snapshot) {
          Map? data = snapshot.data;

          if (snapshot.hasData && containsSelectedDay(data!)) {
            data = snapshot.data;
            return Container(
              child: CalendarView(data!, getFormattedDate, (DateTime sd) {
                selectedDate = sd;
                setState(() {
                  date = sd;
                });
              }, selectedDate),
            );
          }

          return const Center(child: CircularProgressIndicator());
        });
  }
}
