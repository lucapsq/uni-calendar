import 'package:uni_calendar/models/event.dart';

class Room {
  const Room({
    required this.id,
    required this.name,
    this.events = const [],
  });

  final String id;
  final String name;
  final List<Event> events;

  factory Room.fromJson(Map<String, dynamic> parsedJson) {
    return Room(
      id: parsedJson['id'],
      name: parsedJson['name'],
      events: [],
    );
  }
}
