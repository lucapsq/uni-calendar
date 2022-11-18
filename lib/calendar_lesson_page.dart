import 'package:flutter/material.dart';
import 'package:uni_calendar/models/teaching.dart';
import 'package:uni_calendar/widgets/calendar_lessons_listview.dart';
import 'package:uni_calendar/widgets/singlecard_calendar_header_day.dart';
import 'package:uni_calendar/widgets/no_lessons.dart';

class CalendarView extends StatefulWidget {
  final Map data;
  final Function getFormattedDate;
  const CalendarView(this.data, this.getFormattedDate, {super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  late Image nolessonImage;
  @override
  initState() {
    super.initState();
    nolessonImage = const Image(
      image: AssetImage('assets/happy.png'),
    );
  }

  @override
  void didChangeDependencies() {
    precacheImage(nolessonImage.image, context);
    super.didChangeDependencies();
  }

  List<Teaching> getTeachingList() {
    String selectedDayString = widget.getFormattedDate(selectedDay);
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
      today = today.add(const Duration(days: 1));
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.12,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
            color: Theme.of(context).primaryColor,
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
        getTeachingList().isEmpty
            ? NoLessons(nolessonImage)
            : CalendarLessonsListView(getTeachingList, selectedDay)
      ],
    );
  }
}
