import 'dart:async';
import 'dart:io';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:maf_mentor/model/mentee.dart';
import 'package:maf_mentor/screens/utils/auth.dart';
import 'package:maf_mentor/screens/utils/network.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScheduleMeeting extends StatefulWidget {
  Mentee user;
  String names;
  var mentorId;
  ScheduleMeeting(this.user, this.names, this.mentorId);

  @override
  _ScheduleMeetingState createState() => _ScheduleMeetingState();
}

class _ScheduleMeetingState extends State<ScheduleMeeting> {
  String selectedStartDate = "";
  var timeFormat = DateFormat('HH:mm');
  String selectedEndDate = "";
  int startMillis;
  String tokenString;
  int endMillis;
  String selectedTime = "";
  bool _isLoading = false;
  final TextEditingController _titleController = new TextEditingController();
  bool lightTheme = true;
  Color currentColor = Colors.purple;

  void changeColor(Color color) => setState(() => currentColor = color);
  File _image;
  final format = DateFormat("yyyy-MM-dd HH:mm");
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
@override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final mentor = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Center(
          child: new CircleAvatar(
            radius: 25,
            backgroundColor: Color(0xff004782),
            child: ClipOval(
              child: new SizedBox(
                width: 133.0,
                height: 133.0,
                child: (_image != null)
                    ? Image.file(
                  _image,
                  fit: BoxFit.cover,
                )
                    : Image.network(
                  widget.user.profile_image != "noimage.jpg" ? NetworkUtils.host +
                      AuthUtils.profilePics +
                      widget.user.profile_image: AuthUtils.defaultProfileImg,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 20.0,
        ),
        Text(widget.user.first_name + " " + widget.user.last_name,
            style: TextStyle(
                color: Color(0xff1C2447), fontFamily: 'Muli', fontSize: 16.0)),
      ],
    );
    final purpose_text = TextFormField(
      textCapitalization: TextCapitalization.sentences,
        validator: this._validateTitle,
        controller: _titleController,
        decoration: InputDecoration(
          labelText: "e.g Vocal Lessons with " + widget.user.first_name + " " +
              widget.user.last_name,
          labelStyle: TextStyle(
            fontFamily: 'MuliRegular', fontSize: 15.0, color: Color(0xFF3B434C),
          ),

        ));
    final colorPicker = Center(
      child: RaisedButton(
        elevation: 3.0,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  "Schedule Item Color",
                  style: TextStyle(
                    color: Color(0xFF043A67),
                    fontFamily: 'Muli',
                    fontSize: 14.0,
                  ),
                ),
                content: SingleChildScrollView(
                  child: BlockPicker(
                    pickerColor: currentColor,
                    onColorChanged: changeColor,
                  ),
                ),
              );
            },
          );
        },
        child: const Text(
          "Change your schedule appearance color",
          style: TextStyle(
            color: Color(0xFFFFFFFF),
            fontFamily: 'Muli',
            fontSize: 14.0,
          ),
        ),
        color: currentColor,
        textColor: useWhiteForeground(currentColor)
            ? const Color(0xffffffff)
            : const Color(0xff000000),
      ),
    );
    final purpose_heading = Text(
      "Purpose",
      textAlign: TextAlign.start,
      style: TextStyle(
        color: Color(0xFF043A67),
        fontFamily: 'Muli',
        fontSize: 14.0,
      ),
    );
    final start_date_text = Text(
      "Start Date",
      textAlign: TextAlign.start,
      style: TextStyle(
        color: Color(0xFF043A67),
        fontFamily: 'Muli',
        fontSize: 14.0,
      ),
    );
    final end_date_text = Text(
      "End Date",
      textAlign: TextAlign.start,
      style: TextStyle(
        color: Color(0xFF043A67),
        fontFamily: 'Muli',
        fontSize: 14.0,
      ),
    );
    final doneBtn = Container(
      height: 50.0,
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.only(left: 50.0, right: 50.0),
        decoration: BoxDecoration(
            border: Border.all(
                color: Color(0xFF004782), style: BorderStyle.solid, width: 1.0),
            color: Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(20.0)),
        child: InkWell(
          onTap: () {
            setSchedule(_titleController.text, context);
          },
          child: Center(
            child: Text('Done',
                style: TextStyle(color: Color(0xFF004782), fontFamily: 'Muli')),
          ),
        ),
      ),
    );
    final date_picker_start = Column(children: <Widget>[
      Text(''),
      DateTimeField(
        decoration: InputDecoration(
          labelText: 'Tap to Select',
        ),
        format: format,
        onShowPicker: (context, currentValue) async {
          final date = await showDatePicker(
              context: context,
              firstDate: DateTime.now().subtract(Duration(days: 1)),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
          if (date != null) {
            final time = await showTimePicker(
              context: context,
              initialTime:
              TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
            );
            setState(() {
              selectedStartDate = date.toString();
              startMillis = date.millisecondsSinceEpoch;
              selectedTime = '${timeFormat.format(date)}';
            });
            return DateTimeField.combine(date, time);
          } else {
            return currentValue;
          }
        },
      ),
    ]);
    final date_picker_end = Column(children: <Widget>[
      Text(''),
      DateTimeField(
        decoration: InputDecoration(
          labelText: 'Tap to Select',
        ),
        format: format,
        onShowPicker: (context, currentValue) async {
          final date = await showDatePicker(
              context: context,
              firstDate: DateTime.now().subtract(Duration(days: 1)),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
          if (date != null) {
            setState(() {
              selectedEndDate = date.toString();
              endMillis = date.millisecondsSinceEpoch;
            });
            return  endMillis > startMillis ?DateTimeField.combine(date, null):
            NetworkUtils.showSnackBar(_scaffoldKey, "End date must be greater than Start date");
          } else {
            return currentValue;
          }
        },
      ),
    ]);

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
            backgroundColor: Color(0xFFFFFFFF),
            automaticallyImplyLeading: true,
            //`true` if you want Flutter to automatically add Back Button when needed,
            //or `false` if you want to force your own back button every where
            title: Text(
              'Schedule a Meeting',
              style: TextStyle(
                color: Color(0xFF1C2447),
                fontFamily: 'Muli',
                fontSize: 16.0,
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Color(0xFF1C2447),
              onPressed: () => Navigator.pop(context, false),
            )),
        body: _isLoading
            ? Center(
            child: CircularProgressIndicator(
              valueColor:
              new AlwaysStoppedAnimation<Color>(Color(0xFF1C2447)),
            ))
            : Padding(
          padding: const EdgeInsets.only(
              left: 20.0, right: 16.0, top: 30.0, bottom: 30.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                mentor,
                SizedBox(
                  height: 30.0,
                ),
                purpose_heading,
                SizedBox(
                  height: 10.0,
                ),
                purpose_text,
                SizedBox(
                  height: 30.0,
                ),
                start_date_text,
                date_picker_start,
                SizedBox(
                  height: 30.0,
                ),
                end_date_text,
                date_picker_end,
                SizedBox(
                  height: 30.0,
                ),
                colorPicker,
                SizedBox(
                  height: 40.0,
                ),
                doneBtn,
              ],
            ),
          ),
        ));
  }

  // Add validate password function.
  String _validateTitle(String value) {
    if (value
        .trim()
        .isEmpty) {
      return 'Please set a title';
    }
    return null;
  }

  void setSchedule(String title, BuildContext context) async {
    if (title.isEmpty) {
      NetworkUtils.showSnackBar(_scaffoldKey, "Please set a title");
    } else if (selectedStartDate == "") {
      NetworkUtils.showSnackBar(_scaffoldKey, "Please set a start date");
    } else if (selectedEndDate == "") {
      NetworkUtils.showSnackBar(_scaffoldKey, "Please set an end date");
    } else if (selectedEndDate == "") {
      NetworkUtils.showSnackBar(
          _scaffoldKey, "Please indicate your sechedule time");
    } else {
      setState(() {
        _isLoading = true;
      });
      SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
      Map data = {
        'title': _titleController.text,
        'color': currentColor.toString(),
        'start_date': selectedStartDate,
        'end_date': selectedEndDate,
        'mentor_id': widget.mentorId.toString(),
        'mentee_id': widget.user.id.toString(),
        'initiator': widget.mentorId.toString(),
        'scheduled_time': selectedTime};
      final finalData = jsonEncode(data);
      var jsonResponse = null;
      var response = await http.post(
          NetworkUtils.host + AuthUtils.postSchedule,
          headers: {
            'Authorization': "Bearer " + sharedPreferences.getString("token"),
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          },
          body: finalData
      );
      jsonResponse = response.body;
      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        jsonResponse = json.decode(response.body);
        Navigator.pop(context);
        NetworkUtils.showToast("You have succesfully set a schedule with " +
            widget.user.first_name + " " + widget.user.last_name);
          sendNotification(widget.user.id, "New Schedule Request",
              "You have a new schedule request from a mentor");
      } else{
        NetworkUtils.showRedToast('An error ocurred!');
        print(selectedTime);
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void sendNotification(int id, String title, String body) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var uri = NetworkUtils.host + AuthUtils.pushNotification;
    var jsonResponse = null;
    var response = await http.post(uri,
        body: jsonEncode({
          "receivers_id": id,
          "title": title,
          "body": body
        }),
        headers: {'Authorization': 'Bearer ' + sharedPreferences.get("token"),
          'Accept': 'application/json',
          'Content-Type' : 'application/json'} );
    jsonResponse = response.body;
    if (response.statusCode == 200 || response.statusCode == 201) {
      print("success " + jsonResponse.toString());
    } else {
      print("Failed" +jsonResponse.toString());
    }
  }


}