import 'package:flutter/material.dart';
import 'package:maf_mentor/screens/animations/fade_animations.dart';
import 'package:maf_mentor/screens/verify_account.dart';
import 'package:validate/validate.dart';
import 'package:maf_mentor/screens/utils/register_submit.dart';
import 'package:maf_mentor/screens/utils/network.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';

class RegisterData {
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

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String nameOptions = "";
  var _selected;
  bool passwordVisible;
  bool passwordVisible2;
  bool _isLoading = false;
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  final TextEditingController _emailText = TextEditingController();
  var typeOptions = ["Select Gender", "Male", "Female"];
  var currentItemSelected = 'Select Gender';
  RegisterData _data = new RegisterData();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  var selected = 'Select Gender';

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
    passwordVisible2 = true;
    this._data.gender = selected;
    this._data.country = "United States";
  }

  _showLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  _hideLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  Future submit() async {
    _showLoading();
    final FormState form = _formKey.currentState;
    // First validate form.
    if (form.validate()) {
      form.save(); // Save our form now.
//      form.reset();

      var registerSubmit = new RegisterSubmit();
      var responseJson = await registerSubmit.createRegisterData(_data);
      print(responseJson);
      if (responseJson == null) {
        NetworkUtils.showSnackBar(_scaffoldKey, 'The email has already been used');
      } else if (responseJson == 'NetworkError') {
        NetworkUtils.showSnackBar(_scaffoldKey, 'An error ocurred');
      } else if (responseJson['errors'] != null) {
        NetworkUtils.showSnackBar(_scaffoldKey, 'Invalid Email/Password');
      } else if (responseJson != null) {
        Map _user = responseJson["data"] ?? null;

        if (_user != null) {
          NetworkUtils.showToast("Your account has been created successfully. Please check your email to activate!");
          var route = new MaterialPageRoute(builder: (context) => new VerifyAccountPage(value: _emailText.text),);
          Navigator.of(context).push(route);
        } else {
          NetworkUtils.showSnackBar(_scaffoldKey, "${responseJson['message']}");
        }
      } else {
        NetworkUtils.showSnackBar(
            _scaffoldKey, 'Something went wrong! Please try again later');
      }
      _hideLoading();
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Add validate password function.
  String _validatePassword(String value) {
    if (value.trim().length < 5) {
      return 'The Password must be at least 5 characters.';
    }
    return null;
  }

  // Add validate password function.
  String _validateConfirmPassword(String value) {
    if (value!=_pass.text) {
      print(_pass);
      return 'Passwords do not match';
    }
    return null;
  }

  // Add validate password function.
  String _validateFirstName(String value) {
    if (value.trim().length < 3) {
      return 'The first name must be at least 3 characters.';
    }
    return null;
  }

  String _validateEmail(String value) {
    try {
      Validate.isEmail(value.trim());
    } catch (e) {
      return 'Please enter a valid email';
    }
    return null;
  }

  // Add validate password function.
  String _validateMiddleName(String value) {
    if (value.trim().length < 1) {
      return 'The Middle name must be at least 3 characters.';
    }
    return null;
  }

  // Add validate password function.
  String _validateLastName(String value) {
    if (value.trim().length < 3) {
      return 'The last name must be at least 3 characters.';
    }
    return null;
  }

  // Add validate password function.
  String _validatePhone(String value) {
    if (value.trim().length < 11) {
      return 'The phone field must be at least 8 characters.';
    }
    return null;
  }

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
    final firstName = TextFormField(
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: "First Name",
        labelStyle: TextStyle(
            fontFamily: 'OpenSans', fontSize: 15.0, color: Colors.black54),
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.brown)),
      ),
      validator: this._validateLastName,
      onSaved: (String value) {
        this._data.first_name = value;
      },
    );
    final lastName = TextFormField(
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: "Last Name",
        labelStyle: TextStyle(
            fontFamily: 'OpenSans', fontSize: 15.0, color: Colors.black54),
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.brown)),
      ),
      validator: this._validateLastName,
      onSaved: (String value) {
        this._data.last_name = value;
      },
    );
    final headingText = Text(
      "Let's get to know you better",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Color(0xFF004782),
        fontFamily: 'OpenSans',
        fontSize: 18.5,
      ),
    );

    final nationalityText = Text(
      "Nationality",
      textAlign: TextAlign.left,
      style: TextStyle(
        color: Color(0xFF707070),
        fontFamily: 'OpenSans',
        fontSize: 15,
      ),
    );
    final email = TextFormField(
        controller: _emailText,
        decoration: InputDecoration(
          labelText: "Email",
          labelStyle: TextStyle(
              fontFamily: 'OpenSans', fontSize: 15.0, color: Colors.black54),
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.brown)),
        ),
        validator: this._validateEmail,
        onSaved: (String value) {
          this._data.email = value;
        });
    final nationality = Container(
      constraints: BoxConstraints.expand(height: 50.0),
      decoration: const BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Colors.black54, width: 0.7))),
      child: CountryPicker(
        dense: false,
        showFlag: true,
        //displays flag, true by default
        showDialingCode: false,
        //displays dialing code, false by default
        showName: true,
        //displays country name, true by default
        showCurrency: false,
        //eg. 'British pound'
        showCurrencyISO: true,
        //eg. 'GBP'
        onChanged: (Country country) {
          setState(() {
            _selected = country;
            _data.country = country.name;
          });
        },
        selectedCountry: _selected,

      ),
    );
    final password = TextFormField(
      controller: _pass,
      decoration: InputDecoration(
        labelText: "Password",
        suffixIcon: IconButton(
          icon: Icon(
            // Based on passwordVisible state choose the icon
            !passwordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            // Update the state i.e. toogle the state of passwordVisible variable
            setState(() {
              passwordVisible = !passwordVisible;
            });
          },
        ),
        labelStyle: TextStyle(
            fontFamily: 'OpenSans', fontSize: 15.0, color: Colors.black54),
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.brown)),
      ),
      validator: this._validatePassword,
      onSaved: (String value) {
        this._data.password = value.trim();
      },
      obscureText: passwordVisible,
    );
    final confirm_password = TextFormField(
      controller: _confirmPass,
      decoration: InputDecoration(
        labelText: "Confirm Password",
        suffixIcon: IconButton(
          icon: Icon(
            // Based on passwordVisible state choose the icon
            !passwordVisible2 ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            // Update the state i.e. toogle the state of passwordVisible variable
            setState(() {
              passwordVisible2 = !passwordVisible2;
            });
          },
        ),
        labelStyle: TextStyle(
            fontFamily: 'OpenSans', fontSize: 15.0, color: Colors.black54),
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.brown)),
      ),
      validator: this._validateConfirmPassword,
      onSaved: (String value) {
        this._data.confirm_password = value.trim();
      },
      obscureText: passwordVisible2,
    );
    final typeSelector = Container(
        constraints: BoxConstraints.expand(height: 50.0),
        decoration: const BoxDecoration(
            border:
                Border(bottom: BorderSide(color: Colors.black54, width: 0.7))),
        child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
          style: TextStyle(
              color: Colors.black87, fontSize: 15, fontFamily: 'OpenSans'),
          items: typeOptions.map((String dropDownStringItem) {
            return DropdownMenuItem<String>(
              value: dropDownStringItem,
              child: Text(dropDownStringItem),
            );
          }).toList(),
          onChanged: (String newValueSelected) {
            //your code to execute when a menu item is selected from drop down
            currentItemSelected = newValueSelected;
            setState(() {
              this.currentItemSelected = newValueSelected;
              this._data.gender = newValueSelected;
            });
          },
          value: currentItemSelected,
        )));
    final registerButton = Container(
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
            if(currentItemSelected=="Select Gender"){

              NetworkUtils.showSnackBar(_scaffoldKey, 'Please select your gender');
            }else{
              submit();
            }
          },
          child: Center(
            child: Text('Continue',
                style: TextStyle(color: Colors.white, fontFamily: 'Muli')),
          ),
        ),
      ),
    );

    final backButton = Container(
      margin: const EdgeInsets.only(left: 50.0, right: 50.0),
      height: 50.0,
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: Colors.black87, style: BorderStyle.solid, width: 1.0),
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20.0)),
        child: InkWell(
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/sign_in');
          },
          child: Center(
            child: Text('Sign In', style: TextStyle(fontFamily: 'Muli')),
          ),
        ),
      ),
    );
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Center(
          child: Container(
              padding: EdgeInsets.only(top: 30.0, bottom: 10.0),
              height: double.infinity,
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Color(0xFF004782)),
                    ))
                  : ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(
                          left: 24.0, right: 24.0, top: 30.0, bottom: 30.0),
                      children: <Widget>[
                        SizedBox(
                          width: double.infinity,
                          child: new Form(
                              autovalidate: false,
                              key: this._formKey,
                              child: new Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 40.0,
                                  ),
                                  logo,
                                  SizedBox(
                                    height: 30.0,
                                  ),
                                  FadeAnimation(1.8, headingText),
                                  SizedBox(
                                    height: 30.0,
                                  ),
                                  FadeAnimation(1.8, firstName),
                                  SizedBox(
                                    height: 12.0,
                                  ),
                                  FadeAnimation(1.8, lastName),
                                  SizedBox(
                                    height: 14.0,
                                  ),
                                  FadeAnimation(1.8, nationality),
                                  SizedBox(
                                    height: 14.0,
                                  ),
                                  FadeAnimation(1.8, typeSelector),
                                  SizedBox(
                                    height: 12.0,
                                  ),
                                  FadeAnimation(1.8, email),
                                  SizedBox(
                                    height: 12.0,
                                  ),
                                  FadeAnimation(1.8, password),
                                  SizedBox(
                                    height: 12.0,
                                  ),
                                  FadeAnimation(1.8, confirm_password),
                                  SizedBox(
                                    height: 12.0,
                                  ),
                                  FadeAnimation(1.8, registerButton),
                                  SizedBox(
                                    height: 12.0,
                                  ),
                                  FadeAnimation(1.8, backButton),
                                  SizedBox(
                                    height: 12.0,
                                  )
                                ],
                              )),
                        ),
                      ],
                    ))),
    );
  }
}
