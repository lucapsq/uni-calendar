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
        Text(
          'Ottime notizie!\nNon hai impegni per oggi!',
          style: Theme.of(context).textTheme.headline6,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
