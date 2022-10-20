import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_calendar/models/teaching.dart';
import 'package:uni_calendar/widgets/calendar_listview.dart';
import 'package:uni_calendar/widgets/card_calendar.dart';
import 'package:uni_calendar/widgets/no_lessons.dart';
import '../models/teaching.dart';
import 'package:intl/intl.dart';

class CalendarView extends StatefulWidget {
  Map data;
  CalendarView(this.data);

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  var nolessonImage;
  @override
  initState() {
    nolessonImage = Image(
      image: AssetImage('assets/happy.png'),
      fit: BoxFit.fitWidth,
    );
  }

  List<Teaching> getTeachingList() {
    String selectedDayString = DateFormat('d-M-y').format(selectedDay);
    if (widget.data[selectedDayString] == null) return [];
    return widget.data[selectedDayString];
  }

  DateTime selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    List<DateTime> weekView = [];
    for (int i = 0; i < 6; i++) {
      weekView.add(today);
      today = today.add(Duration(days: 1));
    }

    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.12,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var d in weekView)
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDay = d;
                      });
                    },
                    child: CardCalendar(d, selectedDay),
                  ),
                ),
            ],
          ),
        ),
        getTeachingList().length == 0
            ? NoLessons(nolessonImage)
            : CalendarListView(getTeachingList)
      ],
    );
  }
}
