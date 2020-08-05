import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quanlysanxuattom/models/thongkebenh.dart';

class Service_DanhSachBenhDaNhiem {
  // static const ROOT =
  //     'http://192.168.5.112/quanlysanxuattombome/danhsachbenh.php';

  static const ROOT = 'https://sanxuattom.000webhostapp.com/danhsachbenh.php';
  static const _ADD_INFOR = 'ADD_INFOR';
  static const _GET_THEO_HD = 'GET_HD';
  static const _GET_THEO_HO = 'GET_HO';

  static Future<List<BenhDaNhiem>> getDSBenhTheoHD(
      String idhd, String idgd) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_THEO_HD;
      map['idhd'] = idhd;
      map['idgd'] = idgd;
      final response = await http.post(ROOT, body: map);
      // print('get response: ${response.body}');
      if (response.statusCode == 200) {
        List<BenhDaNhiem> list = parseResponse(response.body);
        return list;
      }
    } catch (e) {
      return List<BenhDaNhiem>();
    }
  }

  static Future<List<BenhDaNhiem>> getAll() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'GET_ALL';
      final response = await http.post(ROOT, body: map);
      //print('get response: ${response.body}');
      if (response.statusCode == 200) {
        List<BenhDaNhiem> list = parseResponse(response.body);
        return list;
      }
    } catch (e) {
      return List<BenhDaNhiem>();
    }
  }

  static Future<List<BenhDaNhiem>> getDSBenhTheoHo(
      String idhd, String idgd, String idho) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_THEO_HO;
      map['idhd'] = idhd;
      map['idgd'] = idgd;
      map['idho'] = idho;
      final response = await http.post(ROOT, body: map);
      // print('get response: ${response.body}');
      if (response.statusCode == 200) {
        List<BenhDaNhiem> list = parseResponse(response.body);
        return list;
      }
    } catch (e) {
      return List<BenhDaNhiem>();
    }
  }

  static Future<List<BenhDaNhiem>> getDSBenhTheoHoDeThongKe(String idho) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = "GET_THEO_HO_THONG_KE";
      map['idho'] = idho;
      final response = await http.post(ROOT, body: map);
        // print('get response bệnh đã nhiễmmmmmmmmm: ${response.body}');
      if (response.statusCode == 200) {
        List<BenhDaNhiem> list = parseResponse(response.body);
        return list;
      }
    } catch (e) {
      return List<BenhDaNhiem>();
    }
  }

  static List<BenhDaNhiem> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<BenhDaNhiem>((json) => BenhDaNhiem.formJson(json))
        .toList();
  }

  static Future<String> addBenhDaNhiem(BenhDaNhiem benhDaNhiem) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _ADD_INFOR;
      map['tenbenh'] = benhDaNhiem.tenBenh;
      map['soluongnhiem'] = benhDaNhiem.soLuongDaNhiem;
      map['soluongchuaduoc'] = benhDaNhiem.soLuongChuaDuoc;
      map['soluongtieuhuy'] = benhDaNhiem.soLuongChet;
      map['hinhthuctieuhuy'] = benhDaNhiem.hinhThucTieuHuy;
      map['ngaymacbenh'] = benhDaNhiem.ngayMacBenh;
      map['idgd'] = benhDaNhiem.idGD;
      map['idhd'] = benhDaNhiem.idHD;
      map['idho'] = benhDaNhiem.idHo;
      final response = await http.post(ROOT, body: map);
      // print('add response: ${response.body}');
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  static Future<String> upDateBenhDaNhiem(
      String id,
      String tenbenh,
      String ngaymac,
      String sln,
      String slchet,
      String slchua,
      String hinhthuc) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'UP_DATE';
      map['id'] = id;
      map['tenbenh'] = tenbenh;
      map['soluongnhiem'] = sln;
      map['soluongchuaduoc'] = slchua;
      map['soluongtieuhuy'] = slchet;
      map['hinhthuctieuhuy'] = hinhthuc;
      map['ngaymacbenh'] = ngaymac;
      final response = await http.post(ROOT, body: map);
      // print('add response: ${response.body}');
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
