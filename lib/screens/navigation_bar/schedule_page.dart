import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maf_mentor/model/mentee.dart';
import 'package:maf_mentor/model/schedule.dart';
import 'package:maf_mentor/route_animations/slide_from_right_page_route.dart';
import 'package:maf_mentor/screens/animations/shimmer_layout.dart';
import 'package:maf_mentor/screens/utils/auth.dart';
import 'package:maf_mentor/screens/schedule_meeting.dart';
import 'package:maf_mentor/screens/utils/network.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:strings/strings.dart';

class SchedulePage extends StatefulWidget {
  var mentorId;
  Iterable menteeIds;
  SchedulePage(
      {Key key,
        this.menteeIds, this.mentorId})
      : super(key: key);
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {

  Iterable menteeIds;
  List<Mentee> users = [];
  List<Mentee> menteeUsers = [];
  Future _future;
  bool isList = true;
  bool isProfileImgRetrieved = false;
  List<Schedule> scheduleList = [];
  int offset = 0;
  int time = 800;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _future = fetchLatestScheduleList();
    _updateListOfMentees(widget.menteeIds);
  }

  @override
  Widget build(BuildContext context) {
    final noScheduleText = Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Container(
          child: Text(
            "Your schedule list is empty",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF004782),
              fontFamily: 'Muli',
              fontSize: 15.0,
            ),
          ),
        ),
      ),
    );

    final scheduleUpdatedList = new FutureBuilder(
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
              itemCount: scheduleList.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(
                            int.parse(extractColor(scheduleList[index].color))),
                        border: Border.all(
                          color: Color(int.parse(
                              extractColor(scheduleList[index].color))),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(bottom: 20.0, top: 12.0),
                        child: Text(
                            DateFormat("EEEE, dd, MMMM, yyyy").format(
                                DateTime.parse(scheduleList[index].start_date)),
                            style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontFamily: 'Muli',
                              fontSize: 11.0,
                            )),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Text(capitalize(scheduleList[index].title),
                            style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontFamily: 'Muli',
                              fontSize: 15.0,
                            )),
                      ),
                      trailing: CircleAvatar(
                        backgroundColor: Color(0xFFEBAD03),
                        radius: 24,
                        child: ClipOval(
                            child: Image.network(
                          isProfileImgRetrieved
                              ? NetworkUtils.host +
                                  AuthUtils.profilePics +
                                  users[index].profile_image
                              : AuthUtils.defaultProfileImg,
                          fit: BoxFit.cover,
                          width: 45.0,
                          height: 45.0,
                        )),
                      ),
                      onTap: () {},
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(6.0),
        child: FloatingActionButton(
          onPressed: () => {
            showMenteeList()
          },
          child: Icon(MdiIcons.plus),
          backgroundColor: Color(0xFF1C2447),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(
            left: 16.0, right: 16.0, top: 30.0, bottom: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isList ? scheduleUpdatedList : noScheduleText,
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }

  Future fetchLatestScheduleList() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var uri = NetworkUtils.host + AuthUtils.latestSchedule;
    try {
      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + sharedPreferences.get("token"),
        },
      );
      final responseJson = json.decode(response.body);
      for (var u in responseJson["data"]) {
        Schedule schedule = Schedule(
            u["id"],
            u["mentee_id"],
            u["mentor_id"],
            u["initiator"],
            u["title"],
            u["color"],
            u["scheduled_time"],
            u["start_date"],
            u["end_date"],
            u["status"],
            u["created_at"],
            u["updated_at"]);
        scheduleList.add(schedule);
        setState(() {
          menteeIds = scheduleList.map((Schedule) => Schedule.mentee_id);
          _updateUserList(menteeIds);
        });
      }
      if (scheduleList.length > 0) {
        setState(() {
          isList = true;
        });
      } else {
        setState(() {
          isList = false;
        });
      }
      return responseJson;
    } catch (exception) {
      print(exception);
    }
  }

  extractColor(String string) {
    if (string.contains("MaterialColor")) {
      return string
          .replaceAll("MaterialColor(primary value: Color(", '')
          .replaceAll(")", '');
    } else {
      return "0xff" + string.replaceAll("#", '');
    }
  }

  Future<List<Mentee>> _updateUserList(Iterable user) async {
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
    if (users.length != 0) {
      setState(() {
        isProfileImgRetrieved = true;
      });
    }
    return users;
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

  String getFromList(Map<String, dynamic> json, String key) {
    return json != null ? json[key] : "";
  }
  showMenteeList() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Color(0xFFCEFF1FF),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0))),
        builder: (context) {
          return FutureBuilder(
              future: Future.delayed(Duration(seconds: 1), () => 1),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container(
                    child: CircularProgressIndicator(),
                    alignment: FractionalOffset.center,
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 30.0, left: 12.0, right: 12.0),
                  child: ListView.separated(
                    separatorBuilder: (BuildContext context, int index) => Divider(
                      color: Color(0xFF041F36),
                    ),
                    itemCount: menteeUsers.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: CircleAvatar(
                          maxRadius: 23,
                          backgroundImage: NetworkImage(NetworkUtils.host +
                              AuthUtils.profilePics +
                              menteeUsers[index].profile_image),
                        ),
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                              menteeUsers[index].first_name + " " + users[index].last_name,
                              style: TextStyle(
                                color: Color(0xFF041F36),
                                fontFamily: 'Muli',
                                fontSize: 16.0,
                              )),
                        ),
                        subtitle: Text(
                            menteeUsers[index].industry,
                            style: TextStyle(
                              color: Color(0xFF041F36),
                              fontFamily: 'MuliItalic',
                              fontSize: 12.5,
                            )),
                        trailing: Text(capitalize(menteeUsers[index].country),
                            style: TextStyle(
                              color: Color(0xFF25282A),
                              fontFamily: 'MuliItalic',
                              fontSize: 12.0,
                            )),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context, SlideFromRightPageRoute(widget:
                          ScheduleMeeting(menteeUsers[index], menteeUsers[index].first_name +
                              " " + menteeUsers[index].last_name, widget.mentorId)));
                        },
                      );
                    },
                  ),
                );
              });
        });
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

      menteeUsers.add(user);
    }
    return users;
  }
}
