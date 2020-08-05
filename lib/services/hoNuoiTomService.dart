import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quanlysanxuattom/models/honuoitom.dart';

class Service_HoNuoiTom {
  // static const ROOT = 'http://192.168.5.112/quanlysanxuattombome/honuoitom.php';
   static const ROOT = 'https://sanxuattom.000webhostapp.com/honuoitom.php';
  static const _ADD_INFOR = 'ADD_INFOR';
  static const _UPDATE_SL = 'UPDATE_SL';

  static Future<List<HoNuoiTom>> getAllHoNuoiTom() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'GET_ALL';
      final response = await http.post(ROOT, body: map);
      //print('get response: ${response.body}');
      if (response.statusCode == 200) {
        List<HoNuoiTom> list = parseResponse(response.body);
        return list;
      }
    } catch (e) {
      return List<HoNuoiTom>();
    }
  }

  static List<HoNuoiTom> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<HoNuoiTom>((json) => HoNuoiTom.formJson(json)).toList();
  }

  static Future<List<HoNuoiTom>> getHoNuoiTomCuaHD(String idHD,String idgd) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'GET_HO_CUA_HD';
      map['idhd'] = idHD;
      map['idgd'] = idgd;
      final response = await http.post(ROOT, body: map);
      // print('get response: ${response.body}');
      if (response.statusCode == 200) {
        List<HoNuoiTom> list = parseResponse(response.body);
        return list;
      }
    } catch (e) {
      return List<HoNuoiTom>();
    }
  }
  static Future<List<HoNuoiTom>> hoNuoiTheoTank(String id) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'GET_HO_CUA_TANK123';
      map['id'] = id;
      final response = await http.post(ROOT, body: map);
      // print('get response hoNuoiTheoTank: ${response.body}');
      if (response.statusCode == 200) {
        List<HoNuoiTom> list = parseResponse(response.body);
        return list;
      }
    } catch (e) {
      return List<HoNuoiTom>();
    }
  }

  static Future<bool> getTTHoCoDangNuoi(String idho) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'GET_KT';
      map['idho'] = idho;
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

  static Future<String> addHoNuoiTom(String idtank, String idgd,String ngaytha, String soluong,
      String soluongthuduoc, String idhd) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _ADD_INFOR;
      map['idtank'] = idtank;
      map['idgd'] = idgd;
      map['ngaytha'] = ngaytha;
      map['soluong'] = soluong;
      map['soluongthuduoc'] = soluongthuduoc;
      map['idhd'] = idhd;
      final response = await http.post(ROOT, body: map);
      //print('add response: ${response.body}');
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  static Future<String> updateSoLuongTomThuDuoc(
      String idhdn, String soluongthuduoc) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'UPDATE_SLTD';
      map['hdn_id_id'] = idhdn;
      map['soluongthuduoc'] = soluongthuduoc;
      final response = await http.post(ROOT, body: map);
      print('update response: ${response.body}');
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  // static Future<String> updateSoLuongTom(String idhdn, String sl) async {
  //   try {
  //     var map = Map<String, dynamic>();
  //     map['action'] = _UPDATE_SL;
  //     map['hdn_id_id'] = idhdn;
  //     map['sl'] = sl;
  //     final response = await http.post(ROOT, body: map);
  //     print('update response: ${response.body}');
  //     if (response.statusCode == 200) {
  //       return response.body;
  //     } else {
  //       return "error";
  //     }
  //   } catch (e) {
  //     return "error";
  //   }
  // }

}
