import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quanlysanxuattom/models/benh.dart';

class Service_Benh{
  // static const ROOT = 'http://192.168.5.112/quanlysanxuattombome/benh.php';

  static const ROOT = 'https://sanxuattom.000webhostapp.com/benh.php';
  static Future<List<Benh>> getBenh() async {
    try {
      var map = Map<String, dynamic>();
      final response = await http.post(ROOT, body: map);
      //print('get response: ${response.body}');
      if (response.statusCode == 200) {
        List<Benh> list = parseResponse(response.body);
        return list;
      }
    } catch (e) {
      return List<Benh>();
    }
  }

  static List<Benh> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Benh>((json) => Benh.formJson(json)).toList();
  }
}
