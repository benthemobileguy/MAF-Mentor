import 'package:flutter/material.dart';
import 'package:maf_mentor/screens/animations/fade_animations.dart';
import 'package:maf_mentor/screens/terms_service.dart';
import 'package:maf_mentor/screens/utils/network.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VerifyAccountPage extends StatefulWidget {
  final String value;
  VerifyAccountPage({Key key, this.value}) : super(key:key);
  @override
  _VerifyAccountState createState() => _VerifyAccountState();
}

class _VerifyAccountState extends State<VerifyAccountPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static const _verifyUrl = 'https://testing.mentorafricafoundation.com/api/v1/email/verify';
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 35.0,
        child: Image.asset('assets/images/icon.png'),
      ), //Child Avatar
    ); //Hero

    final headingText = Text(
      "Verify your account",
      style: TextStyle(
        color: Color(0xFF004782),
        fontFamily: 'OpenSans',
        fontSize: 20.0,
      ),
    );
    final verificationText = Text(
      "A verification code has been sent to your email address",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Color(0xffAFBBCC),
        fontFamily: 'OpenSans',
        fontSize: 16.0,
      ),
    );
    final verificationText2 = Text(
      "Insert verification to continue",
      style: TextStyle(
        color: Color(0xffAFBBCC),
        fontFamily: 'OpenSans',
        fontSize: 12.0,
      ),
    );
    final verificationText3 = Text(
      "Didn't receive code?",
      style: TextStyle(
        color: Color(0xff36ADE6),
        fontFamily: 'OpenSans',
        fontSize: 15.0,
      ),
    );

    final emailText= Text(
      ("${widget.value}"),
      style: TextStyle(
        color: Color(0xff4C5264),
        fontWeight: FontWeight.bold,
        fontFamily: 'Muli',
        fontSize: 20.0,
      ),
    );
    final inputFields = PinPut(
      containerHeight: 50,
      fieldsCount: 6,
      onSubmit: (String pin) => _submit(pin),

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
            Navigator.of(context).pop();
          },
          child: Center(
            child: Text('Change Email',
                style: TextStyle(color: Colors.white, fontFamily: 'Muli')),
          ),
        ),
      ),
    );
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
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
              height: 30.0,
            ),
            FadeAnimation(1.8, Center(child: verificationText)),
            SizedBox(
              height: 60.0,
            ),
            FadeAnimation(1.8, Center(child: emailText)),
            SizedBox(
              height: 40.0,
            ),
            FadeAnimation(1.8, Center(child: inputFields)),
            SizedBox(
              height: 12.0,
            ),
            FadeAnimation(1.8, Center(child: verificationText2)),
            SizedBox(
              height: 70.0,
            ),
            FadeAnimation(1.8, Center(child: verificationText3)),
            SizedBox(
              height: 12.0,
            ),
            FadeAnimation(1.8, Center(child: continueBtn)),
          ],
        ),
      ),
    );
  }


  _submit(String pin) async{
    Map data = {'token': pin};
    var jsonResponse = null;
    var response = await http.post(_verifyUrl, body: data);
    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        print(jsonResponse['message']);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => TermsServicePage()),
                (Route<dynamic> route) => false);
      } else {
        NetworkUtils.showSnackBar(
            _scaffoldKey,'Invalid code. Please try again.');
        _isLoading = false;
      }
    } else {
      NetworkUtils.showSnackBar(_scaffoldKey, 'Invalid verification code. Please try again.');
      setState(() {
        _isLoading = false;
      });
      print(response.body);
    }
    }

}