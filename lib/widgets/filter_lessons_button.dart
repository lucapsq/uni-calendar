import 'package:flutter/material.dart';

import '../filter_lesson_page.dart';

class FilterLessonButton extends StatefulWidget {
  final mediaQuery;
  const FilterLessonButton(this.mediaQuery, {super.key});

  @override
  State<FilterLessonButton> createState() => _FilterLessonButtonState();
}

class _FilterLessonButtonState extends State<FilterLessonButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        width: widget.mediaQuery.size.height * 0.15,
        height: widget.mediaQuery.size.height * 0.09,
        child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const FilterLessonPage()),
              );
            },
            child: const Text(
              "Filtra Lezioni",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            )));
  }
}
