import 'package:flutter/material.dart';

class LessonEvent {
  LessonEvent(this.eventName, this.classroom, this.from, this.to,
      this.background, this.isAllDay);

  String eventName;
  String classroom;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
