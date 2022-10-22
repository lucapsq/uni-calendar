import 'package:flutter/material.dart';
import 'package:uni_calendar/widgets/room_availability.dart';
import 'configuration_page.dart';
import 'lessons_calendar.dart';
import 'settings_page.dart';

void main() {
  runApp(
    const MaterialApp(
      home: Homepage(),
    ),
  );
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  var selectedPage = 0;
  var selectedColor = Colors.blue;
  var unselectedColor = Colors.grey[700];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("UniVR Calendar"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
                height: MediaQuery.of(context).size.height * 0.76,
                child: selectedPage == 0
                    ? LessonsCalendar()
                    : selectedPage == 1
                        ? RoomAvailability()
                        : SettingsPage()),
            Expanded(
              child: Container(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                        onPressed: () {
                          setState(() {
                            selectedPage = 0;
                          });
                        },
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today,
                                size: 37,
                                color: selectedPage == 0
                                    ? selectedColor
                                    : unselectedColor),
                            Text(
                              selectedPage == 0 ? "Lezioni" : "",
                              style: TextStyle(fontSize: 20),
                            )
                          ],
                        )),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            selectedPage = 1;
                          });
                        },
                        child: Row(
                          children: [
                            Icon(Icons.room,
                                size: 37,
                                color: selectedPage == 1
                                    ? selectedColor
                                    : unselectedColor),
                            Text(
                              selectedPage == 1 ? "Aule" : "",
                              style: TextStyle(fontSize: 20),
                            )
                          ],
                        )),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            selectedPage = 3;
                          });
                        },
                        child: Row(
                          children: [
                            Icon(Icons.settings,
                                size: 37,
                                color: selectedPage == 3
                                    ? selectedColor
                                    : unselectedColor),
                            Text(
                              selectedPage == 3 ? "Impostazioni" : "",
                              style: TextStyle(fontSize: 20),
                            )
                          ],
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
