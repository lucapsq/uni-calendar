import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../models/lessonEvent.dart';
import '../models/lessonDataSource.dart';

class CalendarLessonsListView extends StatelessWidget {
  Function getTeachingList;
  DateTime selectedDay;

  CalendarLessonsListView(this.getTeachingList, this.selectedDay, {super.key});

  List<LessonEvent> _getDataSource() {
    final List<LessonEvent> events = <LessonEvent>[];
    for (var e in getTeachingList()) {
      String startTimeString = e.time.toString().substring(0, 5);
      String endTimeString = e.time.toString().substring(8);

      int startHour = int.parse(startTimeString.substring(0, 2));
      int startMinute = int.parse(startTimeString.substring(3, 5));

      int endHour = int.parse(endTimeString.substring(0, 2));
      int endMinute = int.parse(endTimeString.substring(3, 5));

      final DateTime startDate = DateTime(selectedDay.year, selectedDay.month,
          selectedDay.day, startHour, startMinute, 0);

      final DateTime endDate = DateTime(selectedDay.year, selectedDay.month,
          selectedDay.day, endHour, endMinute, 0);

      events.add(
          LessonEvent(e.name, e.classroom, startDate, endDate, e.color, false));
    }

    return events;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: SfCalendar(
            
            appointmentBuilder: (context, calendarAppointmentDetails) {
              return Container(
                  color:
                      calendarAppointmentDetails.appointments.first.background,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                          child: Text(
                            calendarAppointmentDetails
                                .appointments.first.eventName,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                        FittedBox(
                          child: Text(
                            calendarAppointmentDetails
                                .appointments.first.classroom,
                            style: const TextStyle(fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  ));
            },
            view: CalendarView.day,
            headerHeight: 0,
            viewHeaderHeight: 0,
            minDate: DateTime(
                selectedDay.year, selectedDay.month, selectedDay.day, 6, 0, 0),
            maxDate: DateTime(
                selectedDay.year, selectedDay.month, selectedDay.day, 21, 0),
            timeSlotViewSettings: const TimeSlotViewSettings(
                startHour: 6, endHour: 21, timeIntervalHeight: 70),
            dataSource: LessonDataSource(_getDataSource())));
  }
}
