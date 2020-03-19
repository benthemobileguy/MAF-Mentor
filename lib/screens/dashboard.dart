import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:maf_mentor/locator.dart';
import 'package:maf_mentor/model/mentorIndex.dart';
import 'package:maf_mentor/model/user.dart';
import 'package:maf_mentor/route_animations/slide_from_right_page_route.dart';
import 'package:maf_mentor/screens/navigation_bar/home_page.dart';
import 'package:flutter/services.dart';
import 'package:maf_mentor/screens/navigation_bar/mentee_page.dart';
import 'package:maf_mentor/screens/navigation_bar/resources_page.dart';
import 'package:maf_mentor/screens/login.dart';
import 'package:maf_mentor/screens/navigation_bar/schedule_page.dart';
import 'package:maf_mentor/screens/profile_update_screen.dart';
import 'package:maf_mentor/screens/toolbar/notification_page.dart';
import 'package:maf_mentor/screens/toolbar/profile_page.dart';
import 'package:maf_mentor/screens/utils/auth.dart';
import 'package:maf_mentor/screens/utils/network.dart';
import 'package:maf_mentor/screens/utils/shared_pref.dart';
import 'package:maf_mentor/services/push_notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:maf_mentor/model/tab_options.dart';
import 'package:strings/strings.dart';

class DashBoardPage extends StatefulWidget {
  @override
  _DashBoardPageState createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  final PushNotificationService _pushNotificationService =
  locator<PushNotificationService>();
  bool isUpdateProfile = true;
  bool isAdminVerified = true;
  List<MentorIndex> mentorIndexes = [];
  SharedPreferences sharedPreferences;
  Iterable newList;
  Iterable status;
  String names = "";
  Iterable indexIds;
  SharedPref sharedPref = SharedPref();
  bool showTabs = true;
  int tabsIndex = 0;
  String _firstName = "";
  String _lastName = "";
  String _nationality = "";
  String _fav_quote = "";
  String _industry = "";
  String _isAdmin = "";
  String _company;
  String _degree;
  String _institution;
  String _position;
  String _state_of_origin;
  String _linkedin;
  String _phone_number;
  String _bio_interest = "";
  String _email = "";
  String _profile_image = "";
  int _currentIndex = 0;
  var id;
  String _appBarText = "Welcome";
  Future _future;
  Widget pendingVerification (){
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, top: 30.0, bottom: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Center(
                    child: new Image.asset(
                      'assets/images/dashboard_arrow.png',
                      width: 25.0,
                      height: 25.0,
                    ),
                  ),
                  Expanded(
                    child: FlatButton(
                      child: new Text(
                        "Your account is under review by admin and would become fully active after approval.",
                        style: new TextStyle(
                            color: Color(0xFFCB4250 ),
                            fontSize: 14,
                            fontFamily: 'Muli'
                        ),
                      ),
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                      textColor: Color(0xFFCB4250),
                      color: Color(0xFFFFFFFF),
                      onPressed: () => null,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Expanded( //makes the red row full width
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "A mentor is someone who allows you to see the hope inside yourself",
                        style: TextStyle(
                          fontFamily: 'Muli',
                          fontSize: 14.5,
                          color: Color(0xff1C2447),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        "-Oprah Winfrey",
                        style: TextStyle(
                          fontFamily: 'MuliLight',
                          fontSize: 12,
                          color: Color(0xff1C2447),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )

              ),
            ],
          ),
        ));
  }
  Widget updateProfile (){
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, top: 30.0, bottom: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: <Widget>[
                  Center(
                    child: new Image.asset(
                      'assets/images/dashboard_arrow.png',
                      width: 25.0,
                      height: 25.0,
                    ),
                  ),
                  Expanded(
                    child: FlatButton(
                      child: new Text(
                        "Welcome aboard, " + _firstName + ". Let's get to know you, "
                            "complete your profile here to use our platform.",
                        style: new TextStyle(
                            color: Color(0xFFCB4250 ),
                            fontSize: 14,
                            fontFamily: 'Muli'
                        ),
                      ),
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                      textColor: Color(0xFFCB4250),
                      color: Color(0xFFFFFFFF),
                      onPressed: () => Navigator.push(context, SlideFromRightPageRoute(widget: ProfileUpdatePage(first_name: _firstName,
                          last_name: _lastName,
                          country:_nationality,
                          phone_number:_phone_number,
                          email: _email,
                          profile_image: _profile_image))),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Expanded( //makes the red row full width
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "A mentor is someone who allows you to see the hope inside yourself",
                        style: TextStyle(
                          fontFamily: 'Muli',
                          fontSize: 14.5,
                          color: Color(0xff1C2447),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        "-Oprah Winfrey",
                        style: TextStyle(
                          fontFamily: 'MuliLight',
                          fontSize: 12,
                          color: Color(0xff1C2447),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )

              ),
            ],
          ),
        ));
  }
  Widget callPage(int currentIndex) {
    switch (currentIndex) {
      case 0:
        showTabs = true;
        _appBarText = "Welcome, " + _firstName;
        return TabBarView(
            children: [new HomePage(), new SchedulePage()]);
        break;
      case 1:
        showTabs = false;
        _appBarText = "Mentoring Board";
        return MenteePage(menteeIds: newList,
            indexIds: indexIds, names:names, sessionStatus: status, mentorId:id);
        break;
      case 2:
        showTabs = false;
        _appBarText = "Resources";
        return ResourcesPage();
        break;
      default:
        return HomePage();
    }
  }

  @override
  void initState() {
    super.initState();
    checkLoginState();
    _future = fetchIndex();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MAF Mentor',
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: choices.length,
        child: WillPopScope(
          onWillPop: onWillPop,
       child: Scaffold(
          appBar: AppBar(
            leading: _currentIndex!= 0 ? new IconButton(
              icon: new Icon(Icons.arrow_back, color: Color(0xFF1C2447)),
              onPressed: () =>onWillPop(),
            ) : null,
            backgroundColor: Color(0xFFFFFFFF),
            title: Text(
              _appBarText,
              style: TextStyle(
                color: Color(0xFF1C2447),
                fontFamily: 'Muli',
                fontSize: 16.0,
              ),
            ),
            bottom: showTabs
                ? TabBar(
                    isScrollable: true,
                    tabs: choices.map<Widget>((Choice choice) {
                      return Tab(
                        text: choice.title,
                        icon: Icon(choice.icon),
                      );
                    }).toList(),
                    labelColor: Color(0xFF1C2447),
                  )
                : null,
            actions: <Widget>[
              GestureDetector(
                onTap: () {
                  var route = new MaterialPageRoute(
                    builder: (context) => new ProfilePage(
                        names: capitalize(_firstName) +
                            " " +
                            capitalize(_lastName),
                        state: _state_of_origin != null?  capitalize(_state_of_origin) : "",
                        linkedin: _linkedin != null?  capitalize(_linkedin) : "",
                        company:_company != null?  capitalize(_company) : "",
                        degree: _degree != null?  capitalize(_degree) : "",
                        position: _position != null?  capitalize(_position) : "",
                        institution: _institution != null?  capitalize(_institution) : "",
                        nationality: _nationality != null?  capitalize(_nationality) : "",
                        bio:
                        _bio_interest != null ? NetworkUtils.truncateWithEllipsis(80, _bio_interest): "",
                        fav_quote:
                        _fav_quote != null ? NetworkUtils.truncateWithEllipsis(80, _fav_quote): "",
                        industry: _industry !=null ? capitalize(_industry) : "",
                        profile_image: _profile_image,
                        first_name: _firstName != "" ? _firstName: "",
                        last_name: _lastName!=null? _lastName: "",
                        phone: _phone_number!= null? _phone_number: "",
                        email: _email!=null? _email: ""),
                  );
                  Navigator.of(context).pushReplacement(route);
                },
                child: CircleAvatar(
                  backgroundColor: Color(0xFF1C2447),
                  radius: 17,
                  child: ClipOval(
                      child: Image.network(
                        _profile_image =="noimage.jpg" ?
                        AuthUtils.defaultProfileImg + _profile_image: NetworkUtils.host + AuthUtils.profilePics + _profile_image,
                        fit: BoxFit.cover,
                        width: 30.0,
                        height: 30.0,
                      )
                  ),
                ),
              ),
              SizedBox(
                width: 14,
              ),
              Material(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        SlideFromRightPageRoute(widget: NotificationsPage()));
                  },
                  child: Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.asset('assets/images/notification.png',
                          width: 30.0, height: 30.0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ), //AppBar
          body: isUpdateProfile && isAdminVerified ? callPage(_currentIndex): isUpdateProfile && !isAdminVerified ? pendingVerification(): updateProfile(),
          bottomNavigationBar: BottomNavigationBar(
            showSelectedLabels: false,
            showUnselectedLabels: false,
            fixedColor: Color(0xFF1C2447),
            currentIndex: _currentIndex,
            onTap: (value) {
              _currentIndex = value;
              callPage(_currentIndex);
              setState(() {
                switch (_currentIndex) {
                  case 0:
                    showTabs = true;
                    break;
                  case 1:
                    showTabs = false;
                    break;
                  case 2:
                    showTabs = false;
                    break;
                }
              });
            },
            items: [
              BottomNavigationBarItem(
                  icon: _currentIndex == 0
                      ? new Image.asset(
                          'assets/images/home_active.png',
                          height: 28,
                          width: 28,
                        )
                      : new Image.asset(
                          'assets/images/home_idle.png',
                          height: 28,
                          width: 28,
                        ),
                  title: Text("Home")),
              BottomNavigationBarItem(
                  icon: _currentIndex == 1
                      ? new Image.asset(
                          'assets/images/group_active.png',
                          height: 28,
                          width: 28,
                        )
                      : new Image.asset(
                          'assets/images/group_idle.png',
                          height: 28,
                          width: 28,
                        ),
                  title: Text("Group")),
              BottomNavigationBarItem(
                  icon: _currentIndex == 2
                      ? new Image.asset(
                          'assets/images/resource_active.png',
                          height: 28,
                          width: 28,
                        )
                      : new Image.asset(
                          'assets/images/resource_idle.png',
                          height: 28,
                          width: 28,
                        ),
                  title: Text("Resource")),
            ],
          ),
        ),
        ),
      ),
    );
  }

  Future checkLoginState() async {
    await _pushNotificationService.initialise();
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
              (Route<dynamic> route) => false);
    } else {
      await NetworkUtils.fetch("Bearer " + sharedPreferences.getString("token"), AuthUtils.endPointProfile);
      //read value from shared preference
      User user = User.fromJson(await sharedPref.read("user"));
      setState(() {
        _appBarText = "Welcome, " + user.first_name;
        id = user.id;
        _firstName = user.first_name;
        _lastName = user.last_name;
        _isAdmin = user.isAdmin;
        _email = user.email;
        _phone_number = user.phone;
        _nationality = user.country;
        _fav_quote = user.fav_quote;
        _position = user.position;
        _institution = user.institution;
        _company = user.company;
        _degree = user.degree;
        _state_of_origin = user.state_of_origin;
        _linkedin = user.linkedin;
        _industry = user.industry;
        _bio_interest = user.bio_interest;
        _profile_image = user.profile_image;
        names = _firstName + " " + _lastName;
        _company = user.company;
        //check if user has updated profile
        checkUpdateProfile();
        checkAdminVerification();
      });
      try {
      } catch (Excepetion) {
        // do something
      }
    }
  }

  String truncateWithEllipsis(int cutoff, String myString) {
    return (myString.length <= cutoff)
        ? myString
        : '${myString.substring(0, cutoff)}...';
  }
   Future fetchIndex() async {
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
          newList = mentorIndexes.map((MentorIndex) => MentorIndex.mentee_id);
          indexIds = mentorIndexes.map((MentorIndex) => MentorIndex.id);
          status = mentorIndexes.map((MentorIndex) => MentorIndex.status);
        });
      }
      return responseJson;
    } catch (exception) {
      print(exception);
    }
  }
  Future checkUpdateProfile() async{
    if(_fav_quote == null || _industry == null || _bio_interest == null|| _fav_quote == "" || _industry == "" || _bio_interest == ""){
      setState(() {
        isUpdateProfile = false;
      });
    } else{
      setState(() {
        isUpdateProfile = true;
      });
    }
  }
  Future checkAdminVerification() async{
    if(_isAdmin == null){
      setState(() {
        isAdminVerified = false;
      });
    } else{
      setState(() {
        isAdminVerified = true;
      });
    }
  }
  Future<bool> onWillPop() {
    if (_currentIndex != 0) {
      Navigator.of(context).pushReplacementNamed('/dashboard');
    } else{
      //close the app
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }
  }
}
