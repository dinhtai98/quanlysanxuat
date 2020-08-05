import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quanlysanxuattom/models/tank.dart';
import 'package:quanlysanxuattom/services/tinhThanhService.dart';

class Service_Tank {
  // static const ROOT = 'http://192.168.5.112/quanlysanxuattombome/tank.php';
  static const ROOT = 'https://sanxuattom.000webhostapp.com/tank.php';

  static List<List<bool>> check = List(Service_Tinh.check.length);
  // static Future<List<Tank>> getTank(String idtinh, int index) async {
  //   try {
  //     var map = Map<String, dynamic>();
  //     map['action'] = 'GET_TANK_IDTINH';
  //     map['idtinh'] = idtinh;
  //     final response = await http.post(ROOT, body: map);
  //     // print('get response: ${response.body}');
  //     if (response.statusCode == 200) {
  //       List<Tank> list = parseResponse(response.body);

  //       check[index] = List();
  //       for (var i = 0; i < list.length; i++) {
  //         check[index].add(false);
  //       }
  //       return list;
  //     }
  //   } catch (e) {
  //     return List<Tank>();
  //   }
  // }

  static Future<List<Tank>> getTank2(String idtinh, int index) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'GET_TANK_IDTINH2';
      map['idtinh'] = idtinh;
      // map['idgd'] = idgd;
      final response = await http.post(ROOT, body: map);
      // print('get response: ${response.body}');
      if (response.statusCode == 200) {
        List<Tank> list = parseResponse(response.body);

        check[index] = List();
        for (var i = 0; i < list.length; i++) {
          check[index].add(false);
        }
        return list;
      }
    } catch (e) {
      return List<Tank>();
    }
  }

   static Future<List<Tank>> getTank3(String idtinh) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'GET_TANK_IDTINH';
      map['idtinh'] = idtinh;
      final response = await http.post(ROOT, body: map);
      //  print('get response: ${response.body}');
      if (response.statusCode == 200) {
        List<Tank> list = parseResponse(response.body);
        return list;
      }
    } catch (e) {
      return List<Tank>();
    }
  }

  static List<Tank> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Tank>((json) => Tank.formJson(json)).toList();
  }

  static Future<List<Tank>> getTankTheoId(String id) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'GET_TANK_ID';
      map['id'] = id;
      final response = await http.post(ROOT, body: map);
      // print('get response Tên Hồ: ${response.body}');
      if (response.statusCode == 200) {
        List<Tank> tank = parseResponse(response.body);
        return tank;
      }
    } catch (e) {
      print(e);
      return List<Tank>();
    }
  }
}
