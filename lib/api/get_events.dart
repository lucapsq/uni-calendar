import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:uni_calendar/models/event.dart';
import 'package:uni_calendar/models/zone.dart';

Future<List<Event>> getEvents(Zone zone) async {
  final uri = Uri.parse(
      'https://logistica.univr.it/PortaleStudentiUnivr/rooms_call.php');
  var map = <String, dynamic>{
    'sede': '1',
    'date': DateFormat('dd-MM-yyyy').format(DateTime.now()),
    '_lang': 'it',
    'all_events': '1',
  };

  http.Response response = await http.post(uri, body: map);

  List<Event> events = [];
  for (var event in jsonDecode(response.body)['events']) {
    events.add(Event.fromJson(event));
  }

  return events;
}
