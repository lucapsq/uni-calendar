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
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
                height: MediaQuery.of(context).size.height * 0.75,
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
                        onPressed: () {},
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 37,
                            ),
                            Text(
                              selectedPage == 0 ? "Lezioni" : "",
                              style: TextStyle(fontSize: 20),
                            )
                          ],
                        )),
                    /*IconButton(
                      onPressed: () {
                        setState(() {
                          selectedPage = 0;
                        });
                      },
                      icon: Icon(Icons.calendar_today),
                      color: selectedPage == 0 ? Colors.blue : Colors.grey[700],
                      iconSize: 37,
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          selectedPage = 1;
                        });
                      },
                      icon: Icon(Icons.room),
                      color: selectedPage == 1 ? Colors.blue : Colors.grey[700],
                      iconSize: 37,
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          selectedPage = 2;
                        });
                      },
                      icon: Icon(Icons.settings),
                      color: selectedPage == 2 ? Colors.blue : Colors.grey[700],
                      iconSize: 37,
                    ),*/
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
