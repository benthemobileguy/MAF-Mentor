import 'package:flutter/material.dart';
import 'package:maf_mentor/screens/animations/fade_animations.dart';
import 'package:url_launcher/url_launcher.dart';
class TermsServicePage extends StatefulWidget {
  @override
  _TermsServiceState createState() => _TermsServiceState();
}

class _TermsServiceState extends State<TermsServicePage> {
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
      "Terms of service",
      style: TextStyle(
        color: Color(0xFF004782),
        fontFamily: 'OpenSans',
        fontSize: 15.0,
      ),
    );
    final headingInfoText = Text(
      "To proceed you must confirm you've read and agree to the following",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Color(0xFFBCC5D3),
        fontFamily: 'OpenSans',
        fontSize: 12.0,
      ),
    );

    final termsLink = GestureDetector(
        onTap: () {
          _launchURL();
          },
        child: Text(
          "Terms and conditions",
          style: TextStyle(
            decoration: TextDecoration.underline,
            color: Color(0xFF36ADE6),
            fontFamily: 'Muli',
            fontSize: 16.0,
          ),
        )
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
            Navigator.of(context).pushReplacementNamed('/dashboard');
          },
          child: Center(
            child: Text('Confirm',
                style: TextStyle(color: Colors.white, fontFamily: 'Muli')),
          ),
        ),
      ),
    );
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, top: 30.0, bottom: 30.0),
          child: Column(
            children: [
              SizedBox(
                height: 50.0,
              ),
              logo,
              SizedBox(
                height: 12.0,
              ),
              FadeAnimation(1.8, Center(child: headingText)),
              SizedBox(
                height: 12.0,
              ),
              FadeAnimation(1.8, Center(child: headingInfoText)),
              SizedBox(
                height: 12.0,
              ),
              FadeAnimation(1.8, Center(child: termsLink)),
              SizedBox(
                height: 150.0,
              ),
              FadeAnimation(1.8, Center(child: continueBtn)),
              SizedBox(
                height: 12.0,
              )
            ],
          ),
        ));
  }

 void _launchURL() async {
    const url = 'http://mentorafricafoundation.com/privacy-policy/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
