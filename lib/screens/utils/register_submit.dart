import 'dart:async';
import 'dart:convert';
import 'package:maf_mentor/screens/register_page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RegisterSubmit {
  static const _serviceUrl =
      'https://testing.mentorafricafoundation.com/api/v1/register';
  static final _headers = {'Content-Type': 'application/json'};

  Future<dynamic> createRegisterData(RegisterData _data) async {
    try {
      SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
      var jsonResponse = null;
      String jsonData = _toJson(_data);
      print(jsonData);
      final response =
      await http.post(_serviceUrl, headers: _headers, body: jsonData);
      print(response.body);
      jsonResponse = json.decode(response.body);
      print(jsonResponse['data']['access_token']);
      sharedPreferences.setString("token", jsonResponse['data']['access_token']);
      return jsonDecode(response.body);
    } catch (exception) {
      if (exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }


  String _toJson(RegisterData _data) {
    var mapData = new Map();
    mapData["category"] = "mentor";
    mapData["first_name"] = _data.first_name;
    mapData["last_name"] = _data.last_name;
   // mapData["phone"] = _data.phone;
    mapData["country"] = _data.country;
    mapData["email"] = _data.email;
    mapData["password"] = _data.password;
    mapData["password_confirmation"] = _data.confirm_password;
    mapData["gender"] = _data.gender;
    String json = jsonEncode(mapData);
    return json;
  }
}
