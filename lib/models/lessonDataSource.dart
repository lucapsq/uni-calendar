import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:uni_calendar/models/lessonEvent.dart';
import 'package:flutter/material.dart';

class LessonDataSource extends CalendarDataSource {
  LessonDataSource(List<LessonEvent> source) {
    appointments = source;
  }
}
