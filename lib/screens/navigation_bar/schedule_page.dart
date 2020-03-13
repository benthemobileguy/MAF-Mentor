import 'package:flutter/material.dart';

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  @override
  Widget build(BuildContext context) {
    final divider = new Divider();


    final bottomText = Text(
      "Your schedule list is empty",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Color(0xFF004782),
        fontFamily: 'Muli',
        fontSize: 15.0,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding:
              EdgeInsets.only(left: 24.0, right: 24.0, top: 0.0, bottom: 50.0),
          children: [
            SizedBox(
              height: 100.0,
            ),
            Center(child: bottomText),
            SizedBox(
              height: 12.0,
            ),
          ],
        ),
      ),
    );
  }
}
