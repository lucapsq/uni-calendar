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
  List<DateTime> previousMonthView = [];
  List<DateTime> nextMonthView = [];

  late DateTime selectedDayInMonth;
  void initState() {
    super.initState();
    selectedDayInMonth = widget.selectedDay;
  }

  void fillMonthDays() {
    int monthInt = selectedDayInMonth.month;

    String monthString = monthInt.toString();

    if (monthInt < 10) {
      monthString = "0" + monthString;
    }

    DateTime day = DateTime.parse(
        selectedDayInMonth.year.toString() + "-" + monthString + "-01");

    if (day.weekday != 1 && previousMonthView.isEmpty) {
      DateTime previousDay = day.subtract(Duration(days: day.weekday - 1));

      while (previousDay.day != day.day) {
        previousMonthView.add(previousDay);
        previousDay = previousDay.add(Duration(days: 1));
      }
    }

    if (monthView.isEmpty)
      while (day.month == monthInt) {
        monthView.add(day);
        day = day.add(Duration(days: 1));
      }

    if (day.weekday != 7 && nextMonthView.isEmpty) {
      day = monthView.last;

      while (day.weekday != 7) {
        day = day.add(Duration(days: 1));
        nextMonthView.add(day);
      }
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

  DateTime getDayOfNextMonth(DateTime selectedDayInMonth) {
    int selectedMonth = selectedDayInMonth.month;

    while (selectedMonth == selectedDayInMonth.month) {
      selectedDayInMonth = selectedDayInMonth.add(Duration(days: 1));
    }

    return selectedDayInMonth;
  }

  DateTime getDayOfPreviousMonth(DateTime selectedDayInMonth) {
    int selectedMonth = selectedDayInMonth.month;

    while (selectedMonth == selectedDayInMonth.month) {
      selectedDayInMonth = selectedDayInMonth.subtract(Duration(days: 1));
    }

    return selectedDayInMonth;
  }

  @override
  Widget build(BuildContext context) {
    fillMonthDays();

    return Container(
      height: MediaQuery.of(context).size.height * 0.43,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.06,
            color: Theme.of(context).primaryColor,
            padding: const EdgeInsets.fromLTRB(0, 7, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      previousMonthView.clear();
                      monthView.clear();
                      nextMonthView.clear();
                      selectedDayInMonth =
                          getDayOfPreviousMonth(selectedDayInMonth);
                    });
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    //size: 20,
                  ),
                ),
                Text(
                  _getMonthTitle(),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      previousMonthView.clear();
                      monthView.clear();
                      nextMonthView.clear();
                      selectedDayInMonth =
                          getDayOfNextMonth(selectedDayInMonth);
                    });
                  },
                  icon: Icon(
                    Icons.arrow_forward_ios,
                  ),
                ),
              ],
            ),
          ),
          /*Container(
            height: MediaQuery.of(context).size.height * 0.01,
            color: Colors.black,
          ),*/
          Container(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.34,
            child: GridView.count(
                //physics: NeverScrollableScrollPhysics(),
                primary: true,
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
                crossAxisCount: 7,
                children: [
                  for (var d in previousMonthView)
                    GestureDetector(
                      onTap: () {
                        widget.selectedDayChanged(d);
                      },
                      child: CardCalendar(d, widget.selectedDay, false),
                    ),
                  for (var d in monthView)
                    GestureDetector(
                      onTap: () {
                        widget.selectedDayChanged(d);
                      },
                      child: CardCalendar(d, widget.selectedDay, true),
                    ),
                  for (var d in nextMonthView)
                    GestureDetector(
                      onTap: () {
                        widget.selectedDayChanged(d);
                      },
                      child: CardCalendar(d, widget.selectedDay, false),
                    ),
                ]),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(7)),
                color: Colors.grey[350],
              ),
              height: 5,
              width: 45,
            ),
          )
        ],
      ),
    );
  }
}
