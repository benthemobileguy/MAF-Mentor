import 'package:emoji_picker/emoji_picker.dart';
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
  Iterable menteeMsg;
  List<Message> senderExchangedMessages = [];
  List<Message> receiverExchangedMessages = [];
  List<String> sentMessages = [];
  List<String> receivedMessages = [];
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
    fetchSentMessages();
    fetchReceivedMessages();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
    final chatList = ListView(
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
        for (var i = 0; i < sentMessages.length; i++)
          Row(
            children: <Widget>[
              Expanded(child: SizedBox()),
              Bubble(
                nipWidth: 8,
                nipHeight: 24,
                margin: BubbleEdges.only(top: 5.0),
                alignment: Alignment.topRight,
                nip: BubbleNip.rightBottom,
                child: Text(sentMessages[i]),
              ),
              SizedBox(
                width: 8,
              ),
            ],
          ),
        for (var i = 0; i < receivedMessages.length; i++)
          Bubble(
            nipWidth: 8,
            nipHeight: 24,
            margin: BubbleEdges.only(top: 5.0),
            alignment: Alignment.topLeft,
            nip: BubbleNip.leftTop,
            child: Text(receivedMessages[i]),
          )
      ],
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
                        fit: BoxFit.fill,
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
                Flexible(
                  child: Align(
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
                  ),
                ),
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
        sentMessages.add(_chatController.text);
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
    print(widget.user.id.toString());
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
    }
  }

  Future fetchSentMessages() async {
    //Future.delayed(Duration.zero, () => pr.show());
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
      if (responseJson != null) {
//        setState(() {
//          Future.delayed(Duration.zero, () => pr.hide());
//        });
      }
      for (var u in responseJson) {
        Message message = Message(u["id"], u["sender_id"], u["receiver_id"],
            u["body"], u["read"], u["created_at"], u["updated_at"]);
        senderExchangedMessages.add(message);
        setState(() {
          sentMessages.add(message.body);
        });
      }
      return responseJson;
    } catch (exception) {
      print(exception);
    }
  }

  Future fetchReceivedMessages() async {
   // Future.delayed(Duration.zero, () => pr.show());
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var uri =
        NetworkUtils.host + AuthUtils.sendMessage + widget.mentorId.toString();
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
        receiverExchangedMessages.add(message);
        setState(() {
          receivedMessages.add(message.body);
        });
      }
      return responseJson;
    } catch (exception) {
      print(exception);
    }
  }
}
