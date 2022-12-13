// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_calendar/calendar.dart';
// import 'package:uni_calendar/models/event.dart';

// // class EventDataSource extends CalendarDataSource {
// //   EventDataSource(List<Event> source) {
// //     appointments = source;
// //   }
// // }

// class EventDataSource extends CalendarDataSource {
//   EventDataSource(this.source);

//   List<Event> source;

//   @override
//   List<Event> get appointments => source;

//   @override
//   DateTime getStartTime(int index) {
//     List<int> raws = source[index]
//         .start
//         .split(":")
//         .map((e) => int.tryParse(e) ?? 0)
//         .toList();
//     TimeOfDay t = TimeOfDay(hour: raws[0], minute: raws[1]);
//     DateTime now = new DateTime.now();
//     return new DateTime(now.year, now.month, now.day, t.hour, t.minute);
//   }

//   @override
//   DateTime getEndTime(int index) {
//     List<int> raws =
//         source[index].end.split(":").map((e) => int.tryParse(e) ?? 0).toList();
//     TimeOfDay t = TimeOfDay(hour: raws[0], minute: raws[1]);
//     DateTime now = new DateTime.now();
//     return new DateTime(now.year, now.month, now.day, t.hour, t.minute);
//   }

//   @override
//   bool isAllDay(int index) {
//     return false;
//   }

//   @override
//   String getSubject(int index) {
//     return source[index].name;
//   }

//   @override
//   List<Object>? getResourceIds(int index) {
//     // Set<String> rooms = Set<String>();
//     // for (var room in source) {
//     //   rooms.add(room.room);
//     // }
//     // return rooms.toList();
//   }

//   @override
//   List<CalendarResource>? get resources {
//     return source
//         .map((e) => e.room)
//         .toSet()
//         .map((e) => CalendarResource(id: e))
//         .toList();
//   }

//   // @override
//   // String? getStartTimeZone(int index) {
//   //   return source[index].start;
//   // }

//   // @override
//   // String? getEndTimeZone(int index) {
//   //   return source[index].end;
//   // }

//   // @override
//   // String? getRecurrenceRule(int index) {
//   //   return source[index].recurrenceRule;
//   // }
// }
