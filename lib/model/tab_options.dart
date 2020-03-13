import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Choice {
  final String title;
  final IconData icon;
  const Choice({this.title, this.icon});
}
const List<Choice> choices = <Choice>[
  Choice(title: 'Conversation', icon: Icons.comment),
  Choice(title: 'Schedule', icon: Icons.schedule),
  Choice(title: 'Connections', icon: Icons.person),];
class ChoicePage extends StatelessWidget {
  const ChoicePage({Key key, this.choice}) : super(key: key);
  final Choice choice;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.display1;
    return Card(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              choice.icon,
              size: 150.0,
              color: textStyle.color,
            ),
            Text(
              choice.title,
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }
}
