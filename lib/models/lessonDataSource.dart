import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:uni_calendar/models/lessonEvent.dart';

class LessonDataSource extends CalendarDataSource {
  LessonDataSource(List<LessonEvent> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }
}
