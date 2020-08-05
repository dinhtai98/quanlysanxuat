import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quanlysanxuattom/models/giaidoan1.dart';

class Service_GiaiDoan1 {
  // static const ROOT = 'http://192.168.5.112/quanlysanxuattombome/giaidoan1.php';
  static const ROOT = 'https://sanxuattom.000webhostapp.com/giaidoan1.php';
  static const _ADD_INFOR = 'ADD_INFOR';
  static const _GET_GD_HD = 'GET_ALL';

  static Future<List<GiaiDoan1>> getGiaiDoan(String idhd, String idgd) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_GD_HD;
      map['idhd'] = idhd;
      map['idgd'] = idgd;
      final response = await http.post(ROOT, body: map);
      // print('get response: ${response.body}');
      if (response.statusCode == 200) {
        List<GiaiDoan1> list = parseResponse(response.body);
        return list;
      }
    } catch (e) {
      return List<GiaiDoan1>();
    }
  }

  static Future<List<GiaiDoan1>> getSLBan() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'GET_SLBAN';
      final response = await http.post(ROOT, body: map);
      // print('get response: ${response.body}');
      if (response.statusCode == 200) {
        List<GiaiDoan1> list = parseResponse(response.body);
        return list;
      }
    } catch (e) {
      return List<GiaiDoan1>();
    }
  }

  static List<GiaiDoan1> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<GiaiDoan1>((json) => GiaiDoan1.formJson(json)).toList();
  }

  static Future<List<GiaiDoan1>> getGDDaBan(String idhd, String idgd) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'GET_KT_BAN';
      map['idhd'] = idhd;
      map['idgd'] = idgd;
      final response = await http.post(ROOT, body: map);
      // print('get response: ${response.body}');
      if (response.statusCode == 200) {
        List<GiaiDoan1> list = parseResponse(response.body);
        return list;
      }
    } catch (e) {
      return List<GiaiDoan1>();
    }
  }

  static Future<bool> getTTGiaiDoan(String idhd, String idgd) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'GET_KT';
      map['idhd'] = idhd;
      map['idgd'] = idgd;
      final response = await http.post(ROOT, body: map);
      //print('get response: ${response.body}');
      if (response.body == "1") {
        return true;
      } else
        return false;
    } catch (e) {
      return false;
    }
  }

  static Future<String> addGiaiDoan(
      String idhd,
      String hinhThuc,
      String idTinh,
      String benMua,
      String ngayban,
      String soLuongBan,
      String giaiDoan,
      String ketThuc) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _ADD_INFOR;
      map['idhd'] = idhd;
      map['hinhthuc'] = hinhThuc;
      map['idtinh'] = idTinh;
      map['benmua'] = benMua;
      map['ngayban'] = ngayban;
      map['soluongban'] = soLuongBan;
      map['giaidoan'] = giaiDoan;
      map['ketthuc'] = ketThuc;
      final response = await http.post(ROOT, body: map);
      // print('giai doannnnnnnnnnnnnnnnnnnnn add response: ${response.body}');
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }
}
