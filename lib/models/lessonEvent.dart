import 'package:flutter/material.dart';

class LessonEvent {
  LessonEvent(this.eventName, this.classroom, this.from, this.to, this.duration,
      this.background);

  String eventName;
  String classroom;
  DateTime from;
  DateTime to;
  int duration;
  Color background;
}
