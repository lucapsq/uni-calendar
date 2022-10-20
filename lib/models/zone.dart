class Zone {
  const Zone({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  factory Zone.fromJson(Map<String, dynamic> parsedJson) {
    return Zone(
      id: parsedJson['valore'],
      name: parsedJson['label'],
    );
  }
}
