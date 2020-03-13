import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maf_mentor/route_animations/slide_from_left_page_route.dart';
import 'package:maf_mentor/route_animations/slide_from_right_page_route.dart';
import 'package:maf_mentor/screens/dashboard.dart';
import 'package:maf_mentor/screens/login.dart';
import 'package:maf_mentor/screens/profile_update_screen.dart';
import 'package:maf_mentor/screens/utils/auth.dart';
import 'package:maf_mentor/screens/utils/network.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final String names;
  final String nationality;
  String fav_quote;
  String industry;
  final String profile_image;
  final String first_name;
  final String state;
  final String linkedin;
  final String last_name;
  final String phone;
  final String email;
  String bio;
  String company;
  String degree;
  String position;
  String institution;
  ProfilePage(
      {Key key,
        this.names,
        this.nationality,
        this.fav_quote,
        this.industry,
        this.profile_image,
        this.first_name,
        this.last_name,
        this.phone,
        this.bio,
        this.email,
        this.company,
        this.degree,
        this.position,
        this.institution,
        this.state,
        this.linkedin})
      : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProgressDialog pr;
  String _dialogText = "Uploading your image...";
  final TextEditingController _industry = TextEditingController();
  final TextEditingController _fav_quote = TextEditingController();
  final TextEditingController _bio = TextEditingController();
  final TextEditingController _company = TextEditingController();
  final TextEditingController _position = TextEditingController();
  final TextEditingController _degree = TextEditingController();
  final TextEditingController _school = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isAboutTapped = false;
  bool isWorkTapped = false;
  bool isEducationTapped = false;
  bool isAboutInfoInValid = false;
  bool isWorkInfoInValid = false;
  bool isIndustryInValid = false;
  bool isFavQuoteInValid = false;
  bool isBioInValid = false;
  bool isCompanyInValid = false;
  bool isPositionInValid = false;
  bool isInstitutionInValid = false;
  bool isDegreeInValid = false;
  File _image;
  bool isProfileUpdated = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //set initial values for text fields
    _industry.text = widget.industry;
    _fav_quote.text = widget.fav_quote;
    _bio.text = widget.bio;
    _company.text =widget.company;
    _position.text = widget.position;
    _degree.text = widget.degree;
    _school.text = widget.institution;
  }
  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    //Dialog Style
    pr.style(
      message: _dialogText,
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

    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image;
        print('Image Path $_image');
        if (_image != null) {
          pr.show();
        }
        uploadImage(_image);
      });
    }

    final userImg = CircleAvatar(
      radius: 70,
      backgroundColor: Color(0xFFEBAD03),
      child: GestureDetector(
        onTap: () {
          getImage();
        },
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
              widget.profile_image == "noimage.jpg"
                  ? AuthUtils.defaultProfileImg
                  : NetworkUtils.host +
                  AuthUtils.profilePics +
                  widget.profile_image,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
    final downArrow = GestureDetector(
        onTap: () {
          _updateProfileLauncher(context);
        },
        child: Icon(
          Icons.keyboard_arrow_down,
          color: Color(0xFF6F7A83),
          size: 40.0,
        ));
    final username = Text(
      "${widget.names}",
      style: TextStyle(
        color: Color(0xFF1C2447),
        fontFamily: 'Muli',
        fontSize: 25.0,
      ),
    );
    final work = Text(
      widget.industry != "" ? "${widget.industry}" : "Not yet set",
      style: TextStyle(
        color: Color(0xFF1C2447),
        fontFamily: 'MuliRegular',
        fontSize: 14.0,
      ),
    );

    final about_info_column = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 0,
            child: Icon(
              Icons.person,
              color: Color(0xFF041F36),
              size: 24.0,
            ),
          ),
          SizedBox(
            width: 15.0,
          ),
          Expanded(
            flex: 10,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("About Info",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6F7A83),
                        fontFamily: 'MuliRegular',
                      )),
                  SizedBox(
                    height: 8,
                  ),
                  Text(widget.industry,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1A5893),
                        fontFamily: 'MuliRegular',
                      )),
                  SizedBox(
                    height: 8,
                  ),
                  Text(widget.fav_quote,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1A5893),
                        fontFamily: 'MuliRegular',
                      )),
                  SizedBox(
                    height: 8,
                  ),
                  Text(widget.bio,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1A5893),
                        fontFamily: 'MuliRegular',
                      )),
                  SizedBox(
                    height: 12,
                  ),
                  GestureDetector(
                    onTap: () => editBtnClicked(1),
                    child: Text(
                      "Edit",
                      style: TextStyle(
                        color: Color(0xFFE93428),
                        fontFamily: 'OpenSansBold',
                        fontSize: 12.5,
                      ),
                    ),
                  )
                ]),
          )
        ]);
    final work_info_column = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 0,
            child: Icon(
              Icons.work,
              color: Color(0xFF041F36),
              size: 24.0,
            ),
          ),
          SizedBox(
            width: 15.0,
          ),
          Expanded(
            flex: 10,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("Work Info",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6F7A83),
                        fontFamily: 'MuliRegular',
                      )),
                  SizedBox(
                    height: 8,
                  ),
                  Text(widget.company,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1A5893),
                        fontFamily: 'MuliRegular',
                      )),
                  SizedBox(
                    height: 8,
                  ),
                  Text(widget.position,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1A5893),
                        fontFamily: 'MuliRegular',
                      )),
                  SizedBox(
                    height: 12,
                  ),
                  GestureDetector(
                    onTap: () => editBtnClicked(2),
                    child: Text(
                      "Edit",
                      style: TextStyle(
                        color: Color(0xFFE93428),
                        fontFamily: 'OpenSansBold',
                        fontSize: 12.5,
                      ),
                    ),
                  )
                ]),
          )
        ]);
    final education_info_column = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 0,
            child: Icon(
              Icons.school,
              color: Color(0xFF041F36),
              size: 24.0,
            ),
          ),
          SizedBox(
            width: 15.0,
          ),
          Expanded(
            flex: 10,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("Education Info",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6F7A83),
                        fontFamily: 'MuliRegular',
                      )),
                  SizedBox(
                    height: 8,
                  ),
                  Text(widget.institution,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1A5893),
                        fontFamily: 'MuliRegular',
                      )),
                  SizedBox(
                    height: 8,
                  ),
                  Text(widget.degree,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1A5893),
                        fontFamily: 'MuliRegular',
                      )),
                  SizedBox(
                    height: 12,
                  ),
                  GestureDetector(
                    onTap: () => editBtnClicked(3),
                    child: Text(
                      "Edit",
                      style: TextStyle(
                        color: Color(0xFFE93428),
                        fontFamily: 'OpenSansBold',
                        fontSize: 12.5,
                      ),
                    ),
                  )
                ]),
          )
        ]);
    final about_info_fields = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 0,
            child: Icon(
              Icons.person,
              color: Color(0xFF041F36),
              size: 24.0,
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          Expanded(
            flex: 10,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("About Info",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6F7A83),
                        fontFamily: 'MuliRegular',
                      )),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                    controller: _industry,
                    style: TextStyle(fontFamily: 'OpenSans'),
                    textCapitalization: TextCapitalization.sentences,
                    textAlign: TextAlign.start,
                    decoration: new InputDecoration(
                      hintText: "Industry",
                      hintStyle:
                      TextStyle(fontSize: 14, fontFamily: 'MuliItalic'),
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 12.0),
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(10.0),
                        ),
                        borderSide: new BorderSide(
                          color: Color(0xFF707070),
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                    controller: _fav_quote,
                    style: TextStyle(fontFamily: 'OpenSans'),
                    textCapitalization: TextCapitalization.sentences,
                    textAlign: TextAlign.start,
                    decoration: new InputDecoration(
                      hintText: "Favourite Quote",
                      hintStyle:
                      TextStyle(fontSize: 14, fontFamily: 'MuliItalic'),
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 12.0),
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(10.0),
                        ),
                        borderSide: new BorderSide(
                          color: Color(0xFF707070),
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                    controller: _bio,
                    style: TextStyle(fontFamily: 'OpenSans'),
                    textCapitalization: TextCapitalization.sentences,
                    textAlign: TextAlign.start,
                    decoration: new InputDecoration(
                      hintText: "Biography",
                      hintStyle:
                      TextStyle(fontSize: 14, fontFamily: 'MuliItalic'),
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 12.0),
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(10.0),
                        ),
                        borderSide: new BorderSide(
                          color: Color(0xFF707070),
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: <Widget>[
                      FlatButton(
                        onPressed: () => saveAboutInfo(),
                        child: Text(
                          'Save',
                          style: TextStyle(
                            fontFamily: "OpenSansBold",
                            color: Color(0xFFE93428),
                            fontSize: 14,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Color(0xFFE707070),
                                width: 0.6,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(7)),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: () => saveBtnClicked(1),
                        child: Icon(
                          Icons.close,
                          color: Color(0xFF041F36),
                          size: 25.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                ]),
          )
        ]);
    final work_info_fields = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 0,
            child: Icon(
              Icons.work,
              color: Color(0xFF041F36),
              size: 24.0,
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          Expanded(
            flex: 10,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("Work Info",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6F7A83),
                        fontFamily: 'MuliRegular',
                      )),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                    controller: _company,
                    style: TextStyle(fontFamily: 'OpenSans'),
                    textCapitalization: TextCapitalization.sentences,
                    textAlign: TextAlign.start,
                    decoration: new InputDecoration(
                      hintText: "Company",
                      hintStyle:
                      TextStyle(fontSize: 14, fontFamily: 'MuliItalic'),
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 12.0),
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(10.0),
                        ),
                        borderSide: new BorderSide(
                          color: Color(0xFF707070),
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                    controller: _position,
                    style: TextStyle(fontFamily: 'OpenSans'),
                    textCapitalization: TextCapitalization.sentences,
                    textAlign: TextAlign.start,
                    decoration: new InputDecoration(
                      hintText: "Position",
                      hintStyle:
                      TextStyle(fontSize: 14, fontFamily: 'MuliItalic'),
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 12.0),
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(10.0),
                        ),
                        borderSide: new BorderSide(
                          color: Color(0xFF707070),
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: <Widget>[
                      FlatButton(
                        onPressed: () => saveWorkInfo(),
                        child: Text(
                          'Save',
                          style: TextStyle(
                            fontFamily: "OpenSansBold",
                            color: Color(0xFFE93428),
                            fontSize: 14,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Color(0xFFE707070),
                                width: 0.6,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(7)),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: () => saveBtnClicked(2),
                        child: Icon(
                          Icons.close,
                          color: Color(0xFF041F36),
                          size: 25.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                ]),
          )
        ]);
    final education_info_fields = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 0,
            child: Icon(
              Icons.school,
              color: Color(0xFF041F36),
              size: 24.0,
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          Expanded(
            flex: 10,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("Education Info",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6F7A83),
                        fontFamily: 'MuliRegular',
                      )),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                    controller: _school,
                    style: TextStyle(fontFamily: 'OpenSans'),
                    textCapitalization: TextCapitalization.sentences,
                    textAlign: TextAlign.start,
                    decoration: new InputDecoration(
                      hintText: "Institution",
                      hintStyle:
                      TextStyle(fontSize: 14, fontFamily: 'MuliItalic'),
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 12.0),
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(10.0),
                        ),
                        borderSide: new BorderSide(
                          color: Color(0xFF707070),
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                    controller: _degree,
                    style: TextStyle(fontFamily: 'OpenSans'),
                    textCapitalization: TextCapitalization.sentences,
                    textAlign: TextAlign.start,
                    decoration: new InputDecoration(
                      hintText: "Degree",
                      hintStyle:
                      TextStyle(fontSize: 14, fontFamily: 'MuliItalic'),
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 12.0),
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(10.0),
                        ),
                        borderSide: new BorderSide(
                          color: Color(0xFF707070),
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: <Widget>[
                      FlatButton(
                        onPressed: () => saveEducationInfo(),
                        child: Text(
                          'Save',
                          style: TextStyle(
                            fontFamily: "OpenSansBold",
                            color: Color(0xFFE93428),
                            fontSize: 14,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Color(0xFFE707070),
                                width: 0.6,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(7)),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: () => saveBtnClicked(3),
                        child: Icon(
                          Icons.close,
                          color: Color(0xFF041F36),
                          size: 25.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                ]),
          )
        ]);
    final location = Text(
      widget.nationality != "" ? "${widget.nationality}" : "Not yet set",
      style: TextStyle(
        color: Color(0xFF6F7A83),
        fontFamily: 'MuliRegular',
        fontSize: 12.0,
      ),
    );
    final motto = Text(
      widget.fav_quote != "" ? "${widget.fav_quote}" : "Not yet set",
      style: TextStyle(
        color: Color(0xFF004782),
        fontFamily: 'Muli',
        fontSize: 14.0,
      ),
      textAlign: TextAlign.center,
    );
    final completeProfileBtn = Container(
      height: 50.0,
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.only(left: 50.0, right: 50.0),
        decoration: BoxDecoration(
            border: Border.all(
                color: Colors.white, style: BorderStyle.solid, width: 1.0),
            color: Color(0xFFEBAD03),
            borderRadius: BorderRadius.circular(20.0)),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                SlideFromRightPageRoute(
                    widget: ProfileUpdatePage(
                        first_name: widget.first_name,
                        last_name: widget.last_name,
                        country: widget.nationality,
                        phone_number: widget.phone,
                        email: widget.email,
                        profile_image: widget.profile_image)));
          },
          child: Center(
            child: Text('Update Profile',
                style: TextStyle(color: Colors.white, fontFamily: 'Muli')),
          ),
        ),
      ),
    );
    final divider = new Divider();
    final preferenceLayout = GestureDetector(
        onTap: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Center(
              child: new Image.asset(
                'assets/images/preference.png',
                width: 20.0,
                height: 20.0,
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Text('Preference',
                style: TextStyle(
                    color: Color(0xff1C2447),
                    fontFamily: 'Muli',
                    fontSize: 16.0)),
          ],
        ));
    final signOutLayout = GestureDetector(
        onTap: () {
          _logOut();
          Navigator.push(
              context, SlideFromLeftPageRoute(widget: LoginScreen()));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Center(
              child: new Image.asset(
                'assets/images/sign_out.png',
                width: 20.0,
                height: 20.0,
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Text('Sign Out',
                style: TextStyle(
                    color: Color(0xff1C2447),
                    fontFamily: 'Muli',
                    fontSize: 16.0)),
          ],
        ));
    final donationLayout = GestureDetector(
        onTap: () {
          print("adad");
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Center(
              child: new Image.asset(
                'assets/images/donation.png',
                width: 20.0,
                height: 20.0,
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Text('Donation',
                style: TextStyle(
                    color: Color(0xff1C2447),
                    fontFamily: 'Muli',
                    fontSize: 16.0)),
          ],
        ));
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
              onPressed: () => Navigator.push(
                  context, SlideFromRightPageRoute(widget: DashBoardPage())),
            )),
        body: Center(
          child: !isProfileUpdated
              ? ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(
                left: 24.0, right: 24.0, top: 0.0, bottom: 50.0),
            children: <Widget>[
              Center(child: userImg),
              SizedBox(
                height: 12.0,
              ),
              Center(child: username),
              SizedBox(
                height: 12.0,
              ),
              Center(child: work),
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
              downArrow,
              SizedBox(
                height: 10.0,
              ),
              Center(child: preferenceLayout),
              SizedBox(
                height: 30.0,
              ),
              Center(child: donationLayout),
              SizedBox(
                height: 30.0,
              ),
              Center(child: signOutLayout),
              SizedBox(
                height: 70.0,
              ),
            ],
          )
              : ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(
                left: 24.0, right: 24.0, top: 30.0, bottom: 50.0),
            children: <Widget>[
              Center(child: userImg),
              SizedBox(
                height: 12.0,
              ),
              Center(child: username),
              SizedBox(
                height: 12.0,
              ),
              Center(child: work),
              SizedBox(
                height: 10.0,
              ),
              Center(
                child: location,
              ),
              SizedBox(
                height: 20.0,
              ),
              Center(child: divider),
              SizedBox(
                height: 20.0,
              ),
              !isAboutTapped
                  ? Center(child: about_info_column)
                  : about_info_fields,
              SizedBox(
                height: 20.0,
              ),
              Center(child: divider),
              SizedBox(
                height: 20.0,
              ),
              !isWorkTapped
                  ? Center(child: work_info_column)
                  : work_info_fields,
              SizedBox(
                height: 20.0,
              ),
              Center(child: divider),
              SizedBox(
                height: 20.0,
              ),
              !isEducationTapped
                  ? Center(child: education_info_column)
                  : education_info_fields,
              SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ));
  }

  uploadImage(File image) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String authToken = sharedPreferences.getString("token");
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer ' + authToken,
    };
    var request = http.MultipartRequest(
        "POST", Uri.parse(NetworkUtils.host + AuthUtils.uploadImage));
    request.headers.addAll(headers);
    request.files.add(await http.MultipartFile.fromPath(
      'image',
      image.path,
    ));

    try {
      var streamedResponse = await request.send();
      var response =
      streamedResponse.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
      if (streamedResponse.statusCode == 200 ||
          streamedResponse.statusCode == 201) {
        NetworkUtils.showToast("Profile photo updated successfully");
        if (pr.isShowing()) {
          pr.hide();
        }
      } else {
        NetworkUtils.showSnackBar(
            _scaffoldKey, "An error occurred while uploading your photo");
        if (pr.isShowing()) {
          pr.hide();
        }
      }
      return response;
    } catch (e) {
      rethrow;
    }
  }

  void _logOut() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove("token");
  }

  void _updateProfileLauncher(BuildContext context) {
    if (widget.fav_quote == "") {
      Navigator.push(
          context,
          SlideFromRightPageRoute(
              widget: ProfileUpdatePage(
                  first_name: widget.first_name,
                  last_name: widget.last_name,
                  country: widget.nationality,
                  phone_number: widget.phone,
                  email: widget.email,
                  profile_image: widget.profile_image)));
    } else {
      setState(() {
        isProfileUpdated = true;
      });
    }
  }

  void editBtnClicked(int i) {
    switch (i) {
      case 1:
        setState(() {
          isAboutTapped = true;
        });
        break;
      case 2:
        setState(() {
          isWorkTapped = true;
        });
        break;
      case 3:
        setState(() {
          isEducationTapped = true;
        });
        break;
    }
  }

  void saveBtnClicked(int i) {
    switch (i) {
      case 1:
        setState(() {
          isAboutTapped = false;
        });
        break;
      case 2:
        setState(() {
          isWorkTapped = false;
        });
        break;
      case 3:
        setState(() {
          isEducationTapped = false;
        });
        break;
    }
  }

  saveAboutInfo() {
    if (_industry.text != "" && _fav_quote.text != "" && _bio.text != "") {
      setState(() {
        _dialogText = "Updating your About Info";
        pr.style(
          message: _dialogText,
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
        pr.show();
      });
      updateProfile(1);
    } else if (_industry.text == "") {
      NetworkUtils.showSnackBar(_scaffoldKey, "Industry is required");
    } else if (_fav_quote.text == "") {
      NetworkUtils.showSnackBar(_scaffoldKey, "Favourite Quote is required");
    } else if (_bio.text == "") {
      NetworkUtils.showSnackBar(_scaffoldKey, "Biography is required");
    }
  }

  saveWorkInfo() {
    if (_company.text != "" && _position.text != "") {
      setState(() {
        _dialogText = "Updating your Work Info";
        pr.style(
          message: _dialogText,
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
        pr.show();
      });
      updateProfile(2);
    } else if (_company.text == "") {
      NetworkUtils.showSnackBar(_scaffoldKey, "Company is required");
    } else if (_position.text == "") {
      NetworkUtils.showSnackBar(_scaffoldKey, "Position is required");
    }
  }

  saveEducationInfo() {
    if (_school.text != "" && _degree.text != "") {
      setState(() {
        _dialogText = "Updating your Education Info";
        pr.style(
          message: _dialogText,
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
        pr.show();
      });
      updateProfile(3);
    } else if (_school.text == "") {
      NetworkUtils.showSnackBar(_scaffoldKey, "Institution is required");
    } else if (_degree.text == "") {
      NetworkUtils.showSnackBar(_scaffoldKey, "Degree is required");
    }
  }

  void updateProfile(int i) async {
    Map<String, String> data;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var uri = NetworkUtils.host + AuthUtils.endPointUpdateProfile;
    switch (i) {
      case 1:
        data = {
          "_method": "PATCH",
          "first_name": widget.first_name,
          "last_name": widget.last_name,
          "phone": widget.phone,
          "industry": _industry.text,
          "country": widget.nationality,
          "state": widget.state,
          "fav_quote": _fav_quote.text,
          "bio_interest": _bio.text,
          "terms": "1",
          "company": widget.company,
          "position": widget.position,
          "linked_in": widget.linkedin,
          "institution": widget.institution,
          "degree": widget.degree,
          "preference[0]": widget.industry
        };
        break;
      case 2:
        data = {
          "_method": "PATCH",
          "first_name": widget.first_name,
          "last_name": widget.last_name,
          "phone": widget.phone,
          "industry": widget.industry,
          "country": widget.nationality,
          "state": widget.state,
          "fav_quote": widget.fav_quote,
          "bio_interest": widget.bio,
          "terms": "1",
          "company": _company.text,
          "position": _position.text,
          "linked_in": widget.linkedin,
          "institution": widget.institution,
          "degree": widget.degree,
          "preference[0]": widget.industry
        };
        break;
      case 3:
        data = {
          "_method": "PATCH",
          "first_name": widget.first_name,
          "last_name": widget.last_name,
          "phone": widget.phone,
          "industry": widget.industry,
          "country": widget.nationality,
          "state": widget.state,
          "fav_quote": widget.fav_quote,
          "bio_interest": widget.bio,
          "terms": "1",
          "company": widget.company,
          "position": widget.position,
          "linked_in": widget.linkedin,
          "institution": _school.text,
          "degree": _degree.text,
          "preference[0]": widget.industry
        };
        break;
    }
    String authToken = sharedPreferences.getString("token");
    try {
      final response = await http.post(
        uri,
        body: json.decode(json.encode(data)),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + authToken,
        },
      );

      final responseJson = json.decode(response.body);
      print(responseJson.toString());
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          switch (i) {
            case 1:
              if (pr.isShowing()) {
                pr.hide();
              }
              setState(() {
                widget.industry = _industry.text;
                widget.fav_quote = _fav_quote.text;
                widget.bio = _bio.text;
              });
              break;
            case 2:
              if (pr.isShowing()) {
                pr.hide();
              }
              setState(() {
                widget.company = _company.text;
                widget.position = _position.text;
              });
              break;
            case 3:
              if (pr.isShowing()) {
                pr.hide();
              }
              setState(() {
                widget.institution = _school.text;
                widget.degree = _degree.text;
              });
              break;
          }
          saveBtnClicked(i);
          NetworkUtils.showToast("Profile Successfully Updated");
        });
      } else {
        if (pr.isShowing()) {
          pr.hide();
        }
        NetworkUtils.showSnackBar(
            _scaffoldKey, 'An error occurred. Please try again');
      }
      return responseJson;
    } catch (exception) {
      print(exception.toString());
      NetworkUtils.showSnackBar(
          _scaffoldKey, 'An error occurred. Please try again');
    }
  }
}
