import 'package:flutter/material.dart';
import 'package:maf_mentor/route_animations/slide_from_right_page_route.dart';
import 'package:maf_mentor/screens/schedule_meeting.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    final divider = new Divider();


    final bottomText = Text(
      "No notifications for now",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Color(0xFF004782),
        fontFamily: 'Muli',
        fontSize: 15.0,
      ),
    );

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xFFFFFFFF),
          automaticallyImplyLeading: true,
          //`true` if you want Flutter to automatically add Back Button when needed,
          //or `false` if you want to force your own back button every where
          title: Text(
            'Notifications',
            style: TextStyle(
              color: Color(0xFF1C2447),
              fontFamily: 'Muli',
              fontSize: 16.0,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Color(0xFF1C2447),
            onPressed: () => Navigator.pop(context, false),
          )),
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
