import 'package:app_install_date/app_install_date.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/room_availability_page.dart';
import 'lessons_page.dart';
import 'settings_page.dart';
import 'package:flutter/services.dart';
import 'package:in_app_review/in_app_review.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  ThemeMode themeMode = prefs.getInt('themeMode') == 0
      ? ThemeMode.light
      : prefs.getInt('themeMode') == 2
          ? ThemeMode.dark
          : ThemeMode.system;

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(MyApp(themeMode));
}

class MyApp extends StatefulWidget {
  final ThemeMode _themeMode;
  const MyApp(this._themeMode, {super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void changeTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    ThemeMode themeMode = prefs.getInt('themeMode') == 0
        ? ThemeMode.light
        : prefs.getInt('themeMode') == 2
            ? ThemeMode.dark
            : ThemeMode.system;

    setState(() {
      _themeMode = themeMode;
    });
  }

  @override
  void initState() {
    super.initState();
    _themeMode = widget._themeMode;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.w400), //17
            headline5: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w600), //24
            headline6: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold), //20
            subtitle1: TextStyle(color: Colors.black, fontSize: 17), //17
            caption: TextStyle(color: Colors.grey[850], fontSize: 12)), //12

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
      themeMode: _themeMode,
      debugShowCheckedModeBanner: false,
      home: Homepage(),
    );
  }
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

  Future<void> checkReview() async {
    late DateTime installDate;
    int launchTimes = 0;
    int reviewRequest = 0;
    installDate = await AppInstallDate().installDate;

    var prefs = await SharedPreferences.getInstance();

    prefs.getInt('reviewRequest') == null
        ? await prefs.setInt('reviewRequest', 0)
        : reviewRequest = prefs.getInt('reviewRequest')!;
    if (reviewRequest < 2) {
      if (prefs.getInt('launchTimes') == null) {
        await prefs.setInt('launchTimes', 1);
      } else {
        launchTimes = prefs.getInt('launchTimes')!;
        launchTimes++;
        await prefs.setInt('launchTimes', launchTimes);
      }

      if (launchTimes > 5 &&
          DateTime.now().difference(installDate).inDays > 20) {
        await Future.delayed(const Duration(seconds: 5));

        final InAppReview inAppReview = InAppReview.instance;
        if (await inAppReview.isAvailable()) {
          inAppReview.requestReview();
          await prefs.setInt('launchTimes', 0);
          reviewRequest++;
          await prefs.setInt('reviewRequest', reviewRequest);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checkReview();

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
        title: selectedPage == 0
            ? const Text(
                "Calendario",
                style: TextStyle(fontSize: 22),
              )
            : selectedPage == 1
                ? const Text(
                    "Aule libere",
                    style: TextStyle(fontSize: 22),
                  )
                : const Text(
                    "Impostazioni",
                    style: TextStyle(fontSize: 22),
                  ),
      ),
      body: SafeArea(
          child: selectedPage == 0
              ? const LessonsPage()
              : selectedPage == 1
                  ? const RoomAvailability()
                  : SettingsPage(settingsImage)),
      bottomNavigationBar: BottomNavigationBar(
        selectedIconTheme: const IconThemeData(size: 30),
        iconSize: 25,
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
