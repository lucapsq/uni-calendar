class Event {
  const Event({
    required this.id,
    required this.start,
    required this.end,
    required this.name,
    required this.room,
    required this.zone,
  });

  final String id;
  final DateTime start;
  final DateTime end;
  final String name;
  final String room;
  final String zone;

  factory Event.fromJson(Map<String, dynamic> parsedJson) {
    DateTime start =
        _formatTime((parsedJson['from'] as String).substring(0, 5));
    DateTime end = _formatTime((parsedJson['to'] as String).substring(0, 5));

    return Event(
      id: parsedJson['id'],
      start: start,
      end: end,
      name: parsedJson['name'],
      room: parsedJson['NomeAula'],
      zone: parsedJson['NomeSede'],
    );
  }

  static DateTime _formatTime(String time) {
    List<String> tmp = time.split(":");
    int hours = int.parse(tmp[0]);
    int minutes = int.parse(tmp[1]);
    DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hours, minutes);
  }
}
