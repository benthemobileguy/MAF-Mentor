import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:maf_mentor/model/noti.dart';
import 'package:maf_mentor/screens/utils/auth.dart';
import 'package:maf_mentor/screens/utils/network.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  Future _future;
  List<Noti> notiList = [];
  List<String> titles = [];
  List<Message> messages = [];
  List<String> bodies = [];
  List<String> createdAtList = [];
  var dateFormat = DateFormat('dd-MM-yyyy');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _future = notificationsList();
  }
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
      body: FutureBuilder(
          future: _future,
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if (snapshot.data == null) {
              return Center(
                child: Text(
                    "Nothing found",
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'MuliItalic',
                      fontSize: 16.0,
                    )),
              );
            } else
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: notiList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Image.asset('assets/images/notification.png',
                              width: 25.0, height: 25.0),
                        ),
                      ),
                      title: Text(
                          titles[index] !=null?
                          truncateWithEllipsis(20, titles[index]) : "",
                          style: TextStyle(
                            color: Color(0xFF041F36),
                            fontFamily: 'Muli',
                            fontSize: 14.5,
                          )),
                      subtitle: Text(
                          bodies[index] !=null?
                          truncateWithEllipsis(20, bodies[index]): "",
                          style: TextStyle(
                            color: Color(0xFF25282A),
                            fontFamily: 'MuliBold',
                            fontSize: 12.0,
                          )),
                      trailing: Text(
                          createdAtList[index] !=null?
                          truncateWithEllipsis(10, createdAtList[index]) : "",
                          style: TextStyle(
                            color: Color(0xFF25282A),
                            fontFamily: 'MuliBold',
                            fontSize: 12.0,
                          )),
                    );
                  },
                ),
              );
          }
      ),
    );
  }
  notificationsList() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var uri = NetworkUtils.host + AuthUtils.getNotifications;
    try {
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': "Bearer " + sharedPreferences.getString("token")
        },
      );
      final responseJson = json.decode(response.body);
      setState(() {
        notiList = List<Noti>.from(responseJson["data"]
            .map((i) => Noti.fromJson(i)));
        createdAtList = notiList.map((value) => value.createdAt).toList();
        messages = notiList
            .map((msg) => msg.message).toList();
        titles =
            messages.map((value) => value.title).toList();
        bodies =
            messages.map((value) => value.body).toList();

      });
      return responseJson;
    } catch (exception) {
      print(exception);
    }
  }
  static String truncateWithEllipsis(int cutoff, String myString) {
    return (myString.length <= cutoff)
        ? myString
        : '${myString.substring(0, cutoff)}..';
  }
}
