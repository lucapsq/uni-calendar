import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CardCalendar extends StatefulWidget {
  final DateTime d;
  final DateTime selectedDay;

  const CardCalendar(this.d, this.selectedDay, {super.key});
  @override
  State<CardCalendar> createState() => _CardCalendarState();
}

class _CardCalendarState extends State<CardCalendar> {
  bool isActive(DateTime d) {
    if (DateFormat('d-M-y').format(d) ==
        DateFormat('d-M-y').format(widget.selectedDay)) return true;
    return false;
  }

  var days = ['Lun', 'Mar', 'Mer', 'Gio', 'Ven', 'Sab', 'Dom'];
  @override
  Widget build(BuildContext context) {
    return Card(
        color: isActive(widget.d) ? Colors.black : null,
        shape: RoundedRectangleBorder(
            side: BorderSide(
                color:
                    isActive(widget.d) ? Colors.black : const Color(0xffe0e0e0),
                width: 2),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.d.day.toString(),
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isActive(widget.d) ? Colors.white : null),
              textAlign: TextAlign.center,
            ),
            Text(
              days[widget.d.weekday - 1],
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.bold),
            ),
          ],
        ));
  }
}
