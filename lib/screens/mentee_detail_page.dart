import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:maf_mentor/model/mentee.dart';
import 'package:maf_mentor/model/mentorIndex.dart';
import 'package:maf_mentor/route_animations/slide_from_right_page_route.dart';
import 'package:maf_mentor/screens/chat_screen.dart';
import 'package:maf_mentor/screens/schedule_meeting.dart';
import 'package:maf_mentor/screens/utils/auth.dart';
import 'package:maf_mentor/screens/utils/network.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strings/strings.dart';

class MenteeDetailPage extends StatefulWidget {
  Mentee user;
  var id;
  dynamic status;
  String names;
  var mentorId;
  int index;
  MenteeDetailPage(this.index, this.user, this.id,
      this.status, this.names, this.mentorId);

  @override
  _MenteeDetailPageState createState() => _MenteeDetailPageState();
}

class _MenteeDetailPageState extends State<MenteeDetailPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<MentorIndex> mentorIndexes = [];
  Color colorDynamic;
  String strText;
  ProgressDialog pr;
  Iterable statusRetrieve;

  @override
  void initState() {
    super.initState();
    colorDynamic = Color(0xFF004782);
    strText = "Request Mentorship";
    _fetchIndex();
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    //Dialog Style
    pr.style(
      message: "Please wait...",
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(
        strokeWidth: 3,
      ),
      elevation: 10.0,
      insetAnimCurve: Curves.bounceIn,
      progressTextStyle: TextStyle(color: Color(0xFF1C2447), fontSize: 14.0),
      messageTextStyle: TextStyle(color: Color(0xFF1C2447), fontSize: 14.0),
    );

    final userImg = CircleAvatar(
      radius: 70,
      backgroundColor: Color(0xff004782),
      child: ClipOval(
        child: new SizedBox(
          width: 133.0,
          height: 133.0,
          child:  Image.network(
            widget.user.profile_image!="noimage.jpg"?  NetworkUtils.host +
                AuthUtils.profilePics +
                widget.user.profile_image : AuthUtils.defaultProfileImg,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
    final username = Text(
      "${capitalize(widget.user.first_name) + " " +
          capitalize(widget.user.last_name)}",
      style: TextStyle(
        color: Color(0xFF1C2447),
        fontFamily: 'Muli',
        fontSize: 22.0,
      ),
    );
    final workText = Text(
      "${capitalize(widget.user.industry == null ? "Lifestyle" : widget.user.industry)}",
      style: TextStyle(
        color: Color(0xFF25282A),
        fontFamily: 'MuliLight',
        fontSize: 14.0,
      ),
    );
    final location = Text(
      "${capitalize(widget.user.country)}",
      style: TextStyle(
        color: Color(0xFF004884),
        fontFamily: 'MuliRegular',
        fontSize: 14.0,
      ),
    );
    final motto = Text(
      "${capitalize(
          widget.user.bio_interest!= null?NetworkUtils.truncateWithEllipsis(50, widget.user.bio_interest): "Not yet set")}",
      style: TextStyle(
        color: Color(0xFF004884),
        fontFamily: 'Muli',
        fontSize: 14.0,
      ),
      textAlign: TextAlign.center,
    );

    final divider = new Divider();
    final acceptedBtn = Container(
      height: 50.0,
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.only(left: 50.0, right: 50.0),
        decoration: BoxDecoration(
            border: Border.all(
                color: Colors.white, style: BorderStyle.solid, width: 1.0),
            color: Color(0xFF75C97B),
            borderRadius: BorderRadius.circular(20.0)),
        child: InkWell(
          onTap: () {

          },
          child: Center(
            child: Text('Accepted',
                style: TextStyle(color: Colors.white, fontFamily: 'Muli')),
          ),
        ),
      ),
    );
    final acceptRejectBtns =  Row(children: <Widget>[
      Expanded(
        child: RaisedButton(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: new Text(
              "Accept",
              style: new TextStyle(
                  color: Colors.white,
                  fontFamily: 'Muli'
              ),
            ),
          ),
          textColor: Color(0xffffffff),
          color: Color(0xff3F82B9),
          onPressed: () => _acceptRequest(context),
        ),
      ),
      SizedBox(
        width: 3.0,
      ),
      Expanded(
        child: RaisedButton(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: new Text(
                "Reject",
                style: new TextStyle(
                    color: Colors.white,
                    fontFamily: 'Muli'
                ),
              ),
            ),
            textColor: Color(0xffffffff),
            color: Color(0xff898989),
            onPressed: () => _declineRequest(context)
        ),
      ),
    ]);
    final rowButtons =  Row(children: <Widget>[
      Expanded(
        child: RaisedButton(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: new Text(
              "Start Chat",
              style: new TextStyle(
                  color: Colors.white,
                  fontFamily: 'Muli'
              ),
            ),
          ),
          textColor: Color(0xffffffff),
          color: Color(0xff3F82B9),
          onPressed: () => Navigator.push(context, SlideFromRightPageRoute(widget: ChatPage(widget.user, widget.mentorId))),
        ),
      ),
      SizedBox(
        width: 3.0,
      ),
      Expanded(
        child: RaisedButton(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: new Text(
                "Start Schedule",
                style: new TextStyle(
                    color: Colors.white,
                    fontFamily: 'Muli'
                ),
              ),
            ),
            textColor: Color(0xffffffff),
            color: Color(0xff898989),
            onPressed: () => Navigator.push(
                context, SlideFromRightPageRoute(widget: ScheduleMeeting(widget.user, widget.names, widget.mentorId)))
        ),
      ),
    ]);
    final favorite = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Icon(
          Icons.favorite,
          color: Color(0xff1A5893),
          size: 16.0,
        ),
        SizedBox(
          width: 20.0,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('Fav Quote',
                  style: TextStyle(
                      color: Color(0xff1A5893),
                      fontFamily: 'MuliLight',
                      fontSize: 14.0)),
              SizedBox(
                height: 5.0,
              ),
              Text(
                  widget.user.fav_quote!=null ? NetworkUtils.truncateWithEllipsis(120, capitalize(widget.user.fav_quote)): "Not yet set",
                  style: TextStyle(
                      color: Color(0xff1A5893),
                      fontFamily: 'Muli',
                      fontSize: 14.0)),
            ],
          ),
        )
      ],
    );
    final work = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Icon(
          Icons.work,
          color: Color(0xff1A5893),
          size: 16.0,
        ),
        SizedBox(
          width: 14.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text('Work',
                style: TextStyle(
                    color: Color(0xff1A5893),
                    fontFamily: 'MuliLight',
                    fontSize: 14.0)),
            SizedBox(
              height: 5.0,
            ),
            Text(widget.user.company!=""? capitalize(widget.user.company):"Company not set",
                style: TextStyle(
                    color: Color(0xff1A5893),
                    fontFamily: 'Muli',
                    fontSize: 14.0)),
            SizedBox(
              height: 5.0,
            ),
            Text(widget.user.position!=""? capitalize(widget.user.position):"Position not set",
                style: TextStyle(
                    color: Color(0xff1A5893),
                    fontFamily: 'Muli',
                    fontSize: 14.0)),
          ],
        )
      ],
    );
    final education = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Center(
          child: Icon(
            Icons.school,
            color: Color(0xff1A5893),
            size: 16.0,
          ),
        ),
        SizedBox(
          width: 14.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text('Education info',
                style: TextStyle(
                    color: Color(0xff1A5893),
                    fontFamily: 'MuliLight',
                    fontSize: 14.0)),
            SizedBox(
              height: 5.0,
            ),
            Text(widget.user.institution!=""? capitalize(widget.user.institution):"Institution not set",
                style: TextStyle(
                    color: Color(0xff1A5893),
                    fontFamily: 'Muli',
                    fontSize: 14.0)),
            SizedBox(
              height: 5.0,
            ),
            Text(widget.user.degree!=""? capitalize(widget.user.degree):"Degree not set",
                style: TextStyle(
                    color: Color(0xff1A5893),
                    fontFamily: 'Muli',
                    fontSize: 14.0)),
          ],
        )
      ],
    );
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          backgroundColor: Color(0xFFFFFFFF),
          automaticallyImplyLeading: true,
          //`true` if you want Flutter to automatically add Back Button when needed,
          //or `false` if you want to force your own back button every where
          title: Text(
            'Profile',
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
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding:
          EdgeInsets.only(left: 24.0, right: 24.0, top: 0.0, bottom: 50.0),
          children: <Widget>[
            SizedBox(
              height: 20.0,
            ),
            Center(child: userImg),
            SizedBox(
              height: 20.0,
            ),
            Center(child: username),
            SizedBox(
              height: 12.0,
            ),
            Center(child: workText),
            SizedBox(
              height: 10.0,
            ),
            Center(
              child: location,
            ),
            SizedBox(
              height: 12.0,
            ),
            Center(child: motto),
            SizedBox(
              height: 20.0,
            ),
            Center(child: divider),
            SizedBox(
              height: 20.0,
            ),
            Center(child: favorite),
            SizedBox(
              height: 30.0,
            ),
            Center(child: work),
            SizedBox(
              height: 30.0,
            ),
            Center(child: education),
            SizedBox(
              height: 70.0,
            ),
            widget.status == null  || widget.status == "0" ? Center(child: acceptRejectBtns) : Center(child: rowButtons)
          ],
        ),
      ),
    );
  }

  _acceptRequest(BuildContext context) async {
    pr.show();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
// set up PATCH request arguments
    // make PATCH request
    Map data = {'status': "1"};
    var jsonResponse = null;
    try{
      Response response = await patch(NetworkUtils.host + AuthUtils.endPointSession + widget.id.toString(), headers: {'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer ' + sharedPreferences.get("token"), },
          body: data);
      jsonResponse = json.decode(response.body);
     pr.hide();
      if (response.statusCode == 200 || response.statusCode == 201) {
        if(jsonResponse!=null){
          NetworkUtils.showToast("Mentee request accepted");
       setState(() {
         widget.status = "1";
       });
        }
      } else if(response.statusCode == 404){
        NetworkUtils.showSnackBar(_scaffoldKey, "The requested resource does no longer exist");
      }
      return jsonResponse;
    } catch (exception) {
      if (exception.toString().contains('The requested resource does not exist')) {
        NetworkUtils.showSnackBar(_scaffoldKey, "The requested resource does not exist");
      }
    }

  }

  _declineRequest(BuildContext context) async{
    pr.show();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
// set up PATCH request arguments
    // make PATCH request
    Map data = {'status': "0"};
    var jsonResponse = null;
    try{
    Response response = await patch(NetworkUtils.host + AuthUtils.endPointSession + widget.id.toString(), headers: {'Accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer ' + sharedPreferences.get("token"), },
        body: data);
    jsonResponse = json.decode(response.body);
    pr.hide();
    if (response.statusCode == 200 || response.statusCode == 201) {
      if(jsonResponse!=null){
        NetworkUtils.showRedToast("Mentee request declined");
        Navigator.pop(context);
        print(jsonResponse.toString());
      }
    } else if(response.statusCode == 404){
      NetworkUtils.showSnackBar(_scaffoldKey, "The requested resource does no longer exist");
    }
    return jsonResponse;
    } catch (exception) {
      if (exception.toString().contains('The requested resource does not exist')) {
      NetworkUtils.showSnackBar(_scaffoldKey, "The requested resource does not exist");
      }
    }
  }
  Future _fetchIndex() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var uri = NetworkUtils.host + AuthUtils.endPointIndex;
    try {
      final response = await http.get(
        uri,
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json','Authorization': 'Bearer ' + sharedPreferences.get("token"), },
      );
      final responseJson = json.decode(response.body);
      for (var u in responseJson["data"]) {
        MentorIndex user = MentorIndex(
            u["id"],
            u["mentor_id"],
            u["mentee_id"],
            u["status"],
            u["session_count"],
            u["current_job"],
            u["email"],
            u["phone_call"],
            u["video_call"],
            u["face_to_face"],
            u["created_at"],
            u["updated_at"]);

        mentorIndexes.add(user);
        setState((){
          statusRetrieve = mentorIndexes.map((MentorIndex) => MentorIndex.status);
        });
      }
      if(statusRetrieve.elementAt(widget.index) == "1"){
        setState(() {
          widget.status = "1";
        });
      } else{
        setState(() {
          widget.status = "0";
        });
      }
      return responseJson;
    } catch (exception) {
      print(exception);
    }
  }
}

