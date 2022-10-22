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

  void _onItemTapped(int index) {
    setState(() {
      selectedPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("UniVR Calendar"),
        centerTitle: true,
      ),
      body: SafeArea(
          child: selectedPage == 0
              ? LessonsCalendar()
              : selectedPage == 1
                  ? RoomAvailability()
                  : SettingsPage()),
      bottomNavigationBar: BottomNavigationBar(
        selectedIconTheme: IconThemeData(size: 35),
        iconSize: 28,
        selectedFontSize: 17,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Lezioni',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Aule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Impostazioni',
          ),
        ],
        currentIndex: selectedPage,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
