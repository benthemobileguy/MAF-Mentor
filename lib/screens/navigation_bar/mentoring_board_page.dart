import 'package:flutter/material.dart';

class  MentoringBoardPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(

        backgroundColor: Color(0xFF004782),
        child: Icon(Icons.add),
      ),
      body:Center(
    child: new  Text(
      "Nothing found",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Color(0xFF004782),
        fontFamily: 'Muli',
        fontSize: 16,
      ),
    )
    )
    );
  }
}