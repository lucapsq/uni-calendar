import 'package:flutter/material.dart';

class NoLessons extends StatelessWidget {
  final nolessonImage;

  const NoLessons(this.nolessonImage, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: nolessonImage,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.03,
        ),
        const Text(
          'Ottime notizie!\nNon hai impegni per oggi!',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
