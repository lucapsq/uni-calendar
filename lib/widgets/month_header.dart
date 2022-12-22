import 'package:flutter/material.dart';
import 'package:uni_calendar/widgets/singlecard_calendar_header_day.dart';

class MonthHeader extends StatefulWidget {
  DateTime selectedDay;
  Function selectedDayChanged;

  MonthHeader(this.selectedDay, this.selectedDayChanged);

  @override
  State<MonthHeader> createState() => _MonthHeaderState();
}

class _MonthHeaderState extends State<MonthHeader> {
  List<Widget> cardMonthWidget = [];
  List<DateTime> monthView = [];

  void fillMonthDays() {
    int dayInt = widget.selectedDay.day;
    int monthInt = widget.selectedDay.month;

    String dayString = dayInt.toString();
    String monthString = monthInt.toString();

    if (dayInt < 10) {
      dayString = "0" + dayString;
    }

    if (monthInt < 10) {
      monthString = "0" + monthString;
    }

    DateTime day = DateTime.parse(
        widget.selectedDay.year.toString() + "-" + monthString + "-01");
    if (monthView.isEmpty)
      while (day.month == monthInt) {
        monthView.add(day);
        day = day.add(Duration(days: 1));
      }
  }

  String _getMonthTitle() {
    String monthTitle = "";
    switch (monthView[0].month) {
      case 1:
        monthTitle = "Gennaio";
        break;
      case 2:
        monthTitle = "Febbraio";
        break;
      case 3:
        monthTitle = "Marzo";
        break;
      case 4:
        monthTitle = "Aprile";
        break;
      case 5:
        monthTitle = "Maggio";
        break;
      case 6:
        monthTitle = "Giugno";
        break;
      case 7:
        monthTitle = "Luglio";
        break;
      case 8:
        monthTitle = "Agosto";
        break;
      case 9:
        monthTitle = "Settembre";
        break;
      case 10:
        monthTitle = "Ottobre";
        break;
      case 11:
        monthTitle = "Novembre";
        break;
      case 12:
        monthTitle = "Dicembre";
        break;
      default:
        return "Errore";
    }
    return monthTitle + " " + monthView[0].year.toString();
  }

  @override
  Widget build(BuildContext context) {
    fillMonthDays();

    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          color: Theme.of(context).primaryColor,
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Text(_getMonthTitle(),
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.35,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
            color: Theme.of(context).primaryColor,
          ),
          child: GridView.count(
              physics: NeverScrollableScrollPhysics(),
              primary: true,
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
              crossAxisCount: 7,
              children: [
                for (var d in monthView)
                  GestureDetector(
                    onTap: () {
                      widget.selectedDayChanged(d);
                    },
                    child: CardCalendar(d, widget.selectedDay),
                  ),
              ]),
        ),
      ],
    );
  }
}
