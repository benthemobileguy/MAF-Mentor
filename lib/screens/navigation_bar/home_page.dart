import 'package:flutter/material.dart';
import 'package:maf_mentor/model/chat_connections.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maf_mentor/model/mentee.dart';
import 'package:maf_mentor/route_animations/slide_from_right_page_route.dart';
import 'package:maf_mentor/screens/chat_screen.dart';
import 'package:maf_mentor/screens/utils/auth.dart';
import 'package:maf_mentor/screens/utils/network.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strings/strings.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Mentee> users = [];
  List<ChatConnections> idLoop = [];
  Iterable usersIdList;
  Future _future;
  List<ChatConnections> chatConnectionsList = [];
  bool isConnections = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _future = getConnections();
  }

  Widget showList() {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
            padding: const EdgeInsets.only(
                top: 30.0, left: 12.0, right: 12.0, bottom: 20.0),
            child: FutureBuilder(
              future: _future,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Container(child: Center(child: Text("Loading...")));
                } else {
                  return ListView.builder(
                    itemCount: chatConnectionsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: CircleAvatar(
                          maxRadius: 23,
                          backgroundImage: NetworkImage(
                              chatConnectionsList[index].profile_image),
                        ),
                        title: Text(capitalize(chatConnectionsList[index].name),
                            style: TextStyle(
                              color: Color(0xFF041F36),
                              fontFamily: 'Muli',
                              fontSize: 15.0,
                            )),
                        subtitle: Text(
                            capitalize("your recent messages will appear here"),
                            style: TextStyle(
                              color: Color(0xFF2E2F58),
                              fontFamily: 'Muli',
                              fontSize: 12.5,
                            )),
                        onTap: () {
                          Navigator.push(
                              context,
                              SlideFromRightPageRoute(
                                  widget: ChatPage(users[index],
                                      chatConnectionsList[index].id)));
                        },
                      );
                    },
                  );
                }
              },
            )));
  }

  @override
  Widget build(BuildContext context) {
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

    final bottomText = Text(
      "Your messages will appear here when you connect with mentees",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Color(0xFFBCC5D3),
        fontFamily: 'Muli',
        fontSize: 15.0,
      ),
    );

    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: !isConnections
              ? ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(
                      left: 24.0, right: 24.0, top: 0.0, bottom: 50.0),
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
                )
              : showList(),
        ));
  }

  Future getConnections() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var uri = NetworkUtils.host + AuthUtils.chatConnections;
    try {
      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer ' + sharedPreferences.get("token"),
        },
      );
      final responseJson = json.decode(response.body);
      for (var u in responseJson) {
        ChatConnections chatConnections = ChatConnections(
            u["id"],
            u["email"],
            u["name"],
            u["profile_image"],
            u["unread_count"],
            u["time_of_last_message"]);
        chatConnectionsList.add(chatConnections);
      }
      setState(() {
        usersIdList = chatConnectionsList
            .map((ChatConnections) => ChatConnections.id.toString());
      });
      _updateListOfMentees(usersIdList);
      if (chatConnectionsList.length != 0) {
        setState(() {
          isConnections = true;
        });
      }
      return responseJson;
    } catch (exception) {
      print(exception);
    }
  }

  Future<dynamic> _getMenteeJsonByIndex(String index) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var data = await http.get(
      NetworkUtils.host + AuthUtils.endPointMenteeProfile + index,
      headers: {
        'Authorization': "Bearer " + sharedPreferences.getString("token"),
        'Accept': 'application/json'
      },
    );
    var jsonData = json.decode(data.body);
    return jsonData;
  }

  Future<List<Mentee>> _updateListOfMentees(Iterable menteeIds) async {
    for (int i = 0; i < menteeIds.length; i++) {
      final dynamic menteeJson =
          await _getMenteeJsonByIndex(menteeIds.elementAt(i));
      Mentee user = Mentee(
        menteeJson["category"],
        menteeJson["email"],
        menteeJson["email_verified_at"],
        menteeJson["first_name"],
        menteeJson["last_name"],
        menteeJson["other_name"],
        menteeJson["country"],
        menteeJson["industry"],
        menteeJson["gender"],
        menteeJson["bio_interest"],
        menteeJson["phone"],
        menteeJson["state_of_origin"],
        menteeJson["fav_quote"],
        menteeJson["profile_image"],
        menteeJson["terms"],
        menteeJson["check_status"],
        menteeJson["current_job"],
        menteeJson["created_at"],
        menteeJson["updated_at"],
        menteeJson["social_id"],
        menteeJson["id"],
        getFromList(menteeJson["employment"], 'company'),
        getFromList(menteeJson['employment'], 'position'),
        getFromList(menteeJson['education'], 'institution'),
        getFromList(menteeJson['education'], 'degree'),
      );

      users.add(user);
    }
    return users;
  }

  String getFromList(Map<String, dynamic> json, String key) {
    return json != null ? json[key] : "";
  }
}
