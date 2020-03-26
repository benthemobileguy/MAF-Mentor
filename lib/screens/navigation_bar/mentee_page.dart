import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:maf_mentor/model/mentee.dart';
import 'package:maf_mentor/route_animations/slide_from_right_page_route.dart';
import 'package:maf_mentor/screens/animations/shimmer_layout.dart';
import 'package:maf_mentor/screens/mentee_detail_page.dart';
import 'package:maf_mentor/screens/utils/auth.dart';
import 'package:maf_mentor/screens/utils/network.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:strings/strings.dart';

class MenteePage extends StatefulWidget {
  final Iterable menteeIds;
  final Iterable indexIds;
  final Iterable sessionStatus;
  final String names;
  var mentorId;
  MenteePage(
      {Key key,
      this.menteeIds,
      this.indexIds,
      this.sessionStatus,
      this.names,
      this.mentorId})
      : super(key: key);

  @override
  _MenteePageState createState() => _MenteePageState();
}

class _MenteePageState extends State<MenteePage> {
  Future _future;
  List<Mentee> users = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _future = _updateListOfMentees(widget.menteeIds);
  }

  @override
  Widget build(BuildContext context) {
    int offset = 0;
    int time = 800;
    final noConnectionsText = Center(
      child: Container(
        child: Text(
          "You have no connections yet",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF004782),
            fontFamily: 'Muli',
            fontSize: 15.0,
          ),
        ),
      ),
    );

    final menteeList = new FutureBuilder(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data == null) {
          return Flexible(
            child: ListView.builder(
              itemCount: 4,
              itemBuilder: (BuildContext context, int index) {
                offset += 5;
                time = 800 + offset;

                return Shimmer.fromColors(
                  highlightColor: Colors.white,
                  baseColor: Colors.grey[200],
                  child: ShimmerLayout(),
                  period: Duration(milliseconds: time),
                );
              },
            ),
          );
        } else {
          return Flexible(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: CircleAvatar(
                    maxRadius: 23,
                    backgroundImage: NetworkImage(
                        users[index].profile_image != "noimage.jpg"
                            ? NetworkUtils.host +
                                AuthUtils.profilePics +
                                snapshot.data[index].profile_image
                            : AuthUtils.defaultProfileImg),
                  ),
                  title: Text(
                      users[index].first_name + " " + users[index].last_name,
                      style: TextStyle(
                        color: Color(0xFF041F36),
                        fontFamily: 'Muli',
                        fontSize: 16.0,
                      )),
                  subtitle: Text(
                      capitalize(users[index].industry == null
                          ? 'Lifestyle'
                          : users[index].industry),
                      style: TextStyle(
                        color: Color(0xFF25282A),
                        fontFamily: 'MuliBold',
                        fontSize: 12.0,
                      )),
                  trailing: Text(capitalize(users[index].country),
                      style: TextStyle(
                        color: Color(0xFF25282A),
                        fontFamily: 'MuliItalic',
                        fontSize: 12.0,
                      )),
                  onTap: () {
                    Navigator.push(
                        context,
                        SlideFromRightPageRoute(
                            widget: MenteeDetailPage(
                                index,
                                users[index],
                                widget.indexIds.elementAt(index),
                                widget.sessionStatus.elementAt(index),
                                widget.names,
                                widget.mentorId)));
                  },
                );
              },
            ),
          );
        }
      },
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(
            left: 16.0, right: 16.0, top: 30.0, bottom: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.menteeIds != null ? menteeList : noConnectionsText,
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
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
          await _getMenteeJsonByIndex(menteeIds.elementAt(i).toString());
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
