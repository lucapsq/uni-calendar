import 'package:flutter/material.dart';

class CalendarListView extends StatelessWidget {
  Function getTeachingList;

  CalendarListView(this.getTeachingList);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          itemCount: getTeachingList().length,
          itemBuilder: (context, index) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.12,
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getTeachingList()[index].name,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      getTeachingList()[index].classroom,
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      getTeachingList()[index].time,
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
