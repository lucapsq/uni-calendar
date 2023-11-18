import 'package:flutter/material.dart';
import 'package:uni_calendar/models/teaching.dart';
import 'package:uni_calendar/widgets/calendar_lessons_listview.dart';
import 'package:uni_calendar/widgets/month_header.dart';
import 'package:uni_calendar/widgets/week_header.dart';
import 'package:uni_calendar/widgets/no_lessons.dart';

class CalendarView extends StatefulWidget {
  final Map data;
  final Function getFormattedDate;
  DateTime selectedDay;
  Function updateDate;
  CalendarView(
      this.data, this.getFormattedDate, this.updateDate, this.selectedDay,
      {super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  late Image nolessonImage;
  late DateTime selectedDay;

  @override
  initState() {
    super.initState();
    nolessonImage = const Image(
      image: AssetImage('assets/happy.png'),
    );
    selectedDay = widget.selectedDay;
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

  var _first = CrossFadeState.showFirst;

  @override
  Widget build(BuildContext context) {
    DateTime today = widget.selectedDay;
    List<DateTime> weekView = [];

    for (int i = 0; i < 6; i++) {
      weekView.add(today.add(Duration(days: i)));
    }

    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: [
        getTeachingList().isEmpty
            ? NoLessons(nolessonImage)
            : CalendarLessonsListView(getTeachingList, selectedDay),
        GestureDetector(
          onPanUpdate: (details) {
            if (details.delta.dy > 5) {
              setState(() {
                _first = CrossFadeState.showSecond;
              });
            }
            if (details.delta.dy < -5) {
              setState(() {
                _first = CrossFadeState.showFirst;
              });
            }
          },
          child: AnimatedCrossFade(
            firstChild: WeekHeader(
              weekView,
              (DateTime sd) {
                setState(() {
                  selectedDay = sd;
                  today = sd;
                });
              },
              selectedDay,
            ),
            secondChild: MonthHeader(
              selectedDay,
              (DateTime sd) {
                setState(() {
                  widget.updateDate(sd);
                  selectedDay = sd;
                  today = sd;
                  _first = CrossFadeState.showFirst;
                });
              },
            ),
            duration: Duration(milliseconds: 80),
            crossFadeState: _first,
          ),
        ),
      ],
    );
  }
}
