import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:uni_calendar/models/event.dart';
import 'package:uni_calendar/models/room.dart';
import 'package:uni_calendar/models/zone.dart';

Future<List<Room>> getRoomsById(String id) async {
  final uri = Uri.parse(
      'https://logistica.univr.it/PortaleStudentiUnivr/rooms_call.php');
  var map = <String, dynamic>{
    'sede': id,
    'date': DateFormat('dd-MM-yyyy').format(DateTime.now()),
    '_lang': 'it',
    'all_events': '1',
  };

  http.Response response = await http.post(uri, body: map);

  var body = jsonDecode(response.body);

  List<Event> events = [];
  for (var event in body['events']) {
    events.add(Event.fromJson(event));
  }

  List<Room> rooms = [];
  body['rooms'].forEach((key, value) {
    String roomName = value['nome'];
    List<Event> roomEvents =
        events.where((event) => event.room == roomName).toList();
    Room room = Room(id: key, name: roomName, events: roomEvents);
    rooms.add(room);
  });

  return rooms;
}

Future<Map<String, String>> getZones() async {
  final uri = Uri.parse(
      'https://logistica.univr.it/PortaleStudentiUnivr/rooms_call.php');

  http.Response response = await http.post(uri);

  Map<String, String> zones = {};

  for (var event in jsonDecode(response.body)['raggruppamenti']) {
    zones.addAll({event['valore']: event['label']});
  }

  return zones;
}
