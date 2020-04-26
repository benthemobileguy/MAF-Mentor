import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:maf_mentor/screens/utils/auth.dart';
import 'package:maf_mentor/screens/utils/network.dart';
import 'package:shared_preferences/shared_preferences.dart';
class PushNotificationService {
  FirebaseMessaging _fcm;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  Future initialise() async {
    _fcm = FirebaseMessaging();
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
    //initialise notification
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    var initSetttings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings,);
    if (Platform.isIOS) {
      // request permissions if we're on android
      await _fcm.requestNotificationPermissions(IosNotificationSettings());
      // For testing purposes print the Firebase Messaging token
      String token = await _fcm.getToken();
      print("FirebaseMessaging token: $token");
      _saveDeviceTokenToServer(token);
    } else{
      String token = await _fcm.getToken();
      print("FirebaseMessaging token: $token");
      _saveDeviceTokenToServer(token);
    }
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
    print("Title: $title, body: $body, message: $mMessage");
    showNotification(title, body);
  }
//  void _saveDeviceTokenToFirestore(String token) async{
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    if(prefs.getString('user')!=null){
//      Map user = json.decode(prefs.getString('user'));
//      final Firestore db = Firestore.instance;
//      if(token!=null){
//        var tokenRef = db.collection("Tokens")
//            .document(user['id'].toString());
//        await tokenRef.setData({
//          'token': token,
//          'createdAt': FieldValue.serverTimestamp(),
//          'platform': Platform.operatingSystem
//        });
//      }
//    }
//  }
  void _saveDeviceTokenToServer(String token) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var uri = NetworkUtils.host + AuthUtils.sendToken;
    var jsonResponse = null;
    var response = await http.post(uri,
        body: jsonEncode({
          "token": token
        }),
        headers: {'Authorization': 'Bearer ' + sharedPreferences.get("token"),
          'Accept': 'application/json',
          'Content-Type' : 'application/json'} );
    if (response.statusCode == 200 || response.statusCode == 201) {
      jsonResponse = json.decode(response.body);
      print("success" + jsonResponse.toString());
    } else {
      print("Failed" +jsonResponse.toString());
    }
  }
  showNotification(String title, String body) async {
    var android = new AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: Priority.High,importance: Importance.Max
    );
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(
        0, title, body, platform,
        payload: 'MAF Mentor');
  }
}