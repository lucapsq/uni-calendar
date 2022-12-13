import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:uni_calendar/models/room.dart';

class CurrentRoomsCalendar extends StatefulWidget {
  final List<Room> rooms;

  const CurrentRoomsCalendar({
    super.key,
    required this.rooms,
  });

  @override
  CurrentRoomsCalendarState createState() => CurrentRoomsCalendarState();
}

class CurrentRoomsCalendarState extends State<CurrentRoomsCalendar> {
  late List<Appointment> _shiftCollection;
  late List<CalendarResource> _roomsCollection;
  late List<String> _nameCollection;
  late _DataSource _events;

  @override
  void initState() {
    _shiftCollection = <Appointment>[];
    _roomsCollection = <CalendarResource>[];
    _addResourceDetails();
    _addResources();
    _addAppointments();
    _events = _DataSource(_shiftCollection, _roomsCollection);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      view: CalendarView.timelineDay,
      allowAppointmentResize: false,
      allowDragAndDrop: false,
      // maxDate: start,
      // minDate: end,

      showDatePickerButton: false,
      showNavigationArrow: false,
      showWeekNumber: false,
      allowedViews: [CalendarView.timelineDay],
      dataSource: _events,
      onTap: null,
      initialDisplayDate: DateTime.now().add(Duration(hours: -1)),
      // resourceViewHeaderBuilder: (context, details) {
      //   return Container(
      //     height: 16,
      //     decoration: BoxDecoration(
      //         color: Colors.green, borderRadius: BorderRadius.circular(16)),
      //     child: Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: Text(details.resource.displayName),
      //     ),
      //   );
      // },
      // cellEndPadding: 36,
      headerHeight: 0,
      viewHeaderHeight: 0,
      resourceViewSettings: ResourceViewSettings(
        // size: 100,
        showAvatar: false,
        visibleResourceCount: 8,
        displayNameTextStyle: TextStyle(
          color: Colors.white,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      appointmentBuilder: (context, calendarAppointmentDetails) {
        Appointment appointment = calendarAppointmentDetails.appointments.first;
        return Container(
          decoration: BoxDecoration(
            color: Colors.lightBlue[100],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              appointment.subject,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
          ),
        );
      },
    );
  }

  void _addResourceDetails() {
    _nameCollection = <String>[];
    _nameCollection.addAll(widget.rooms.map((e) => e.name));
  }

  void _addResources() {
    for (var name in _nameCollection) {
      _roomsCollection.add(CalendarResource(
        displayName: name,
        id: name,
      ));
    }
  }

  void _addAppointments() {
    _shiftCollection = <Appointment>[];
    for (var room in widget.rooms) {
      for (var event in room.events) {
        _shiftCollection.add(
          Appointment(
            startTime: event.start,
            endTime: event.end,
            subject: event.name,
            startTimeZone: '',
            endTimeZone: '',
            resourceIds: [event.room],
          ),
        );
      }
    }
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source, List<CalendarResource> resourceColl) {
    appointments = source;
    resources = resourceColl;
  }
}
