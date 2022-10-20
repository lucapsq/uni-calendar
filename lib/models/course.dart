class Course {
  final String id; //886
  final String name; //CLA
  List<String> yearsList = []; // inglese b1, francese b1
  Map<String, String> valuesMap = {};

  Course(
      {required this.id,
      required this.name,
      required this.yearsList,
      required this.valuesMap});
}
