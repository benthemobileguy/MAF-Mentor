import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:maf_mentor/model/mentee.dart';
import 'package:maf_mentor/model/message.dart';
import 'package:maf_mentor/screens/utils/auth.dart';
import 'package:maf_mentor/screens/utils/network.dart';
import 'package:bubble/bubble.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatPage extends StatefulWidget {
  Mentee user;
  var mentorId;
  ChatPage(this.user, this.mentorId);
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ProgressDialog pr;
  Timer timer;
  ScrollController _scrollController = new ScrollController();
  String tokenString;
  final String serverToken = "AAAA58t2zSA:APA91bFAUKteVAxPeVXArbXTUpXzk5mIceGTVDMGJGAStdB1avWev-"
      "IYs6_ojymE6l5eGuXAPCyMl2rfqcXYCxQKqNg7l_2eWNESC6nHHs_7KGsuuSK7JO5gyWFCRSnMmhgiOdRiOeqF";
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  Iterable menteeMsg;
  List<Message> exchangedMessages = [];
  List<String>  messages = [];
  List<String> receiverId = [];
  List<String> senderId = [];
  String typingText;
  bool isMsgSent = false;
  final _chatController = TextEditingController();
  bool isShowSticker;

  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      Navigator.pop(context);
    }

    return Future.value(false);
  }

  @override
  void initState() {
    super.initState();
    isShowSticker = false;
    fetchMessages();
//    timer = Timer.periodic(Duration(seconds: 2),
//            (Timer t) => fetchMessages());
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _chatController.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Timer(Duration(milliseconds: 1000), () => _scrollController.jumpTo(_scrollController.position.maxScrollExtent));
    //Dialog Style
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
      message: 'Retrieving Messages...',
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
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    double px = 1 / pixelRatio;
    final chatList = Expanded(
      child: ListView(
        controller: _scrollController,
      shrinkWrap: true,
      padding: EdgeInsets.all(8.0),
      children: [
        Bubble(
          margin: BubbleEdges.only(bottom: 12.0),
          alignment: Alignment.center,
          color: Color.fromRGBO(212, 234, 244, 1.0),
          child: Text('TODAY',
              textAlign: TextAlign.center, style: TextStyle(fontSize: 11.0)),
        ),
        for (var i = 0; i < messages.length; i++)
          senderId[i] != widget.mentorId.toString() ?
              Bubble(
                nipWidth: 8,
                nipHeight: 24,
                color: Color.fromRGBO(225, 255, 199, 1.0),
                margin: BubbleEdges.only(top: 5.0),
                alignment: Alignment.topRight,
                nip: BubbleNip.rightBottom,
                child: Text(messages[i]),

          ): Bubble(
            nipWidth: 8,
            nipHeight: 24,
            margin: BubbleEdges.only(top: 5.0),
            alignment: Alignment.topLeft,
            nip: BubbleNip.leftTop,
            child: Text(messages[i]),
          )
      ],
      )
    );
   final bottomBar = Align(
        alignment: FractionalOffset.bottomCenter,
        child: Row(
          children: <Widget>[
            Flexible(
              child: new Row(
                children: <Widget>[
                  new Flexible(
                      child: Theme(
                        data: new ThemeData(
                          primaryColor: Color(0XFF3B3B3C),
                          primaryColorDark: Colors.red,
                        ),
                        child: new TextField(
                          onChanged: (text) {
                            setState(() {
                              typingText = text;
                            });
                          },
                          controller: _chatController,
                          textAlign: TextAlign.start,
                          decoration: new InputDecoration(
                            hintText: 'Type your message',
                            prefixIcon: new IconButton(
                                icon: new Image.asset(
                                  'assets/images/smile.png',
                                  width: 26.0,
                                  height: 26.0,
                                ),
                                onPressed: () => openEmoji()),
                            suffixIcon: new IconButton(
                                icon: new Image.asset(
                                  'assets/images/send.png',
                                  width: 26.0,
                                  height: 26.0,
                                ),
                                onPressed: () => sendMessage()),
                            hintStyle: TextStyle(
                                fontSize: 14.0,
                                fontFamily: 'Muli',
                                color: Color(0xff5D697C)),
                            border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(0.0),
                              ),
                              borderSide: new BorderSide(
                                color: Colors.black,
                                width: 1.0,
                              ),
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      );
    return WillPopScope(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFFEBF4F6),
            automaticallyImplyLeading: true,
            //`true` if you want Flutter to automatically add Back Button when needed,
            //or `false` if you want to force your own back button every where
            title: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 17,
                  backgroundColor: Color(0xFFEBAD03),
                  child: ClipOval(
                    child: new SizedBox(
                      width: 30.0,
                      height: 30.0,
                      child: Image.network(
                        widget.user.profile_image != "noimage.jpg" ? NetworkUtils.host +
                            AuthUtils.profilePics +
                            widget.user.profile_image: AuthUtils.defaultProfileImg,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  widget.user.first_name + " " + widget.user.last_name,
                  style: TextStyle(
                    color: Color(0xFF1C2447),
                    fontFamily: 'Muli',
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Color(0xFF1C2447),
              onPressed: () => Navigator.pop(context, false),
            ),
          ),
          body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                chatList,
                bottomBar,
                // Sticker
                (isShowSticker ? buildSticker() : Container()),
              ])),
      onWillPop: onBackPress,
    );
  }

  sendMessage() async {
    if (_chatController.text != "") {
      FocusScope.of(context).requestFocus(new FocusNode());
      setState(() {
        senderId.add(widget.mentorId.toString());
        messages.add(_chatController.text);
        postMessageToApi(_chatController.text);
      });
      _chatController.clear();
    }
  }

  openEmoji() {
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }

  Widget buildSticker() {
    FocusScope.of(context).requestFocus(new FocusNode());
    return EmojiPicker(
      rows: 3,
      columns: 7,
      buttonMode: ButtonMode.MATERIAL,
      recommendKeywords: [
        'Grinning Face',
        'Grinning Face With Big Eyes',
        'Grinning Face With Smiling Eyes',
        'Beaming Face With Smiling Eyes',
        'Grinning Squinting Face',
        'Grinning Face With Sweat'
      ],
      numRecommended: 10,
      onEmojiSelected: (emoji, category) {
        print(emoji);
      },
    );
  }

  void postMessageToApi(String text) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {"message": text};
    var jsonResponse = null;
    var response = await http.post(
      NetworkUtils.host + AuthUtils.sendMessage + widget.user.id.toString(),
      body: json.encode(data),
      headers: {
        'Authorization': "Bearer " + sharedPreferences.getString("token"),
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
    );
    jsonResponse = json.decode(response.body);
    print(jsonResponse.toString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        isMsgSent = true;
      });
      //send notification
      await Firestore.instance
          .collection('Tokens')
          .document(widget.user.id.toString())
          .get()
          .then((DocumentSnapshot ds) {
        tokenString = ds.data['token'].toString();
        sendAndRetrieveMessage(tokenString, widget.user.first_name + " "
            + widget.user.last_name, text);
        return ds.data['token'].toString();
      });
    }
  }

  Future fetchMessages() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var uri =
        NetworkUtils.host + AuthUtils.sendMessage + widget.user.id.toString();
    try {
      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + sharedPreferences.get("token"),
        },
      );
      final responseJson = json.decode(response.body);
      for (var u in responseJson) {
        Message message = Message(u["id"], u["sender_id"], u["receiver_id"],
            u["body"], u["read"], u["created_at"], u["updated_at"]);
        exchangedMessages.add(message);
        setState(() {
          messages.add(message.body);
          senderId.add(message.sender_id.toString());
          receiverId.add(message.receiver_id.toString());
        });
      }
      return responseJson;
    } catch (exception) {
      print(exception);
    }
  }


  Future<Map<String, dynamic>> sendAndRetrieveMessage(String token, String title, String body) async {
    await firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: false),
    );
    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key = $serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': body,
            'title': title
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': token,
        },
      ),
    );

    final Completer<Map<String, dynamic>> completer =
    Completer<Map<String, dynamic>>();
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        completer.complete(message);
      },
    );
    return completer.future;
  }
}
