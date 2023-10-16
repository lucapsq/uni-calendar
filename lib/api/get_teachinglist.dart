import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/teaching.dart';
import 'package:http/http.dart' as http;

String getCourseYearString(List<String> courseYearList) {
  String courseYear = "";

  for (var c in courseYearList) {
    c = c.replaceAll(' ', '+');
  }

  for (int i = 0; i < courseYearList.length; i++) {
    courseYear = courseYear + courseYearList[i];

    if (i + 1 < courseYearList.length) {
      courseYear = "$courseYear%2C";
    }
  }

  return courseYear;
}

String getCourseYearCodeString(List<String> courseYearCodeList) {
  String courseYearCode = "";

  for (var c in courseYearCodeList) {
    c.replaceAll('|', '%7C');
  }

  for (int i = 0; i < courseYearCodeList.length; i++) {
    courseYearCode = courseYearCode + courseYearCodeList[i];

    if (i + 1 < courseYearCodeList.length) {
      courseYearCode = "$courseYearCode&anno2%5B%5D=";
    }
  }

  return courseYearCode;
}

Future<List<Teaching>> getTeachingsList(
    DateTime todayDateTime,
    String today,
    String courseCode,
    List<String> courseYearList,
    List<String> courseYearCodeList,
    List<String> excludedLessonList) async {
  String courseYear = getCourseYearString(courseYearList);
  String courseYearCode = getCourseYearCodeString(courseYearCodeList);

  String year = "";

  if (todayDateTime.month >= 8 && todayDateTime.month <= 12) {
    year = todayDateTime.year.toString();
  } else {
    year = (todayDateTime.year - 1).toString();
  }

  String req =
      "view=easycourse&form-type=corso&include=corso&txtcurr=$courseYear&anno=$year&corso=$courseCode&anno2%5B%5D=$courseYearCode&date=$today&periodo_didattico=&_lang=it&list=&week_grid_type=-1&ar_codes_=&ar_select_=&col_cells=0&empty_box=0&only_grid=0&highlighted_date=0&all_events=1&faculty_group=0&_lang=it&all_events=1&txtcurr=";

  var response = await http.post(
      Uri.parse(
          "https://logistica.univr.it/PortaleStudentiUnivr/grid_call.php"),
      headers: <String, String>{
        'host': 'logistica.univr.it',
        'accept': 'application/json, text/javascript, */*; q=0.01',
        'cookie':
            '_ga=GA1.2.2068719171.1664730829; GUEST_LANGUAGE_ID=it_IT; _gcl_au=1.1.2142101337.1664818817; nmstat=9f3dc057-9cd9-3d7e-5bc8-519afa15100d; _gid=GA1.2.1847862459.1665343320; PHPSESSID=m4mh7h7ueoctve40t682cjgtr5',
        'origin': 'https://logistica.univr.it',
        'referer':
            'https://logistica.univr.it/PortaleStudentiUnivr/?view=easycourse&form-type=corso&include=corso&txtcurr=2+-+UNICO&anno=2022&corso=420&anno2%5B%5D=999%7C2&date=10-10-2022&periodo_didattico=&_lang=it&list=&week_grid_type=-1&ar_codes_=&ar_select_=&col_cells=0&empty_box=0&only_grid=0&highlighted_date=0&all_events=0&faculty_group=0',
        'sec-ch-ua':
            '"Chromium";v="106", "Google Chrome";v="106", "Not;A=Brand";v="99"',
        'connection': 'keep-alive',
        'user-agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36',
        'content-type': 'application/x-www-form-urlencoded; charset=UTF-8',
        'sec-fetch-dest': 'empty',
        'sec-fetch-mode': 'cors',
        'sec-fetch-site': 'same-origin',
        'accept-encoding': 'gzip, deflate, br',
        'accept-language': 'it-IT,it;q=0.9,en-GB;q=0.8,en;q=0.7,en-US;q=0.6',
        'x-postman-captr': '9748224',
        'sec-ch-ua-mobile': '?0',
        'x-requested-with': 'XMLHttpRequest',
        'sec-ch-ua-platform': '"Windows"',
      },
      body: req);

  var dataList = jsonDecode(response.body.toString());

  List<Teaching> teachingsList = [];

  int colorIndex = 0;

  Map<String, Color> colorsMap = {};

  Color getNextColor() {
    String color = dataList['colori'][colorIndex];
    color = "0xff${color.substring(1)}";

    int colorInt = int.parse(color);
    colorIndex++;
    return Color(colorInt);
  }

  for (var c in dataList['celle']) {
    if (colorsMap[c['nome_insegnamento']] == null &&
        c['nome_insegnamento'] != null) {
      colorsMap.addAll({c['nome_insegnamento']: getNextColor()});
    }
  }

  for (var c in dataList['celle']) {
    if (!excludedLessonList.contains(c['codice_insegnamento'])) {
      if (c['nome_insegnamento'] != null && c['Annullato'] != '1') {
        teachingsList.add(Teaching(
            name: c['nome_insegnamento'],
            date: c['data'],
            time: c['orario'],
            classroom: c['aula'],
            color: colorsMap[c['nome_insegnamento']]!));
      }
    }
  }

  return teachingsList;
}
