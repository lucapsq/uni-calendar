import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoLessons extends StatelessWidget {
  var nolessonImage;

  NoLessons(this.nolessonImage);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: nolessonImage,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.03,
        ),
        Text(
          'Ottime notizie!\nNon hai impegni per oggi!',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
