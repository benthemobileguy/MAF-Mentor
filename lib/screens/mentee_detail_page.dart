import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maf_mentor/model/mentee.dart';
import 'package:maf_mentor/route_animations/slide_from_right_page_route.dart';
import 'package:maf_mentor/screens/chat_screen.dart';
import 'package:maf_mentor/screens/schedule_meeting.dart';
import 'package:maf_mentor/screens/utils/auth.dart';
import 'package:maf_mentor/screens/utils/network.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strings/strings.dart';

class MenteeDetailPage extends StatefulWidget {
  Mentee user;
  var id;
  dynamic status;
  String names;
  var mentorId;
  MenteeDetailPage(this.user, this.id, this.status, this.names, this.mentorId);

  @override
  _MenteeDetailPageState createState() => _MenteeDetailPageState();
}

class _MenteeDetailPageState extends State<MenteeDetailPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static List<Mentee> mentorIndexes = [];
  File _image;
  Color colorDynamic;
  String strText;

  @override
  void initState() {
    super.initState();
    colorDynamic = Color(0xFF004782);
    strText = "Request Mentorship";
  }

  @override
  Widget build(BuildContext context) {
    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        _image = image;
        print('Image Path $_image');
      });
    }

    Future uploadPic(BuildContext context) async {
      //file name
      String fileName = basename(_image.path);
      setState(() {
        print("Profile Picture uploaded");
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
      });
    }

    final userImg = CircleAvatar(
      radius: 70,
      backgroundColor: Color(0xff004782),
      child: ClipOval(
        child: new SizedBox(
          width: 133.0,
          height: 133.0,
          child: (_image != null)
              ? Image.file(
            _image,
            fit: BoxFit.fill,
          )
              : Image.network(
            NetworkUtils.host +
                AuthUtils.profilePics +
                widget.user.profile_image,
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
          NetworkUtils.truncateWithEllipsis(50, widget.user.bio_interest))}",
      style: TextStyle(
        color: Color(0xFF004884),
        fontFamily: 'Muli',
        fontSize: 14.0,
      ),
      textAlign: TextAlign.center,
    );
    final sendRequestBtn = Container(
      height: 50.0,
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.only(left: 50.0, right: 50.0),
        decoration: BoxDecoration(
            border: Border.all(
                color: Colors.white, style: BorderStyle.solid, width: 1.0),
            color: colorDynamic,
            borderRadius: BorderRadius.circular(20.0)),
        child: InkWell(
          onTap: () {
            if (strText == "Cancel Mentorship") {
              NetworkUtils.showSnackBar(_scaffoldKey,
                  "You cannot cancel mentoship request at this time");
            } else {

            }
          },
          child: Center(
            child: Text(strText,
                style: TextStyle(color: Colors.white, fontFamily: 'Muli')),
          ),
        ),
      ),
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
    final rowButtons =  Row(children: <Widget>[
      Expanded(
        child: RaisedButton(
          child: new Text(
            "Start Chat",
            style: new TextStyle(
                color: Colors.white,
                fontFamily: 'Muli'
            ),
          ),
          textColor: Color(0xffffffff),
          color: Color(0xff3F82B9),
          onPressed: () => Navigator.push(context, SlideFromRightPageRoute(widget: ChatPage(widget.user))),
        ),
      ),
      SizedBox(
        width: 3.0,
      ),
      Expanded(
        child: RaisedButton(
            child: new Text(
              "Start Schedule",
              style: new TextStyle(
                  color: Colors.white,
                  fontFamily: 'Muli'
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
                  NetworkUtils.truncateWithEllipsis(120, widget.user.fav_quote),
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
            Text("Work at Star Company",
                style: TextStyle(
                    color: Color(0xff1A5893),
                    fontFamily: 'Muli',
                    fontSize: 14.0)),
            SizedBox(
              height: 5.0,
            ),
            Text("Position: Designer",
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
            Text("Studied at Booky institute",
                style: TextStyle(
                    color: Color(0xff1A5893),
                    fontFamily: 'Muli',
                    fontSize: 14.0)),
            SizedBox(
              height: 5.0,
            ),
            Text("Degree: Phd",
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
            widget.status == null  || widget.status == "0" ? Center(child: rowButtons) : Center(child: rowButtons)
          ],
        ),
      ),
    );
  }

  _acceptRequest(BuildContext context) async {
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
      print(jsonResponse.toString());
      if (response.statusCode == 200 || response.statusCode == 201) {
        if(jsonResponse!=null){
          NetworkUtils.showToast("Mentee request accepted");
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

  _declineRequest(BuildContext context) async{
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
    print(jsonResponse.toString());
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
}

