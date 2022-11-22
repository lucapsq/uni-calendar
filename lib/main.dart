import 'package:flutter/material.dart';
import '/room_availability_page.dart';
import 'lessons_page.dart';
import 'settings_page.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
            backgroundColor: Colors.blue,
            centerTitle: true,
            titleTextStyle:
                TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
        primaryColor: Colors.white,
        primaryColorDark: Colors.grey[350],
        backgroundColor: Colors.black,
        primarySwatch: Colors.blue, //colore di tasti e animazioni
        scaffoldBackgroundColor: Colors.grey[100], //colore di scaffold
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
        ),
        textTheme: TextTheme(
            bodyText1: TextStyle(
                color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400),
            headline5:
                TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
            headline6:
                TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            subtitle1: TextStyle(color: Colors.black, fontSize: 17),
            caption: TextStyle(color: Colors.grey[850], fontSize: 12)),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(),
        ),
        cardColor: Colors.white, //colore interno delle card
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        appBarTheme: AppBarTheme(
            backgroundColor: Colors.blue[900],
            centerTitle: true,
            titleTextStyle:
                TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
        primaryColor: Colors.black,
        primaryColorDark: Colors.grey[800],

        backgroundColor: Colors.grey[100],
        primarySwatch: Colors.blue, //colore di tasti e animazioni
        scaffoldBackgroundColor: Color(0xff121212), //colore di scaffold
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.blue[500],
          unselectedItemColor: Colors.grey,
        ),
        textTheme: TextTheme(
            bodyText1: TextStyle(
                color: Colors.grey[100],
                fontSize: 17,
                fontWeight: FontWeight.w400),
            headline5:
                TextStyle(color: Colors.grey[100], fontWeight: FontWeight.w600),
            headline6:
                TextStyle(color: Colors.grey[100], fontWeight: FontWeight.bold),
            subtitle1: TextStyle(color: Colors.grey[100], fontSize: 17),
            caption: TextStyle(color: Colors.grey[350], fontSize: 12)),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(),
        ),
        cardColor: Colors.black, //colore interno delle card
      ),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
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

  late Image settingsImage;

  @override
  void initState() {
    super.initState();
    settingsImage = Image.asset("assets/setting-preference.png");
  }

  @override
  void didChangeDependencies() {
    precacheImage(settingsImage.image, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("UniVR Calendar"),
      ),
      body: SafeArea(
          child: selectedPage == 0
              ? const LessonsPage()
              : selectedPage == 1
                  ? const RoomAvailability()
                  : SettingsPage(settingsImage)),
      bottomNavigationBar: BottomNavigationBar(
        selectedIconTheme: const IconThemeData(size: 35),
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
        onTap: _onItemTapped,
      ),
    );
  }
}
