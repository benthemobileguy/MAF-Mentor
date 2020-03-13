import 'package:flutter/material.dart';
import 'package:maf_mentor/screens/animations/fade_animations.dart';
import 'package:maf_mentor/screens/utils/network.dart';

class WelcomeScreenPage extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreenPage> {
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

    final text1 = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: Color(0xFFFFDA05)),
        ),
        SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: Text(
            "Pass on your Legacy.",
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontFamily: 'Muli_Bold',
              fontSize: 20.0,
            ),
          ),
        ),
      ],
    );

    final text2 = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: Color(0xFFFFDA05)),
        ),
        SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: Text(
            "Help the younger generation reach their full potential.",
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontFamily: 'Muli_Bold',
              fontSize: 20.0,
            ),
          ),
        )
      ],
    );
    final text3 = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: Color(0xFFFFDA05)),
        ),
        SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: Text(
            "Improve the African narrative.",
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontFamily: 'Muli_Bold',
              fontSize: 20.0,
            ),
          ),
        )
      ],
    );

    final getStarted = Text(
      "Get Started!",
      style: TextStyle(
        color: Color(0xFFFFFFFF),
        fontFamily: 'Muli_Bold',
        fontSize: 20.0,
      ),
    );
    final loginBtn = Container(
      height: 50.0,
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.only(left: 50.0, right: 50.0),
        decoration: BoxDecoration(
            border: Border.all(
                color: Colors.white, style: BorderStyle.solid, width: 1.0),
            color: Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(20.0)),
        child: InkWell(
          onTap: () {
            saveLaunchState();
            Navigator.of(context).pushReplacementNamed('/sign_in');
          },
          child: Center(
            child: Text('Login',
                style: TextStyle(
                    color: Color(0xFF004782), fontFamily: 'Muli_Bold')),
          ),
        ),
      ),
    );
    final signUpBtn = Container(
      height: 50.0,
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.only(left: 50.0, right: 50.0),
        decoration: BoxDecoration(
            border: Border.all(
                color: Color(0xFF36ADE6), style: BorderStyle.solid, width: 1.0),
            color: Color(0xFF36ADE6),
            borderRadius: BorderRadius.circular(20.0)),
        child: InkWell(
          onTap: () {
            saveLaunchState();
            Navigator.of(context).pushReplacementNamed('/register_page');
          },
          child: Center(
            child: Text('Sign Up',
                style: TextStyle(color: Colors.white, fontFamily: 'Muli_Bold')),
          ),
        ),
      ),
    );
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/onboarding_bg.png"),
                  fit: BoxFit.cover),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16.0, top: 30.0, bottom: 30.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 50.0,
                  ),
                  logo,
                  SizedBox(
                    height: 50.0,
                  ),
                  FadeAnimation(3, Center(child: text1)),
                  SizedBox(
                    height: 20.0,
                  ),
                  FadeAnimation(3, Center(child: text2)),
                  SizedBox(
                    height: 20.0,
                  ),
                  FadeAnimation(3, Center(child: text3)),
                  SizedBox(
                    height: 150.0,
                  ),
                  FadeAnimation(3, Center(child: getStarted)),
                  SizedBox(
                    height: 50.0,
                  ),
                  FadeAnimation(3, Center(child: loginBtn)),
                  SizedBox(
                    height: 20.0,
                  ),
                  FadeAnimation(3, Center(child: signUpBtn)),
                  SizedBox(
                    height: 16.0,
                  ),
                ],
              ),
            )));
  }
  saveLaunchState() {
    NetworkUtils.saveAppLaunchPreference("yes");
  }
}
