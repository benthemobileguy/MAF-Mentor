import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maf_mentor/route_animations/slide_from_right_page_route.dart';
import 'package:maf_mentor/screens/upload_pic.dart';
import 'package:maf_mentor/screens/utils/network.dart';

class UpdateProfileData {
  String email = '';
  String country = '';
  String password = '';
  String confirm_password = '';
  String first_name = '';
  String last_name = '';
  String middle_name = '';
  String phone = '';
  String gender = '';
}

class ProfileUpdatePage extends StatefulWidget {
  final String first_name;
  final String last_name;
  final String country;
  final String phone_number;
  final String email;
  final String profile_image;

  const ProfileUpdatePage(
      {Key key,
        this.first_name,
        this.last_name,
        this.country,
        this.phone_number,
        this.email,
        this.profile_image})
      : super(key: key);
  @override
  _ProfileUpdatePageState createState() => _ProfileUpdatePageState();
}

class _ProfileUpdatePageState extends State<ProfileUpdatePage> {
  final int _numPages = 5;
  AnimationController animationController;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _first_name = TextEditingController();
  final TextEditingController _last_name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _fav_quote = TextEditingController();
  final TextEditingController _industry = TextEditingController();
  final TextEditingController _country = TextEditingController();
  final TextEditingController _bio = TextEditingController();
  final TextEditingController _state = TextEditingController();
  final TextEditingController _institution = TextEditingController();
  final TextEditingController _degree = TextEditingController();
  final TextEditingController _company = TextEditingController();
  final TextEditingController _jobPosition = TextEditingController();
  final TextEditingController _linkedinProfile = TextEditingController();
  UpdateProfileData _data = new UpdateProfileData();

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: isActive ? 13 : 9,
      width: isActive ? 25 : 25,
      decoration: BoxDecoration(
        color: isActive ? Color(0xFF5FCD5C) : Color(0xFFBDC4D3),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  var selected = 'Select Gender';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _first_name.text = widget.first_name;
    _last_name.text = widget.last_name;
    _country.text = widget.country;
    _phone.text = widget.phone_number;
    _email.text = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Color(0xFF1C2447), //modify arrow color from here..
          ),
          backgroundColor: Color(0xFFFFFFFF),
          title: Text("Update Profile",
              style: TextStyle(
                color: Color(0xFF1C2447),
                fontFamily: 'Muli',
                fontSize: 14,
              )),
        ),
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 0.0),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 600.0,
                    child: PageView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: _pageController,
                      onPageChanged: (int page) {
                        setState(() {
                          _currentPage = page;
                        });
                      },
                      children: <Widget>[
                        WillPopScope(
                          onWillPop: () => Future.sync(onWillPop),
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: ListView(
                              shrinkWrap: true,
                              children: <Widget>[
                                Text(
                                  "CONTACT AND PERSONAL INFO (1/2)",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontFamily: 'Muli',
                                    fontSize: 15.5,
                                  ),
                                ),
                                SizedBox(height: 20.0),
                                Text(
                                  'First Name',
                                  style: TextStyle(
                                      fontFamily: 'Muli',
                                      fontSize: 14.0,
                                      color: Color(0xFF004782)),
                                ),
                                SizedBox(height: 15.0),
                                TextField(
                                  controller: _first_name,
                                  style: TextStyle(fontFamily: 'OpenSans'),
                                  textCapitalization: TextCapitalization.sentences,
                                  textAlign: TextAlign.start,
                                  decoration: new InputDecoration(
                                    contentPadding: new EdgeInsets.symmetric(
                                        vertical: 12.0, horizontal: 12.0),
                                    border: new OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(10.0),
                                      ),
                                      borderSide: new BorderSide(
                                        color: Colors.black,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15.0),
                                Text(
                                  'Last Name',
                                  style: TextStyle(
                                      fontFamily: 'Muli',
                                      fontSize: 14.0,
                                      color: Color(0xFF004782)),
                                ),
                                SizedBox(height: 15.0),
                                TextField(
                                  controller: _last_name,
                                  style: TextStyle(fontFamily: 'OpenSans'),
                                  textCapitalization: TextCapitalization.sentences,
                                  textAlign: TextAlign.start,
                                  decoration: new InputDecoration(
                                    contentPadding: new EdgeInsets.symmetric(
                                        vertical: 12.0, horizontal: 12.0),
                                    border: new OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(10.0),
                                      ),
                                      borderSide: new BorderSide(
                                        color: Colors.black,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15.0),
                                Text(
                                  'Country',
                                  style: TextStyle(
                                      fontFamily: 'Muli',
                                      fontSize: 14.0,
                                      color: Color(0xFF004782)),
                                ),
                                SizedBox(height: 15.0),
                                TextField(
                                  controller: _country,
                                  readOnly: true,
                                  style: TextStyle(fontFamily: 'OpenSans'),
                                  textCapitalization: TextCapitalization.sentences,
                                  textAlign: TextAlign.start,
                                  decoration: new InputDecoration(
                                    contentPadding: new EdgeInsets.symmetric(
                                        vertical: 12.0, horizontal: 12.0),
                                    border: new OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(10.0),
                                      ),
                                      borderSide: new BorderSide(
                                        color: Colors.black,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 30.0, horizontal: 60),
                                  width: double.infinity,
                                  child: RawMaterialButton(
                                    padding: EdgeInsets.all(15.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    fillColor: Color(0xFF5FCD5C),
                                    onPressed: () {
                                      _save(_currentPage, context);
                                    },
                                    highlightColor: Colors.white,
                                    child: Text(
                                      'NEXT',
                                      style: TextStyle(
                                        color: Color(0xFFFFFFFF),
                                        letterSpacing: 2,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Gilroy',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        WillPopScope(
                          onWillPop: () => Future.sync(onWillPop),
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: ListView(
                              shrinkWrap: true,
                              children: <Widget>[
                                Text(
                                  "CONTACT AND PERSONAL INFO (2/2)",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontFamily: 'Muli',
                                    fontSize: 15.5,
                                  ),
                                ),
                                SizedBox(height: 20.0),
                                Text(
                                  'State',
                                  style: TextStyle(
                                      fontFamily: 'Muli',
                                      fontSize: 14.0,
                                      color: Color(0xFF004782)),
                                ),
                                SizedBox(height: 15.0),
                                TextField(
                                  controller: _state,
                                  style: TextStyle(fontFamily: 'OpenSans'),
                                  textCapitalization: TextCapitalization.sentences,
                                  textAlign: TextAlign.start,
                                  decoration: new InputDecoration(
                                    contentPadding: new EdgeInsets.symmetric(
                                        vertical: 12.0, horizontal: 12.0),
                                    border: new OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(10.0),
                                      ),
                                      borderSide: new BorderSide(
                                        color: Colors.black,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15.0),
                                Text(
                                  'Phone Number',
                                  style: TextStyle(
                                      fontFamily: 'Muli',
                                      fontSize: 14.0,
                                      color: Color(0xFF004782)),
                                ),
                                SizedBox(height: 15.0),
                                TextField(
                                  keyboardType: TextInputType.phone,
                                  controller: _phone,
                                  style: TextStyle(fontFamily: 'OpenSans'),
                                  textCapitalization: TextCapitalization.sentences,
                                  textAlign: TextAlign.start,
                                  decoration: new InputDecoration(
                                    contentPadding: new EdgeInsets.symmetric(
                                        vertical: 12.0, horizontal: 12.0),
                                    border: new OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(10.0),
                                      ),
                                      borderSide: new BorderSide(
                                        color: Colors.black,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15.0),
                                Text(
                                  'Email Address',
                                  style: TextStyle(
                                      fontFamily: 'Muli',
                                      fontSize: 14.0,
                                      color: Color(0xFF004782)),
                                ),
                                SizedBox(height: 15.0),
                                TextField(
                                  enabled: false,
                                  controller: _email,
                                  style: TextStyle(fontFamily: 'OpenSans'),
                                  textCapitalization: TextCapitalization.sentences,
                                  textAlign: TextAlign.start,
                                  decoration: new InputDecoration(
                                    contentPadding: new EdgeInsets.symmetric(
                                        vertical: 12.0, horizontal: 12.0),
                                    border: new OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(10.0),
                                      ),
                                      borderSide: new BorderSide(
                                        color: Colors.black,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 30.0, horizontal: 60),
                                  width: double.infinity,
                                  child: RawMaterialButton(
                                    padding: EdgeInsets.all(15.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    fillColor: Color(0xFF5FCD5C),
                                    onPressed: () {
                                      _save(_currentPage, context);
                                    },
                                    highlightColor: Colors.white,
                                    child: Text(
                                      'NEXT',
                                      style: TextStyle(
                                        color: Color(0xFFFFFFFF),
                                        letterSpacing: 2,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Gilroy',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        WillPopScope(
                          onWillPop: () => Future.sync(onWillPop),
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: ListView(
                              shrinkWrap: true,
                              children: <Widget>[
                                Text(
                                  "ABOUT",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontFamily: 'Muli',
                                    fontSize: 15.5,
                                  ),
                                ),
                                SizedBox(height: 20.0),
                                Text(
                                  'Preferred Industry',
                                  style: TextStyle(
                                      fontFamily: 'Muli',
                                      fontSize: 14.0,
                                      color: Color(0xFF004782)),
                                ),
                                SizedBox(height: 15.0),
                                TextField(
                                  style: TextStyle(fontFamily: 'OpenSans'),
                                  controller: _industry,
                                  textCapitalization: TextCapitalization.sentences,
                                  textAlign: TextAlign.start,
                                  decoration: new InputDecoration(
                                    hintText: "e.g Finance",
                                    hintStyle: TextStyle(
                                        fontSize: 14, fontFamily: 'MuliItalic'),
                                    contentPadding: new EdgeInsets.symmetric(
                                        vertical: 12.0, horizontal: 12.0),
                                    border: new OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(10.0),
                                      ),
                                      borderSide: new BorderSide(
                                        color: Colors.black,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15.0),
                                Text(
                                  'Favourite Quote',
                                  style: TextStyle(
                                      fontFamily: 'Muli',
                                      fontSize: 14.0,
                                      color: Color(0xFF004782)),
                                ),
                                SizedBox(height: 15.0),
                                TextField(
                                  style: TextStyle(fontFamily: 'OpenSans'),
                                  controller: _fav_quote,
                                  textCapitalization: TextCapitalization.sentences,
                                  textAlign: TextAlign.start,
                                  decoration: new InputDecoration(
                                    contentPadding: new EdgeInsets.symmetric(
                                        vertical: 12.0, horizontal: 12.0),
                                    border: new OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(10.0),
                                      ),
                                      borderSide: new BorderSide(
                                        color: Colors.black,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15.0),
                                Text(
                                  'Biography',
                                  style: TextStyle(
                                      fontFamily: 'Muli',
                                      fontSize: 14.0,
                                      color: Color(0xFF004782)),
                                ),
                                SizedBox(height: 15.0),
                                TextField(
                                  style: TextStyle(fontFamily: 'OpenSans'),
                                  controller: _bio,
                                  textCapitalization: TextCapitalization.sentences,
                                  keyboardType: TextInputType.multiline,
                                  minLines: 1,
                                  maxLines: 5,
                                  textAlignVertical: TextAlignVertical.top,
                                  decoration: new InputDecoration(
                                    hintText: 'Tell us about yourself',
                                    hintStyle: TextStyle(
                                        fontSize: 14, fontFamily: 'MuliItalic'),
                                    contentPadding: new EdgeInsets.only(
                                        bottom: 100.0,left: 10.0, right:10.0, top: 10.0),
                                    border: new OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(10.0),
                                      ),
                                      borderSide: new BorderSide(
                                        color: Colors.black,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 30.0, horizontal: 60),
                                  width: double.infinity,
                                  child: RawMaterialButton(
                                    padding: EdgeInsets.all(15.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    fillColor: Color(0xFF5FCD5C),
                                    onPressed: () {
                                      _save(_currentPage, context);
                                    },
                                    highlightColor: Colors.white,
                                    child: Text(
                                      'NEXT',
                                      style: TextStyle(
                                        color: Color(0xFFFFFFFF),
                                        letterSpacing: 2,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Gilroy',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        WillPopScope(
                          onWillPop: () => Future.sync(onWillPop),
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: ListView(
                              shrinkWrap: true,
                              children: <Widget>[
                                Text(
                                  "WORK HISTORY",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontFamily: 'Muli',
                                    fontSize: 15.5,
                                  ),
                                ),
                                SizedBox(height: 20.0),
                                Text(
                                  'Company',
                                  style: TextStyle(
                                      fontFamily: 'Muli',
                                      fontSize: 14.0,
                                      color: Color(0xFF004782)),
                                ),
                                SizedBox(height: 15.0),
                                TextField(
                                  style: TextStyle(fontFamily: 'OpenSans'),
                                  controller: _company,
                                  textCapitalization: TextCapitalization.sentences,
                                  textAlign: TextAlign.start,
                                  decoration: new InputDecoration(
                                    hintStyle: TextStyle(
                                        fontSize: 14, fontFamily: 'MuliItalic'),
                                    hintText: "Where do you currently work?",
                                    contentPadding: new EdgeInsets.symmetric(
                                        vertical: 12.0, horizontal: 12.0),
                                    border: new OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(10.0),
                                      ),
                                      borderSide: new BorderSide(
                                        color: Colors.black,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15.0),
                                Text(
                                  'Job Position',
                                  style: TextStyle(
                                      fontFamily: 'Muli',
                                      fontSize: 14.0,
                                      color: Color(0xFF004782)),
                                ),
                                SizedBox(height: 15.0),
                                TextField(
                                  style: TextStyle(fontFamily: 'OpenSans'),
                                  controller: _jobPosition,
                                  textCapitalization: TextCapitalization.sentences,
                                  textAlign: TextAlign.start,
                                  decoration: new InputDecoration(
                                    hintStyle: TextStyle(
                                        fontSize: 14, fontFamily: 'MuliItalic'),
                                    hintText: "Your job title e.g Contractor",
                                    contentPadding: new EdgeInsets.symmetric(
                                        vertical: 12.0, horizontal: 12.0),
                                    border: new OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(10.0),
                                      ),
                                      borderSide: new BorderSide(
                                        color: Colors.black,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15.0),
                                Text(
                                  'Linkedin Profile',
                                  style: TextStyle(
                                      fontFamily: 'Muli',
                                      fontSize: 14.0,
                                      color: Color(0xFF004782)),
                                ),
                                SizedBox(height: 15.0),
                                TextField(
                                  style: TextStyle(fontFamily: 'OpenSans'),
                                  controller: _linkedinProfile,
                                  textCapitalization: TextCapitalization.none,
                                  keyboardType: TextInputType.multiline,
                                  minLines: 1,
                                  maxLines: 5,
                                  textAlignVertical: TextAlignVertical.top,
                                  decoration: new InputDecoration(
                                    hintStyle: TextStyle(
                                        fontSize: 14, fontFamily: 'MuliItalic'),
                                    border: new OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(10.0),
                                      ),
                                      borderSide: new BorderSide(
                                        color: Colors.black,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 30.0, horizontal: 60),
                                  width: double.infinity,
                                  child: RawMaterialButton(
                                    padding: EdgeInsets.all(15.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    fillColor: Color(0xFF5FCD5C),
                                    onPressed: () {
                                      _save(_currentPage, context);
                                    },
                                    highlightColor: Colors.white,
                                    child: Text(
                                      'NEXT',
                                      style: TextStyle(
                                        color: Color(0xFFFFFFFF),
                                        letterSpacing: 2,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Gilroy',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        WillPopScope(
                          onWillPop: () => Future.sync(onWillPop),
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: ListView(
                              shrinkWrap: true,
                              children: <Widget>[
                                Text(
                                  "EDUCATION HISTORY",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontFamily: 'Muli',
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 20.0),
                                Text(
                                  'Institution',
                                  style: TextStyle(
                                      fontFamily: 'Muli',
                                      fontSize: 14.0,
                                      color: Color(0xFF004782)),
                                ),
                                SizedBox(height: 15.0),
                                TextField(
                                  style: TextStyle(fontFamily: 'OpenSans'),
                                  controller: _institution,
                                  textCapitalization: TextCapitalization.sentences,
                                  textAlign: TextAlign.start,
                                  decoration: new InputDecoration(
                                    hintText: 'e.g University of Illorin',
                                    hintStyle: TextStyle(
                                        fontSize: 14, fontFamily: 'MuliItalic'),
                                    contentPadding: new EdgeInsets.symmetric(
                                        vertical: 12.0, horizontal: 12.0),
                                    border: new OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(10.0),
                                      ),
                                      borderSide: new BorderSide(
                                        color: Colors.black,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15.0),
                                Text(
                                  'Degree',
                                  style: TextStyle(
                                      fontFamily: 'Muli',
                                      fontSize: 14.0,
                                      color: Color(0xFF004782)),
                                ),
                                SizedBox(height: 15.0),
                                TextField(
                                  textCapitalization: TextCapitalization.sentences,
                                  style: TextStyle(fontFamily: 'OpenSans'),
                                  controller: _degree,
                                  textAlign: TextAlign.start,
                                  decoration: new InputDecoration(
                                    hintText: 'e.g BSc Insurance',
                                    hintStyle: TextStyle(
                                        fontSize: 14, fontFamily: 'MuliItalic'),
                                    contentPadding: new EdgeInsets.symmetric(
                                        vertical: 12.0, horizontal: 12.0),
                                    border: new OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(10.0),
                                      ),
                                      borderSide: new BorderSide(
                                        color: Colors.black,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 30.0, horizontal: 60),
                                  width: double.infinity,
                                  child: RawMaterialButton(
                                    padding: EdgeInsets.all(15.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    fillColor: Color(0xFF5FCD5C),
                                    onPressed: () {
                                      _save(_currentPage, context);
                                    },
                                    highlightColor: Colors.white,
                                    child: Text(
                                      'NEXT',
                                      style: TextStyle(
                                        color: Color(0xFFFFFFFF),
                                        letterSpacing: 2,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Gilroy',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "YOU'RE DOING GREAT, KEEP GOING",
                    style: TextStyle(
                      color: Colors.black38,
                      letterSpacing: 2,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Gilroy',
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildPageIndicator(),
                  ),
                ],
              ),
            ),

          ),

        ),

      ),

    );
  }

  _save(int pageNo, BuildContext context) {
    switch (pageNo) {
      case 0:
        if (_first_name.text != "" &&
            _last_name.text != "" &&
            _country.text != "") {
          _pageController.nextPage(
              duration: Duration(milliseconds: 300), curve: Curves.ease);
        } else if (_first_name.text == "") {
          NetworkUtils.showSnackBar(_scaffoldKey, "First Name is required");
        } else if (_last_name.text == "") {
          NetworkUtils.showSnackBar(_scaffoldKey, "Last Name is required");
        } else if (_country.text == "") {
          NetworkUtils.showSnackBar(_scaffoldKey, "Country is required");
        }
        break;
      case 1:
        if (_state.text != "" && _phone.text != "" && _email.text != "") {
          _pageController.nextPage(
              duration: Duration(milliseconds: 300), curve: Curves.ease);
        } else if (_state.text == "") {
          NetworkUtils.showSnackBar(_scaffoldKey, "State is required");
        } else if (_phone.text == "") {
          NetworkUtils.showSnackBar(_scaffoldKey, "Phone Number is required");
        } else if (_email.text == "") {
          NetworkUtils.showSnackBar(_scaffoldKey, "Email is required");
        }
        break;
      case 2:
        if (_industry.text != "" &&
            _fav_quote.text != "" &&
            _bio.text != "" &&
            _fav_quote.text.length >= 8 &&
            _bio.text.length >= 20) {
          _pageController.nextPage(
              duration: Duration(milliseconds: 300), curve: Curves.ease);
        } else if (_industry.text == "") {
          NetworkUtils.showSnackBar(_scaffoldKey, "Industry is required");
        } else if (_fav_quote.text == "") {
          NetworkUtils.showSnackBar(
              _scaffoldKey, "Favourite Quote is required");
        } else if (_bio.text == "") {
          NetworkUtils.showSnackBar(_scaffoldKey, "Biography is required");
        } else if (_fav_quote.text.length < 8) {
          NetworkUtils.showSnackBar(_scaffoldKey,
              "Favourite Quote can not be less than 8 characters");
        } else if (_bio.text.length < 20) {
          NetworkUtils.showSnackBar(
              _scaffoldKey, "Bio can not be less than 20 characters");
        }
        break;
      case 3:
        if (_company.text != "" &&
            _jobPosition.text != "") {
          _pageController.nextPage(
              duration: Duration(milliseconds: 300), curve: Curves.ease);
        } else if (_company.text == "") {
          NetworkUtils.showSnackBar(_scaffoldKey, "Company is required");
        } else if (_jobPosition.text == "") {
          NetworkUtils.showSnackBar(_scaffoldKey, "Job Position is required");
        }
        break;
      case 4:
        if (_institution.text != "" && _degree.text != "") {
          Navigator.pushReplacement(
              context,
              SlideFromRightPageRoute(
                  widget: UploadPicPage(
                      first_name: _first_name.text,
                      last_name: _last_name.text,
                      country: _country.text,
                      state: _state.text,
                      phone: _phone.text,
                      email: _email.text,
                      industry: _industry.text,
                      fav_quote: _fav_quote.text,
                      bio_text: _bio.text,
                      company: _company.text,
                      job_position: _jobPosition.text,
                      linkedin_profile: _linkedinProfile.text == ""? "http://linkedin.com":_linkedinProfile.text,
                      institution: _institution.text,
                      degree: _degree.text,
                      profile_image: widget.profile_image)));
        } else if (_institution.text == "") {
          NetworkUtils.showSnackBar(_scaffoldKey, "Institution is required");
        } else if (_degree.text == "") {
          NetworkUtils.showSnackBar(_scaffoldKey, "Degree is required");
        }
        break;
    }
  }

  Future<bool> onWillPop() {
    if (_currentPage != 0) {
      _pageController.previousPage(
          duration: Duration(milliseconds: 300), curve: Curves.linear);
    } else {
      Navigator.pop(context, false);
    }
  }
}
