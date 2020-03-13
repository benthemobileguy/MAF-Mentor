import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maf_mentor/screens/utils/auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maf_mentor/screens/utils/shared_pref.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NetworkUtils {
  static String first_name = "";
  static String email = "";
  static String last_name = "";
  static String country = "";
  static String gender = "";
  static String phone = "";
  static String profile_image = "";
  static String created_at = "";
  static String updated_at = "";
  static final String host = productionHost;
  static final String productionHost =
      'https://testing.mentorafricafoundation.com';
  static final String developmentHost = 'http://46.101.241.186';
  static final _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  };

  static dynamic authenticateUser(String email, String password) async {
    var uri = host + AuthUtils.endPoint;

    try {
      final response = await http.post(uri,
          headers: _headers,
          body: jsonEncode({
            'username': email,
            'password': password,
            'provider': 'patients',
          }));

      final responseJson = jsonDecode(response.body);
      return responseJson;
    } catch (exception) {
      print(exception);
      if (exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }

  static Future<bool> saveAppLaunchPreference(String status) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("first_time", status);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    var keys = prefs.getKeys();
    print('first $keys');
    print(prefs.get('chcode'));
    prefs.remove('firstName');
    prefs.remove('chcode');
    prefs.remove('message');
    prefs.remove('accessToken');
    print('second $keys');
    return prefs.remove('accessToken');
  }

  static showSnackBar(GlobalKey<ScaffoldState> scaffoldKey, String message) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(message ?? 'No internet Connection'),
    ));
  }

  static showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIos: 4,
        backgroundColor: Color(0xFFFFDA05),
        textColor: Color(0xFF226ADB),
        fontSize: 16.0);
  }
  static showRedToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIos: 4,
        backgroundColor: Color(0xFFCB4250),
        textColor: Color(0xFFFFFFFF),
        fontSize: 16.0);
  }

  static fetch(var authToken, var endPoint) async {
    var uri = host + endPoint;
    try {
      final response = await http.get(
        uri,
        headers: {'Authorization': authToken, 'Accept': 'application/json'},
      );

      final responseJson = json.decode(response.body);
      SharedPref sharedPref = SharedPref();
      sharedPref.save("user", responseJson);
      return responseJson;
    } catch (exception) {
      print(exception);
      if (exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }
  static String truncateWithEllipsis(int cutoff, String myString) {
    return (myString.length <= cutoff)
        ? myString
        : '${myString.substring(0, cutoff)}...';
  }
}
