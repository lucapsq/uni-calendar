import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uni_calendar/api/get_teachinglist.dart';
import 'package:uni_calendar/widgets/calendar_lesson_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './models/teaching.dart';
import 'course_selection_page.dart';

class LessonsPage extends StatefulWidget {
  const LessonsPage({super.key});

  @override
  State<LessonsPage> createState() => _LessonsPageState();
}

class _LessonsPageState extends State<LessonsPage> {
  String courseCode = '';
  List<String> courseYearList = [];
  List<String> courseYearCodeList = [];
  List<String> excludedLessonList = [];

  SharedPreferences? sharedPreferences;

  Future<Map> fetchCalendar() async {
    final now = DateTime.now();
    String today = DateFormat('d-M-y').format(now);
    String nextWeek =
        DateFormat('d-M-y').format(now.add(const Duration(days: 7)));
    List<Teaching> teachingsList = await getTeachingsList(
      today,
      nextWeek,
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
      if (value != null) {
        setState(() {
          courseCode = sharedPreferences!.getString('courseCode').toString();
          courseYearList = sharedPreferences!.getStringList('courseYear')!;
          courseYearCodeList =
              sharedPreferences!.getStringList('courseYearCode')!;
          excludedLessonList =
              sharedPreferences!.getStringList('excludedLessonList')!;
        });
        fetchCalendar();
      }
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
        courseCode = sharedPreferences!.getString('courseCode').toString()!;
        courseYearList = sharedPreferences!.getStringList('courseYear')!;
        courseYearCodeList =
            sharedPreferences!.getStringList('courseYearCode')!;
        excludedLessonList =
            sharedPreferences!.getStringList('excludedLessonList')!;
      });

      fetchCalendar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchCalendar(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map? data = snapshot.data;

            return Container(
              color: Colors.grey[100],
              child: CalendarView(data!),
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}
