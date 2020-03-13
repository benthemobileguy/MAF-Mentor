import 'package:flutter/material.dart';
import 'package:maf_mentor/screens/animations/fade_animations.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final conversation = Material(
      // needed
      color: Colors.transparent,
      child: InkWell(
//    onTap: () => , // needed
        child: Image.asset(
          "assets/images/conversation.png",
          width: 30,
          fit: BoxFit.cover,
        ),
      ),
    );
    final people = Material(
      // needed
      color: Colors.transparent,
      child: InkWell(
//    onTap: () => , // needed
        child: Image.asset(
          "assets/images/people.png",
          width: 30,
          fit: BoxFit.cover,
        ),
      ),
    );
    final arrow_box = Material(
      // needed
      color: Colors.transparent,
      child: InkWell(
//    onTap: () => , // needed
        child: Image.asset(
          "assets/images/arrow_box.png",
          width: 30,
          fit: BoxFit.cover,
        ),
      ),
    );
    final custom_msg = Material(
      // needed
      color: Colors.transparent,
      child: InkWell(
//    onTap: () => , // needed
        child: Image.asset(
          "assets/images/custom_msg.png",
          width: 120,
          fit: BoxFit.cover,
        ),
      ),
    );
    final divider = new Divider(
    );

    final headingText = Text(
      "Thank you for signing up. Complete your profile here to use the platform",
      style: TextStyle(
        color: Color(0xFFE93428),
        fontFamily: 'Muli',
        fontSize: 15.0,
      ),
    );
    final bottomText = Text(
      "Your messages will appear here when you connect with mentees",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Color(0xFFBCC5D3),
        fontFamily: 'Muli',
        fontSize: 15.0,
      ),
    );
    final headingInfoText = Container(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "John Hoxx and 6 others want to connect with you",
          textAlign: TextAlign.start,
          style: TextStyle(
            color: Color(0xFF36ADE6),
            fontFamily: 'Muli',
            fontSize: 12.5,
          ),
        ),
      ),
    );
    final conversationText = Container(
      child: Align(
        alignment: Alignment.centerLeft,
      child: Text(
        "Conversation",
        textAlign: TextAlign.start,
        style: TextStyle(
          color: Color(0xFF1C2447),
          fontFamily: 'Muli',
          fontSize: 18.0,
        ),
      ),
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
              Center(child: custom_msg),
              SizedBox(
                height: 12.0,
              ),
             Center(child: bottomText),
              SizedBox(
                height: 30.0,
              ),
            ],
          ),
        ));
  }
}
