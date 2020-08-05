import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quanlysanxuattom/models/hopDong.dart';

class Service_Hop_Dong {
  // static const ROOT = 'http://192.168.5.112/quanlysanxuattombome/hopdong.php';
  static const ROOT = 'https://sanxuattom.000webhostapp.com/hopdong.php';
  static const BEN_MUA = "Cơ sở sản xuất tôm Bình Hưng";

  static Future<List<HopDong>> getHopDong() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'GET_1CS';
      map['benmua'] = BEN_MUA;
      final response = await http.post(ROOT, body: map);
      //print('get response: ${response.body}');
      if (response.statusCode == 200) {
        List<HopDong> list = parseResponse(response.body);
        return list;
      }
    } catch (e) {
      return List<HopDong>();
    }
  }

  static Future<List<HopDong>> getHopDongTheoCS(String tenCS) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'GET_1CS';
      map['benmua'] = tenCS;
      final response = await http.post(ROOT, body: map);
      //print('get response: ${response.body}');
      if (response.statusCode == 200) {
        List<HopDong> list = parseResponse(response.body);
        return list;
      }
    } catch (e) {
      return List<HopDong>();
    }
  }

   static Future<List<HopDong>> getAll() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'GET_ALL';
      final response = await http.post(ROOT, body: map);
      //print('get response: ${response.body}');
      if (response.statusCode == 200) {
        List<HopDong> list = parseResponse(response.body);
        return list;
      }
    } catch (e) {
      return List<HopDong>();
    }
  }

  
  //  static Future<List<HopDong>> getHDGD1() async {
  //   try {
  //     var map = Map<String, dynamic>();
  //     map['action'] = 'GET_HDGD1';
  //     final response = await http.post(ROOT, body: map);
  //     //print('get response: ${response.body}');
  //     if (response.statusCode == 200) {
  //       List<HopDong> list = parseResponse(response.body);
  //       return list;
  //     }
  //   } catch (e) {
  //     return List<HopDong>();
  //   }
  // }
  //  static Future<List<HopDong>> getHDGD2() async {
  //   try {
  //     var map = Map<String, dynamic>();
  //     map['action'] = 'GET_HDGD2';
  //     final response = await http.post(ROOT, body: map);
  //     print('get response: ${response.body}');
  //     if (response.statusCode == 200) {
  //       List<HopDong> list = parseResponse(response.body);
  //       return list;
  //     }
  //   } catch (e) {
  //     return List<HopDong>();
  //   }
  // }

  static Future<List<String>> getHopDongCacCoSo() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'GET_NCS';
      final response = await http.post(ROOT, body: map);
      print('get response: ${response.body}');
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        List<String> list = [];
        for (var u in jsonData) {
          String s = u["benmua"];
          list.add(s);
        }
        print(list);
        return list;
      }
    } catch (e) {
      return List<String>();
    }
  }

  static List<HopDong> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<HopDong>((json) => HopDong.formJson(json)).toList();
  }
}
