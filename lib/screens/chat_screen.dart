import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:maf_mentor/model/mentee.dart';
import 'package:maf_mentor/screens/utils/auth.dart';
import 'package:maf_mentor/screens/utils/network.dart';
import 'package:bubble/bubble.dart';

class ChatPage extends StatefulWidget {
  Mentee user;
  ChatPage(this.user);
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String typingText;
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
  }
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _chatController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    double px = 1 / pixelRatio;
    final chatList = ListView(
      shrinkWrap: true,
      padding: EdgeInsets.all(8.0),
      children: [
        Bubble(
          alignment: Alignment.center,
          color: Color.fromARGB(255, 212, 234, 244),
          elevation: 1 * px,
          margin: BubbleEdges.only(top: 8.0),
          child: Text('TODAY', style: TextStyle(fontSize: 10)),
        ),
        Bubble(
          child: Text('Hi Jason. Sorry to bother you. I have a queston for you.'),
        ),
        Bubble(

          child: Text('Whats\'up?'),
        ),
        Bubble(

          child: Text('I\'ve been having a problem with my computer.'),
        ),
        Bubble(

          margin: BubbleEdges.only(top: 2.0),
          nip: BubbleNip.no,
          child: Text('Can you help me?'),
        ),
        Bubble(

          child: Text('Ok'),
        ),
        Bubble(
          margin: BubbleEdges.only(top: 8.0),
          child: Text('What\'s the problem?'),
        ),
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
                        NetworkUtils.host +
                            AuthUtils.profilePics +
                            widget.user.profile_image,
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
                                      primaryColor:  Color(0XFF3B3B3C),
                                      primaryColorDark: Colors.red,),
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
                                        prefixIcon:new IconButton(
                                            icon: new Image.asset('assets/images/smile.png',width: 26.0,height: 26.0,),
                                            onPressed: () => openEmoji()
                                        ),
                                        suffixIcon: new IconButton(
                                            icon: new Image.asset('assets/images/send.png',width: 26.0,height: 26.0,),
                                            onPressed: () => sendMessage()
                                        ),
                                        hintStyle: TextStyle(fontSize: 14.0, fontFamily: 'Muli', color: Color(0xff5D697C)),
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
                                  )
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                  ),
                ),
                // Sticker
                (isShowSticker ? buildSticker() : Container()),
              ])
      ),    onWillPop: onBackPress,
    );
  }

  sendMessage() async{
    _chatController.clear();
    FocusScope.of(context).requestFocus(new FocusNode());
    NetworkUtils.showRedToast('Awaiting API Scope');

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
      recommendKeywords: ["racing", "horse"],
      numRecommended: 10,
      onEmojiSelected: (emoji, category) {
        print(emoji);
      },
    );
  }
}
