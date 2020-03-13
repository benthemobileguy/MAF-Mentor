import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maf_mentor/route_animations/slide_from_right_page_route.dart';
import 'package:maf_mentor/screens/dashboard.dart';
import 'package:maf_mentor/screens/utils/auth.dart';
import 'package:maf_mentor/screens/utils/network.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'animations/fade_animations.dart';


class UploadPicPage extends StatefulWidget {
  final String first_name;
  final String last_name;
  final String country;
  final String state;
  final String phone;
  final String email;
  final String industry;
  final String fav_quote;
  final String bio_text;
  final String company;
  final String job_position;
  final String linkedin_profile;
  final String institution;
  final String degree;
  final String profile_image;

  const UploadPicPage({Key key, this.first_name, this.last_name,
    this.country, this.state, this.phone, this.email, this.industry,
    this.fav_quote, this.bio_text, this.company, this.job_position, this.linkedin_profile,
    this.institution, this.degree, this.profile_image}) : super(key: key);
  @override
  _UploadPicState createState() => _UploadPicState();
}

class _UploadPicState extends State<UploadPicPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  bool _isRegComplete= false;
  File _image;
  ProgressDialog pr;
  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    //Dialog Style
    pr.style(
      message: 'Uploading your image...',
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
        if(_image!=null){
          pr.show();
        }
        uploadImage(_image);
      });
    }

    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 35.0,
        child: Image.asset('assets/images/icon.png'),
      ), //Child Avatar
    ); //Hero
    final congratsImg = Hero(
      tag: 'congrats',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 120.0,
        child: Image.asset('assets/images/congratsImg.png'),
      ), //Child Avatar
    ); //Hero
    final headingText = Text(
      "Great! Just one more thing",
      style: TextStyle(
        color: Color(0xFF004782),
        fontFamily: 'Muli',
        fontSize: 20.0,
      ),
    );
    final congratulationsText = Text(
      "Congratulations!",
      style: TextStyle(
        color: Color(0xFFE93428),
        fontFamily: 'Muli',
        fontSize: 15.0,
      ),
    );
    final youCanChangeText = Text(
      "You can change your profile information anytime.",
      style: TextStyle(
        color: Color(0xFF555555),
        fontFamily: 'OpenSansItalic',
        fontSize: 14.5,
      ),
    );
    final allSetText = Text(
      "You're all set",
      style: TextStyle(
        color: Color(0xFF555555),
        fontFamily: 'OpenSansItalic',
        fontSize: 14.0,
      ),
    );
    final notificationText = Text(
      "Set your profile image",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Color(0xffAFBBCC),
        fontFamily: 'Muli',
        fontSize: 16.0,
      ),
    );
    final profilePic = CircleAvatar(
        radius: 100,
        backgroundColor: Color(0xFFEBAD03)  ,
        child: GestureDetector(
          onTap: () {
            getImage();
          },
          child: ClipOval(
            child: new SizedBox(
              width: 180.0,
              height: 180.0,
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
        ));
    final verificationText = Text(
      "Upload a Display Picture",
      style: TextStyle(
        color: Color(0xffAFBBCC),
        fontFamily: 'OpenSans',
        fontSize: 16.0,
      ),
    );
    final finishBtn = Container(
      height: 50.0,
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.only(left: 80.0, right: 80.0),
        decoration: BoxDecoration(
            border: Border.all(
                color: Colors.white, style: BorderStyle.solid, width: 1.0),
            color: Color(0xFF58C961),
            borderRadius: BorderRadius.circular(40.0)),
        child: InkWell(
          onTap: () {
            Navigator.pushReplacement(
                context, SlideFromRightPageRoute(widget: DashBoardPage()));
            NetworkUtils.showToast("Profile successfully updated!");

          },
          child: Center(
            child: Text('Finish',
                style: TextStyle(color: Colors.white, fontFamily: 'Muli')),
          ),
        ),
      ),
    );
    final continueBtn = Container(
      height: 50.0,
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.only(left: 50.0, right: 50.0),
        decoration: BoxDecoration(
            border: Border.all(
                color: Colors.white, style: BorderStyle.solid, width: 1.0),
            color: Color(0xFF004782),
            borderRadius: BorderRadius.circular(20.0)),
        child: InkWell(
          onTap: () {
            finshUpdate();

          },
          child: Center(
            child: Text('Finish',
                style: TextStyle(color: Colors.white, fontFamily: 'Muli')),
          ),
        ),
      ),
    );
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Center(
          child: _isLoading && !_isRegComplete
              ? Center(
              child: CircularProgressIndicator(
                valueColor:
                new AlwaysStoppedAnimation<Color>( Color(0xFF004782)),
              ))
              : !_isLoading && !_isRegComplete? ListView(
            shrinkWrap: true,
            padding:
            EdgeInsets.only(left: 24.0, right: 24.0, top: 0.0, bottom: 30.0),
            children: <Widget>[
              SizedBox(
                height: 30.0,
              ),
              logo,
              SizedBox(
                height: 30.0,
              ),
              FadeAnimation(1.8, Center(child: headingText)),
              SizedBox(
                height: 12.0,
              ),
              FadeAnimation(1.8, Center(child: notificationText)),
              SizedBox(
                height: 60.0,
              ),
              FadeAnimation(
                  1.8,
                  Center(
                    child: profilePic,
                  )),
              SizedBox(
                height: 30.0,
              ),
              FadeAnimation(1.8, Center(child: verificationText)),
              SizedBox(
                height: 20.0,
              ),
              FadeAnimation(1.8, Center(child: continueBtn)),
            ],
          ) :ListView(
            shrinkWrap: true,
            padding:
            EdgeInsets.only(left: 24.0, right: 24.0, top: 0.0, bottom: 30.0),
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              FadeAnimation(1.8, Center(child: congratulationsText)),
              SizedBox(
                height: 20.0,
              ),
              FadeAnimation(1.8, Center(child: allSetText)),
              SizedBox(
                height: 60.0,
              ),
              FadeAnimation(
                  1.8,
                  Center(
                    child: congratsImg,
                  )),
              SizedBox(
                height: 60.0,
              ),
              FadeAnimation(1.8, Center(child: youCanChangeText)),
              SizedBox(
                height: 30.0,
              ),
              FadeAnimation(1.8, Center(child: finishBtn)),
            ],
          )
      ),
    );
  }

  void finshUpdate() async{
    setState(() {
      _isLoading = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var uri = NetworkUtils.host +
        AuthUtils.endPointUpdateProfile;
    Map<String, String> data = {
      "_method": "PATCH",
      "first_name": widget.first_name,
      "last_name": widget.last_name,
      "phone": widget.phone,
      "industry":widget.industry,
      "country": widget.country,
      "state": widget.state,
      "fav_quote": widget.fav_quote,
      "bio_interest": widget.bio_text,
      "terms": "1",
      "company": widget.company,
      "position": widget.job_position,
      "linked_in":widget.linkedin_profile,
      "institution": widget.institution,
      "degree": widget.degree,
      "preference[0]": widget.industry};
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
          _isRegComplete = true;
        });
      } else{
        setState(() {
          _isLoading = false;
        });
        NetworkUtils.showSnackBar(_scaffoldKey, 'An error occurred. Please try again');
      }
      return responseJson;
    } catch (exception) {
      print(exception.toString());
      setState(() {
        _isLoading = false;
      });
      NetworkUtils.showSnackBar(_scaffoldKey, 'An error occurred. Please try again');
    }
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
      print(streamedResponse.toString());
      if (streamedResponse.statusCode == 200 ||
          streamedResponse.statusCode == 201) {
        NetworkUtils.showToast("Profile photo updated successfully");
        if (pr.isShowing()) {
          pr.hide();
        }
      } else{
        NetworkUtils.showSnackBar(_scaffoldKey, "An error occurred while uploading your photo");
        if (pr.isShowing()) {
          pr.hide();
        }
      }
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
