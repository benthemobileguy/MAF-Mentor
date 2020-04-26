import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AuthUtils {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  static final String defaultProfileImg = "https://images.unsplash.com/photo-1502164980785-f8aa41d53611?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60";
  static final String profilePics = '/profile_image/';
  static final String latestSchedule = "/api/v1/schedule/latest";
  static final String postSchedule = "/api/v1/schedule/create";
  static final String endPointIndex = '/api/v1/mentoring-board/';
  static final String endPoint = '/api/v1/register';
  static final String uploadImage = '/api/v1/upload-image';
  static final String endPointMenteeProfile = "/api/v1/mentoring-board/mentee/";
  static final String endPointProfile = '/api/v1/user';
  static final String chatConnections = '/api/v1/connections/';
  static final String sendMessage = '/api/v1/messages/';
  static final String pushNotification = '/api/v1/notify/push';
  static final String getNotifications = '/api/v1/notify/get';
  static final String sendToken = '/api/v1/notify/save/token';
  static final String endPointSession = '/api/v1/mentoring-board/session/';
  static final String endPointUpdateProfile = '/api/v1/onboard';
  // Keys to store and fetch data from SharedPreferences
  static final String accessToken = 'access_token';
  static final String firstName = 'first_name';
  static final String chcode = 'chcode';


  Future<String> getFirstName() async {
    final SharedPreferences prefs = await _prefs;
    Map user = json.decode(prefs.getString('user'));
    return user['first_name'] ?? '';
  }

  Future<String> getMiddleName() async {
    final SharedPreferences prefs = await _prefs;

    return prefs.getString('middle_name') ?? '';
  }

  Future<String> getLastName() async {
    final SharedPreferences prefs = await _prefs;
    Map user = json.decode(prefs.getString('user'));
    return user['last_name'] ?? '';
  }

  Future<bool> setNewData(response) async {
    final SharedPreferences prefs = await _prefs;

    var data = response['user'];
    Map user = {
      'first_name': data['first_name'],
      'access_token': response['token_data']['access_token']
    };

    return prefs.setString('user', json.encode(user));
  }

  Future<bool> setAvatar(response) async {
    final SharedPreferences prefs = await _prefs;

    return prefs.setString('avatar', response['user']['avatar']);
  }

  static logout() async {
//    final SharedPreferences prefs = await _prefs;
    final prefs = await SharedPreferences.getInstance();
    //also check to remove avatar
    return prefs.remove('user');
  }

  Future<String> getAvatar() async {
    final SharedPreferences prefs = await _prefs;
    var avatar = prefs.getString('avatar') ?? '';
    return avatar;
  }

  Future<String> getAccessToken() async {
    final SharedPreferences prefs = await _prefs;
    var user = prefs.getString('user') ?? '';
    String access_token = '';
    if (user != '') {
      Map data = json.decode(prefs.getString('user'));
      access_token = data['access_token'];
    }
    return access_token;
  }
}
