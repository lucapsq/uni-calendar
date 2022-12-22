import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:uni_calendar/api/get_events.dart';

class FilterZonesPage extends StatefulWidget {
  const FilterZonesPage({super.key});

  @override
  State<FilterZonesPage> createState() => _FilterZonesPageState();
}

class _FilterZonesPageState extends State<FilterZonesPage> {
  late Image filterLessonsImage;

  @override
  void didChangeDependencies() {
    precacheImage(filterLessonsImage.image, context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

    filterLessonsImage = Image.asset("assets/filter-lessons.png");
  }

  List<String> zones = [];
  Map<String, String> zonesMap = {};

  Future<Map<String, String>> searchZones() async {
    zonesMap = await getZones(); //sede:id
    await fetchCheckedItems(zonesMap);
    zonesMap.forEach((key, value) {
      if (!zones.contains(value)) {
        zones.add(value);
      }
    });

    return zonesMap;
  }

  Future<void> savePreferences(List<String> checkedItems) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> checkedId = [];
    if (checkedItems.isNotEmpty) {
      zonesMap.forEach((key, value) {
        if (checkedItems.contains(value)) {
          checkedId.add(key);
        }
      });

      await prefs.setStringList('zonesList', checkedId);
    } else {
      await prefs.setStringList('zonesList', []);
    }
  }

  List<String> checkedItems = [];

  Future<void> fetchCheckedItems(Map<String, String> zonesMap) async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getStringList('zonesList') != null && checkedItems.isEmpty) {
      zonesMap.forEach((key, value) {
        if (prefs.getStringList('zonesList')!.contains(key)) {
          checkedItems.add(value);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("UniVR Calendar"),
      ),
      body: FutureBuilder(
        future: searchZones(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Container(
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: filterLessonsImage),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Che sedi vuoi visualizzare?",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  height: MediaQuery.of(context).size.height * 0.45,
                  child: Card(
                    margin: const EdgeInsets.fromLTRB(30, 0, 30, 10),
                    child: ListView.builder(
                        itemCount: zones.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CheckboxListTile(
                            activeColor: Colors.blue,
                            value: checkedItems.contains(zones[index]),
                            onChanged: (newValue) {
                              if (checkedItems.contains(zones[index])) {
                                setState(() {
                                  checkedItems.remove(zones[index]);
                                });
                              } else if (!checkedItems.contains(zones[index])) {
                                setState(() {
                                  checkedItems.add(zones[index]);
                                });
                              }
                            },
                            title: Text(zones[index]),
                          );
                        }),
                  ),
                ),
                ElevatedButton(
                  child: const Text("Salva"),
                  onPressed: () async {
                    await savePreferences(checkedItems);
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                ),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
