import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:uni_calendar/api/get_events.dart';
import 'package:uni_calendar/models/event.dart';
import 'package:uni_calendar/models/eventDataSource.dart';
import 'package:uni_calendar/models/room.dart';
import 'package:uni_calendar/models/zone.dart';
import 'package:uni_calendar/widgets/current_rooms.dart';
import 'package:uni_calendar/widgets/free_room_listview.dart';

class RoomAvailability extends StatefulWidget {
  const RoomAvailability({super.key});

  @override
  State<RoomAvailability> createState() => _RoomAvailabilityState();
}

// Image.asset("assets/no-data.png");
class _RoomAvailabilityState extends State<RoomAvailability> {
  Future<List<Room>> searchRooms() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> zones = [];
    if (prefs.getStringList('zonesList') != null) {
      zones = prefs.getStringList('zonesList')!;
    }

    List<Room> result = [];
    for (var z in zones) {
      result += await getRoomsById(z);
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: searchRooms(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Room> events = snapshot.data!;
            return CurrentRoomsCalendar(rooms: events);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
