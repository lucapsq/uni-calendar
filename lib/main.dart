import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uni_calendar/utilities.dart';
import 'package:uni_calendar/widgets/calendar_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_calendar/widgets/room_availability.dart';
import './models/teaching.dart';
import './configuration_page.dart';

void main() {
  runApp(MaterialApp(home: Homepage()));
}

class Homepage extends StatefulWidget {
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String courseCode = '';
  String courseYear = '';
  String courseYearCode = '';

  Future<Map> fetchCalendar() async {
    var prefs = await SharedPreferences.getInstance();
    print("start");
    if (prefs.getString('courseCode') == null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ConfigurationPage()),
      ).then((value) async {
        print("sono nel then");
        if (value != null) {
          print("sto leggendo le preferenze");
          var prefs = await SharedPreferences.getInstance();

          courseCode = prefs.getString('courseCode').toString();
          courseYear = prefs.getString('courseYear').toString();
          courseYearCode = prefs.getString('courseYearCode').toString();
        }
      });
    } else {
      print("dati già presenti");

      courseCode = prefs.getString('courseCode').toString();
      courseYear = prefs.getString('courseYear').toString();
      courseYearCode = prefs.getString('courseYearCode').toString();
    }

    print("ho letto: $courseCode, $courseYear");
    final now = DateTime.now();
    String today = DateFormat('d-M-y').format(now);
    String nextWeek =
        DateFormat('d-M-y').format(now.add(const Duration(days: 7)));
    List<Teaching> teachingsList = await getTeachingsList(
            today, nextWeek, courseCode, courseYear, courseYearCode)
        as List<Teaching>;

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
    print("ho letto dopo: $courseCode, $courseYear");
    return teachingsMap;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ConfigurationPage()),
              ).then((value) async {
                if (value != null) {
                  var prefs = await SharedPreferences.getInstance();
                  print(value);

                  print("sto risettando");
                  courseCode = prefs.getString('courseCode').toString();
                  courseYear = prefs.getString('courseYear').toString();
                  courseYearCode = prefs.getString('courseYearCode').toString();
                }
              });
            },
            icon: const Icon(Icons.settings),
          ),
        ],
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text("UniVR Calendar"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, RoomAvailability.route());
        },
        label: const Text('Aule libere'),
        icon: const Icon(Icons.meeting_room_rounded),
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
