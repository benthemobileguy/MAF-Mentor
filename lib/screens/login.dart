import 'dart:convert';
import 'package:maf_mentor/route_animations/slide_from_right_page_route.dart';
import 'package:maf_mentor/screens/utils/auth.dart';
import 'package:maf_mentor/screens/utils/network.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maf_mentor/screens/dashboard.dart';
import 'package:maf_mentor/utilities/styles.dart';
import 'package:flutter/gestures.dart';
import 'package:maf_mentor/screens/welcome_screen.dart';
import 'package:maf_mentor/screens/animations/fade_animations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _rememberMe = true;
  bool _isLoading = false;
  var auth = new AuthUtils();
  SharedPreferences sharedPreferences;
  static const _loginUrl = 'https://testing.mentorafricafoundation.com/api/v1/login';

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Color(0xFFAEAFBD),
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Color(0xFFAEAFBD),
              ),
              hintText: 'Enter your email',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            controller: passwordController,
            obscureText: true,
            style: TextStyle(
              color: Color(0xFFAEAFBD),
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Color(0xFFAEAFBD),
              ),
              hintText: 'Enter your password',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () => print('Forgot Password Button Pressed'),
        padding: EdgeInsets.only(right: 0.0),
        child: Text(
          'Forgot Password?',
          style: kLabelStyle,
        ),
      ),
    );
  }

  // Add validate password function.
  String _validatePassword(String value) {
    if (value.length < 5) {
      return 'The Password must be at least 5 characters.';
    }

    return null;
  }

  Widget _buildRememberMeCheckbox() {
    return Container(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Colors.green,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value;
                });
              },
            ),
          ),
          Text(
            'Remember me',
            style: kLabelStyle,
          ),
        ],
      ),
    );
  }
  @override
  void initState() {
    super.initState();
   checkAppLaunchState();
  }
  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      width: double.infinity,
      child:  RawMaterialButton(
        elevation: 5.0,
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        fillColor: Colors.white,
        onPressed: () {
          signIn(emailController.text, passwordController.text);
        },
        highlightColor:  Colors.white,
        child: Text(
          'LOGIN',
          style: TextStyle(
            color: Color(0xFF004782),
            letterSpacing: 1.5,
            fontSize: 16.5,
            fontWeight: FontWeight.bold,
            fontFamily: 'Muli',
          ),
        ),
      ),
    );
  }

  Widget _buildSignInWithText() {
    return Column(
      children: <Widget>[
        Text(
          '- OR -',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 20.0),
        Text(
          'Sign in with',
          style: kLabelStyle,
        ),
      ],
    );
  }

  Widget _buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialBtnRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildSocialBtn(
            () => print('Login with Facebook'),
            AssetImage(
              'assets/images/facebook.png',
            ),
          ),
          _buildSocialBtn(
            () => print('Login with Google'),
            AssetImage(
              'assets/images/google.png',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () => print('Sign Up Button Pressed'),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an Account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign Up',
              recognizer: new TapGestureRecognizer()
                ..onTap =
                    () => Navigator.of(context).pushReplacementNamed('/register_page'),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF004782),
                      Color(0xFF004782),
                      Color(0xFF004782),
                      Color(0xFF004782),
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
              FadeAnimation(
                1.8,
                Center(
                    child: Container(
                  height: double.infinity,
                  child: _isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(Colors.white),
                        ))
                      : SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                            horizontal: 40.0,
                            vertical: 120.0,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Sign In',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'OpenSans',
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 30.0),
                              _buildEmailTF(),
                              SizedBox(
                                height: 30.0,
                              ),
                              _buildPasswordTF(),
                              _buildForgotPasswordBtn(),
                              _buildRememberMeCheckbox(),
                              _buildLoginBtn(),
                              _buildSignInWithText(),
                              _buildSocialBtnRow(),
                              _buildSignupBtn(),
                            ],
                          ),
                        ),
                )),
              )
            ],
          ),
        ),
      ),
    );
  }

  signIn(String email, pass) async {
    if (email != "" && pass != "") {
      setState(() {
        _isLoading = true;
      });
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      Map data = {'email': email, 'password': pass};
      var jsonResponse = null;
      var response = await http.post(_loginUrl, body: data);
      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        jsonResponse = json.decode(response.body);
        print(response.body);
        if (jsonResponse != null) {
          setState(() {
            _isLoading = false;
          });
          sharedPreferences.setString("token", jsonResponse['data']['access_token']);
          Navigator.pushReplacement(
              context,
              SlideFromRightPageRoute(
                  widget: DashBoardPage()
              )

          );
        } else {
          NetworkUtils.showSnackBar(
              _scaffoldKey,'Invalid Email/Password');
          _isLoading = false;
        }
      } else if(response.statusCode == 404) {
        NetworkUtils.showSnackBar(_scaffoldKey, '404 Error! The requested URL was not found on this server.');
        setState(() {
          _isLoading = false;
        });
      }  else if(response.statusCode == 401){
        NetworkUtils.showSnackBar(_scaffoldKey, 'You entered invalid credentials!');
        setState(() {
          _isLoading = false;
        });
      } else{
        NetworkUtils.showSnackBar(_scaffoldKey, 'You entered invalid credentials!');
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      NetworkUtils.showSnackBar(_scaffoldKey, 'You entered invalid credentials!');
    }
  }
  Future checkAppLaunchState() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.getString("first_time") != "yes") {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => WelcomeScreenPage()), (Route<dynamic> route) => false);
    }
  }
}
