import 'package:flutter/material.dart';
import 'package:uni_calendar/widgets/singlecard_calendar_header_day.dart';

class WeekHeader extends StatefulWidget {
  List<DateTime> weekView;
  DateTime selectedDay;
  Function selectedDayChanged;

  WeekHeader(this.weekView, this.selectedDayChanged, this.selectedDay);

  @override
  State<WeekHeader> createState() => _WeekHeaderState();
}

class _WeekHeaderState extends State<WeekHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.12,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
        color: Theme.of(context).primaryColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (var d in widget.weekView)
            Expanded(
              child: GestureDetector(
                onTap: () {
                  widget.selectedDayChanged(d);
                },
                child: CardCalendar(d, widget.selectedDay),
              ),
            ),
        ],
      ),
    );
  }
}
