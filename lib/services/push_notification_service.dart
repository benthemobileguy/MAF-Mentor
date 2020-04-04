import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  List<String> titles;
  List<String> bodies;

  Future initialise() async {
    //fetch lists from shared preferences
    getTitles(titles);
    getBodies(bodies);
    if (Platform.isIOS) {
      // request permissions if we're on android
      await _fcm.requestNotificationPermissions(IosNotificationSettings());
      _fcm.configure();
      // For testing purposes print the Firebase Messaging token
      String token = await _fcm.getToken();
      print("FirebaseMessaging token: $token");
      _saveDeviceTokenToFirestore(token);
    } else{
      String token = await _fcm.getToken();
      print("FirebaseMessaging token: $token");
      _saveDeviceTokenToFirestore(token);
    }

    _fcm.configure(
      // Called when the app is in the foreground and we receive a push notification
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
        _setMessage(message);
      },
      // Called when the app has been closed comlpetely and it's opened
      // from the push notification.
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
        _serialiseAndNavigate(message);
        _setMessage(message);
      },
      // Called when the app is in the background and it's opened
      // from the push notification.
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
        _serialiseAndNavigate(message);
        _setMessage(message);
      },
    );
  }

  void _serialiseAndNavigate(Map<String, dynamic> message) {
    var notificationData = message['data'];
    var view = notificationData['view'];

    if (view != null) {
      // Navigate to desired page
      if (view == 'create_post') {

      }
    }
  }
  _setMessage(Map<String, dynamic> message) {
    final notification = message['notification'];
    final data = message['data'];
    final String title = notification['title'];
    final String body = notification['body'];
    String mMessage = data['message'];
    //add to list
    titles.add(title);
    bodies.add(mMessage);
    //save to shared preferences
    storeTitles(titles);
    storeBodies(bodies);
    print("Title: $title, body: $body, message: $mMessage");

  }
  void storeTitles(List<String> list) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("notiTitles", list);
  }
  void storeBodies(List<String> list) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("notiBodies", list);
  }
  Future<List<String>> getTitles(List<String> list) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    list = prefs.getStringList("notiTitles");
    return prefs.getStringList("notiTitles");
  }
  Future<List<String>> getBodies(List<String> list) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    list = prefs.getStringList("notiBodies");
    return prefs.getStringList("notiBodies");
  }

  void _saveDeviceTokenToFirestore(String token) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map user = json.decode(prefs.getString('user'));
    final Firestore db = Firestore.instance;
    if(token!=null){
      var tokenRef = db.collection("Tokens")
          .document(user['id'].toString());
      await tokenRef.setData({
        'token': token,
        'createdAt': FieldValue.serverTimestamp(),
        'platform': Platform.operatingSystem
      });
    }
  }
}