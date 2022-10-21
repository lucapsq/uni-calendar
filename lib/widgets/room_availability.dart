import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uni_calendar/api/get_events.dart';
import 'package:uni_calendar/models/event.dart';
import 'package:uni_calendar/models/zone.dart';

class RoomAvailability extends StatefulWidget {
  RoomAvailability({super.key});

  final cron = Cron();

  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => RoomAvailability(),
    );
  }

  @override
  State<RoomAvailability> createState() => _RoomAvailabilityState();
}

class _RoomAvailabilityState extends State<RoomAvailability> {
  List<Event> events = [];

  @override
  void initState() {
    super.initState();
    searchEvents();
    widget.cron.schedule(Schedule.parse('*/1 * * * *'), () async {
      print("Update list of rooms!");
      searchEvents();
    });
  }

  @override
  void dispose() {
    super.dispose();
    widget.cron.close();
  }

  searchEvents() async {
    Zone zone = const Zone(id: "1", name: "Borgo Roma - Ca' Vignal 1");
    List<Event> result = await getEvents(zone);
    setState(() {
      events = result;
    });
  }

  List<String> get rooms {
    return events.map((e) => e.room).toSet().toList();
  }

  int timeToSeconds(String time) {
    var times = time.split(':');
    return int.parse(times[0]) * 60 + int.parse(times[1]);
  }

  bool isRoomAvailable(String room) {
    // return events.where((element) => element.room == room).toList().;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          itemBuilder: (context, i) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isRoomAvailable(rooms[i]) ? Colors.green : Colors.red,
                ),
              ),
              child: Row(
                children: [
                  Text(rooms[i]),
                ],
              ),
            ),
          ),
          itemCount: rooms.length,
        ),
      ),
    );
  }
}
