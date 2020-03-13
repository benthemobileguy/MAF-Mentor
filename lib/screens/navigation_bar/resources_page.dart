import 'package:flutter/material.dart';

class  ResourcesPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(

          backgroundColor: Color(0xFF004782),
          child: Icon(Icons.add),
        ),
        body:Center(
            child: new  Text(
              "Nothing Found",
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