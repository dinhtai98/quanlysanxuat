import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quanlysanxuattom/models/user.dart';

class Service_User {
  // static const ROOT = 'http://192.168.5.112/quanlysanxuattombome/user.php';
  static const ROOT = 'https://sanxuattom.000webhostapp.com/user.php';
  static Future<List<User>> getUser(String username, String password) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'GET_USER';
      map['username'] = username;
      map['password'] = password;
      final response = await http.post(ROOT, body: map);
      // print('get response: ${response.body}');
      if (response.statusCode == 200) {
        List<User> user = parseResponse(response.body);
        return user;
      }
    } catch (e) {
      return List<User>();
    }
  }

  static List<User> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<User>((json) => User.formJson(json)).toList();
  }
}
