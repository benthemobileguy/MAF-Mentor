import 'package:flutter/material.dart';

class  ResourcesPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Center(
            child: new  Text(
              "Check back later",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF004782),
                fontFamily: 'Muli',
                fontSize: 14,
              ),
            )
        )
    );
  }
}