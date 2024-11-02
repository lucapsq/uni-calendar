import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../models/lessonEvent.dart';
import '../models/lessonDataSource.dart';

class CalendarLessonsListView extends StatelessWidget {
  final Function getTeachingList;
  final DateTime selectedDay;

  const CalendarLessonsListView(this.getTeachingList, this.selectedDay,
      {super.key});

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

      int duration = endDate.difference(startDate).inHours;

      events.add(LessonEvent(
          e.name, e.classroom, startDate, endDate, duration, e.color));
    }

    return events;
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
        cellBorderColor: Theme.of(context).primaryColorDark,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        initialDisplayDate: _isSameDay(selectedDay, DateTime.now())
            ? DateTime(
                selectedDay.year,
                selectedDay.month,
                selectedDay.day,
                selectedDay.subtract(const Duration(hours: 3)).hour,
              )
            : DateTime(
                selectedDay.year,
                selectedDay.month,
                selectedDay.day,
                6,
              ),
        appointmentBuilder: (context, calendarAppointmentDetails) {
          int duration = calendarAppointmentDetails.appointments.first.duration;
          return Container(
              color: calendarAppointmentDetails.appointments.first.background,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      calendarAppointmentDetails.appointments.first.eventName,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: duration == 1
                          ? 1
                          : duration == 2
                              ? 3
                              : 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Expanded(
                      child: Text(
                        calendarAppointmentDetails.appointments.first.classroom,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                      ),
                    ),
                  ],
                ),
              ));
        },
        view: CalendarView.day,
        headerHeight: 0,
        viewHeaderHeight: 0,
        minDate: DateTime(
            selectedDay.year, selectedDay.month, selectedDay.day, 5, 0, 0),
        maxDate: DateTime(
            selectedDay.year, selectedDay.month, selectedDay.day, 21, 0),
        timeSlotViewSettings: TimeSlotViewSettings(
            startHour: 5,
            endHour: 21,
            timeIntervalHeight: 75,
            timeTextStyle: Theme.of(context).textTheme.bodySmall),
        dataSource: LessonDataSource(_getDataSource()));
  }
}
