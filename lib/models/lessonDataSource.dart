import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:uni_calendar/models/lessonEvent.dart';
import 'package:flutter/material.dart';

class LessonDataSource extends CalendarDataSource {
  LessonDataSource(List<LessonEvent> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}
