import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quanlysanxuattom/models/tinhthanh.dart';

class Service_Tinh {
  // static const ROOT = 'http://192.168.5.112/quanlysanxuattombome/tinhthanh.php';
  static const ROOT = 'https://sanxuattom.000webhostapp.com/tinhthanh.php';

  static List<bool> check;
  static Future<List<Tinh>> getTinh() async {
    try {
      check = List();
      var map = Map<String, dynamic>();
      final response = await http.post(ROOT, body: map);
      //print('get response: ${response.body}');
      if (response.statusCode == 200) {
        List<Tinh> list = parseResponse(response.body);

        check = List();
        for (var i = 0; i < list.length; i++) {
          check.add(false);
        }
        return list;
      }
    } catch (e) {
      return List<Tinh>();
    }
  }

  static List<Tinh> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Tinh>((json) => Tinh.formJson(json)).toList();
  }
}
