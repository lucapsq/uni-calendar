import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_calendar/api/get_events.dart';
import 'package:uni_calendar/models/event.dart';
import 'package:uni_calendar/models/zone.dart';
import 'package:uni_calendar/widgets/free_room_listview.dart';

class RoomAvailability extends StatefulWidget {
  const RoomAvailability({super.key});

  @override
  State<RoomAvailability> createState() => _RoomAvailabilityState();
}

class _RoomAvailabilityState extends State<RoomAvailability> {
  late Image noDataImage;
  @override
  void initState() {
    super.initState();
    noDataImage = Image.asset("assets/no-data.png");
  }

  @override
  void didChangeDependencies() {
    precacheImage(noDataImage.image, context);
    super.didChangeDependencies();
  }

  List<Event> events = [];

  List<String> get rooms {
    return events.map((e) => e.room).toSet().toList();
  }

  List<String> checkedId = [];
  Future<void> fetchCheckedItems() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getStringList('zonesList') != null) {
      checkedId = prefs.getStringList('zonesList')!;
    }
  }

  Future<List<Event>> searchEvents() async {
    await fetchCheckedItems();
    List<Event> result = [];
    for (var z in checkedId) {
      Zone zone = Zone(id: z, name: "Borgo Roma - Ca' Vignal 2");
      result += await getEvents(zone);
    }

    setState(() {
      events = result;
    });

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: searchEvents(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Event> events = snapshot.data!;
            return Column(
              children: [
                FreeRoomsListview(events, rooms, noDataImage),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
