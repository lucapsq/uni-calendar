import 'package:flutter/material.dart';
import 'package:uni_calendar/api/get_memes.dart';

class NoLessons extends StatelessWidget {
  final nolessonImage;

  const NoLessons(this.nolessonImage, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
        ),
        SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: GestureDetector(
              child: nolessonImage,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return FutureBuilder(
                      future: getMeme(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return AlertDialog(
                            contentPadding: EdgeInsets.zero,
                            content: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: snapshot.data!,
                            ),
                          );
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                    );
                  },
                );
              },
            )
            //nolessonImage
            ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.03,
        ),
        Text(
          'Ottime notizie!\nNon hai impegni per oggi!',
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
      ],
    );
  }
}
