import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uni_calendar/utilities.dart';
import 'package:uni_calendar/widgets/calendar_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './models/teaching.dart';
import './configuration_page.dart';

void main() {
  runApp(
    const MaterialApp(
      home: Homepage(),
    ),
  );
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String courseCode = '';
  String courseYear = '';
  String courseYearCode = '';

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
      courseYear,
      courseYearCode,
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
      MaterialPageRoute(builder: (context) => const ConfigurationPage()),
    ).then((value) async {
      if (value != null) {
        setState(() {
          courseCode = sharedPreferences!.getString('courseCode').toString();
          courseYear = sharedPreferences!.getString('courseYear').toString();
          courseYearCode =
              sharedPreferences!.getString('courseYearCode').toString();
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
        courseCode = sharedPreferences!.getString('courseCode').toString();
        courseYear = sharedPreferences!.getString('courseYear').toString();
        courseYearCode =
            sharedPreferences!.getString('courseYearCode').toString();
      });

      fetchCalendar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: selectCourse,
            icon: const Icon(Icons.settings),
          ),
        ],
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          "UniVR Calendar",
        ),
      ),
      body: FutureBuilder(
          future: fetchCalendar(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Map? data = snapshot.data;

              return Container(
                color: Colors.grey[300],
                child: CalendarView(data!),
              );
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
