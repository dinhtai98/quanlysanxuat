import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quanlysanxuattom/models/nhietdotb.dart';

class Service_NhietDo {
  
  // static const ROOT = 'http://192.168.5.112/quanlysanxuattombome/nhietdotb.php';
  static const ROOT = 'https://sanxuattom.000webhostapp.com/nhietdotb.php';
  static Future<List<NhietDoTB>> getNhietDoTB(String idTinh) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'GET_ND_CUA_TINH';
      map['idtinh'] = idTinh;
      final response = await http.post(ROOT, body: map);
      // print('get response Nhiet độ trung bình: ${response.body}');
      if (response.statusCode == 200) {
        List<NhietDoTB> list = parseResponse(response.body);
        return list;
      }
    } catch (e) {
      return List<NhietDoTB>();
    }
  }

  static List<NhietDoTB> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<NhietDoTB>((json) => NhietDoTB.formJson(json)).toList();
  }
}
