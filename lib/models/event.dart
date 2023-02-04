class Event {
  const Event({
    //required this.id,
    required this.start,
    required this.end,
    required this.name,
    required this.room,
    required this.zone,
  });

  //final String id;
  final String start;
  final String end;
  final String name;
  final String room;
  final String zone;

  factory Event.fromJson(Map<String, dynamic> parsedJson) {
    return Event(
      //id: parsedJson['id'],
      start: (parsedJson['from'] as String).substring(0, 5),
      end: (parsedJson['to'] as String).substring(0, 5),
      name: parsedJson['name'],
      room: parsedJson['NomeAula'],
      zone: parsedJson['NomeSede'],
    );
  }
}
