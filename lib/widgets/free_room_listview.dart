import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/event.dart';

class FreeRoomsListview extends StatelessWidget {
  final List<Event> events;
  List<String> rooms;
  final Image noDataImage;
  FreeRoomsListview(this.events, this.rooms, this.noDataImage, {super.key});

  int timeToSeconds(String time) {
    var times = time.split(':');
    return int.parse(times[0]) * 60 + int.parse(times[1]);
  }

  bool isRoomAvailableCheck(String room) {
    var format = DateFormat("HH:mm");
    var now = timeToSeconds(format.format(DateTime.now()));

    List<Event> filteredEvents =
        events.where((element) => element.room == room).toList();
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
        events.where((element) => element.room == room).toList();
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
        events.where((element) => element.room == room).toList();
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

  void orderRooms() {
    List<String> unavailableRooms = [];
    List<String> availableRooms = [];

    Map<String, int> roomsPriority = {};

    for (var r in rooms) {
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

    rooms = availableRooms + unavailableRooms;
  }

  @override
  Widget build(BuildContext context) {
    orderRooms();
    return rooms.isEmpty
        ? Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    padding: const EdgeInsets.fromLTRB(0, 100, 0, 30),
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: noDataImage),
                Text(
                  "Nessuna sede impostata!",
                  style: Theme.of(context).textTheme.headline6,
                )
              ],
            ),
          )
        : SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Text(
                  "Aule libere",
                  style: Theme.of(context).textTheme.headline5,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(rooms[i],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1),
                                  Text(
                                    isRoomAvailable(rooms[i]),
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: isRoomAvailableCheck(rooms[i])
                                            ? Colors.green
                                            : Colors.red,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                        itemCount: rooms.length),
                  ),
                ),
              ],
            ),
          );
  }
}
