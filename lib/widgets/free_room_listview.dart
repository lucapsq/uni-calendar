import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../filter_zones_page.dart';
import '../models/event.dart';

class FreeRoomsListview extends StatefulWidget {
  final List<Event> events;
  List<String> rooms;
  final Image noDataImage;
  FreeRoomsListview(this.events, this.rooms, this.noDataImage, {super.key});

  @override
  State<FreeRoomsListview> createState() => _FreeRoomsListviewState();
}

class _FreeRoomsListviewState extends State<FreeRoomsListview> {
  List<CalendarResource> resourceColl = <CalendarResource>[];

  int timeToSeconds(String time) {
    var times = time.split(':');
    return int.parse(times[0]) * 60 + int.parse(times[1]);
  }

  bool isRoomAvailableCheck(String room) {
    var format = DateFormat("HH:mm");
    var now = timeToSeconds(format.format(DateTime.now()));

    List<Event> filteredEvents =
        widget.events.where((element) => element.room == room).toList();
    for (var event in filteredEvents) {
      var start = timeToSeconds(event.start);
      var end = timeToSeconds(event.end);
      if (start < now && end > now) return false;
    }

    return true;
  }

  String isRoomAvailable(String room) {
    var format = DateFormat("HH:mm");
    var now = timeToSeconds(format.format(DateTime.now()));

    List<Event> filteredEvents =
        widget.events.where((element) => element.room == room).toList();
    for (var event in filteredEvents) {
      var start = timeToSeconds(event.start);
      var end = timeToSeconds(event.end);
      if (start < now && end > now) return "Occupata fino alle ${event.end}";
    }
    for (int i = 0; i < filteredEvents.length; i++) {
      var start = timeToSeconds(filteredEvents[i].start);

      if (now < start) {
        return "Disponibile fino alle ${filteredEvents[i].start}";
      }
    }

    return "Disponibile fino al giorno successivo";
  }

  int getRoomPriority(String room) {
    var format = DateFormat("HH:mm");
    var now = timeToSeconds(format.format(DateTime.now()));

    List<Event> filteredEvents =
        widget.events.where((element) => element.room == room).toList();
    for (var event in filteredEvents) {
      var start = timeToSeconds(event.start);
      var end = timeToSeconds(event.end);
      if (start < now && end > now) return 0;
    }
    for (int i = 0; i < filteredEvents.length; i++) {
      var start = timeToSeconds(filteredEvents[i].start);

      if (now < start) {
        return start - now;
      }
    }

    return 0;
  }

  void orderResources() {
    List<CalendarResource> orderedResourceColl = <CalendarResource>[];

    for (int i = 0; i < widget.rooms.length; i++) {
      for (int j = 0; j < resourceColl.length; j++) {
        if (widget.rooms[i] == resourceColl[j].id) {
          orderedResourceColl.add(resourceColl[j]);
          break;
        }
      }
    }

    resourceColl = orderedResourceColl;
  }

  void orderRooms() {
    List<String> unavailableRooms = [];
    List<String> availableRooms = [];

    Map<String, int> roomsPriority = {};

    for (var r in widget.rooms) {
      if (isRoomAvailableCheck(r)) {
        if (getRoomPriority(r) != 0) {
          roomsPriority.addAll({r: getRoomPriority(r)});
        }
        if (getRoomPriority(r) == 0) {
          availableRooms.add(r);
        }
      } else {
        unavailableRooms.add(r);
      }
    }
    int max = 0;
    String room = "";
    int l = roomsPriority.length;

    for (int i = 0; i < l; i++) {
      roomsPriority.forEach((key, value) {
        if (value > max) {
          max = value;
          room = key;
        }
      });
      max = 0;
      roomsPriority.remove(room);
      availableRooms.add(room);
    }

    widget.rooms = availableRooms + unavailableRooms;
  }

  DateTime stringToDateTime(String time) {
    String dayString = DateTime.now().toString().substring(0, 10);
    return DateTime.parse("$dayString $time");
  }

  _RoomDataSource _getCalendarDataSource() {
    List<Appointment> appointments = <Appointment>[];
    for (int i = 0; i < widget.events.length; i++) {
      appointments.add(Appointment(
        startTime: stringToDateTime(widget.events[i].start),
        endTime: stringToDateTime(widget.events[i].end),
        subject: widget.events[i].name,
        color: Colors.lightBlue,
        startTimeZone: '',
        endTimeZone: '',
        resourceIds: [widget.events[i].room],
      ));
      if (!resourceColl.contains(CalendarResource(
        displayName: widget.events[i].room,
        id: widget.events[i].room,
      )))
        resourceColl.add(CalendarResource(
          displayName: widget.events[i].room,
          id: widget.events[i].room,
        ));
    }

    orderResources();

    return _RoomDataSource(appointments, resourceColl);
  }

  bool fullView = false;
  @override
  Widget build(BuildContext context) {
    orderRooms();

    return widget.rooms.isEmpty
        ? Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    padding: const EdgeInsets.fromLTRB(0, 100, 0, 30),
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: widget.noDataImage),
                Text(
                  "Nessuna sede impostata!",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.height * 0.18,
                    height: MediaQuery.of(context).size.height * 0.08,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const FilterZonesPage()),
                          );
                        },
                        child: const Text(
                          "Aggiungi Sede",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ))),
              ],
            ),
          )
        : SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: Column(
              children: [
                Container(
                  //color: Colors.red,
                  padding: const EdgeInsets.fromLTRB(0, 5, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Vista completa",
                        style: TextStyle(fontSize: 18),
                      ),
                      Switch(
                          value: fullView,
                          onChanged: (val) {
                            setState(() {
                              fullView = val;
                            });
                          })
                    ],
                  ),
                ),
                fullView
                    ? Expanded(
                        child: SfCalendar(
                          minDate: stringToDateTime("00:00"),
                          maxDate: stringToDateTime("23:59"),
                          headerHeight: 0,
                          viewHeaderHeight: 0,
                          view: CalendarView.timelineDay,
                          allowDragAndDrop: false,
                          initialDisplayDate:
                              DateTime.now().add(Duration(hours: -1)),
                          resourceViewSettings: ResourceViewSettings(
                            visibleResourceCount: 6,
                          ),
                          resourceViewHeaderBuilder: (context, details) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 2),
                              child: Column(
                                //mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    details.resource.displayName,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                ],
                              ),
                            );
                          },
                          /*appointmentBuilder:
                              (context, calendarAppointmentDetails) {
                            return Container(
                              height: calendarAppointmentDetails.bounds.height,
                              color: Colors.red,
                            );
                          },*/
                          dataSource: _getCalendarDataSource(),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        height: MediaQuery.of(context).size.height * 0.65,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          elevation: 7,
                          child: ListView.builder(
                              itemBuilder: (context, i) => Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(widget.rooms[i],
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge),
                                        Text(
                                          isRoomAvailable(widget.rooms[i]),
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: isRoomAvailableCheck(
                                                      widget.rooms[i])
                                                  ? Colors.green
                                                  : Colors.red,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                              itemCount: widget.rooms.length),
                        ),
                      ),
              ],
            ),
          );
  }
}

class _RoomDataSource extends CalendarDataSource {
  _RoomDataSource(
      List<Appointment> source, List<CalendarResource> resourceColl) {
    appointments = source;

    resources = resourceColl;
  }
}
