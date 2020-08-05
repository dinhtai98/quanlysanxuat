import 'package:flutter/material.dart';
import 'package:quanlysanxuattom/models/honuoitom.dart';
import 'package:quanlysanxuattom/models/hopDong.dart';
import 'package:quanlysanxuattom/models/tank.dart';
import 'package:quanlysanxuattom/models/thongkebenh.dart';
import 'package:quanlysanxuattom/models/tinhthanh.dart';
import 'package:quanlysanxuattom/services/danhsachbenhnhiemService.dart';
import 'package:quanlysanxuattom/services/hoNuoiTomService.dart';
import 'package:quanlysanxuattom/services/hopDongService.dart';
import 'package:quanlysanxuattom/services/tankService.dart';
import 'package:quanlysanxuattom/services/tinhThanhService.dart';
import 'package:quanlysanxuattom/views/Barcharts.dart';
import 'package:quanlysanxuattom/views/mainPage.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ThongKeToanCuc extends StatefulWidget {
  @override
  _ThongKeToanCucState createState() => _ThongKeToanCucState();
}

class _ThongKeToanCucState extends State<ThongKeToanCuc> {
  static List<HopDong> hopDongs;
  List<bool> giaiDoan1;
  List<List<HoNuoiTom>> hoDangNuoi;
  List<List<HoNuoiTom>> hoDangNuoiGD2;
  int gr = 1;
  List<int> tkNhiemBenh;
  List<int> tkNhiemChuaDuoc;
  List<int> tkNhiemChet;
  List<int> sanLuongThuDuoc;
  List<int> sanLuongBanDau;
  List<int> gd;
  List<int> slban;
  List<Tinh> listTinh;
  Tinh _selectedTinh;
  List<List<HoNuoiTom>> _dshodangnuoi;
  List<List<BenhDaNhiem>> _dsBenhNhiem;
  List<Tank> _dshocuatinh;
  List<DropdownMenuItem<Tinh>> listDropCacTinh;

  bool check = false;
  @override
  void initState() {
    super.initState();
    hoDangNuoi = [];
    hoDangNuoiGD2 = [];
    hopDongs = [];
    listTinh = [];
    _getHopDong();
    tkNhiemBenh = List(13);
    tkNhiemChuaDuoc = List(13);
    tkNhiemChet = List(13);
    sanLuongThuDuoc = List(13);
    sanLuongBanDau = List(13);
    gd = List(13);
    _getTinh();
    _selectedTinh = Tinh();
  }

  _getHopDong() {
    Service_Hop_Dong.getAll().then((hopdong) {
      setState(() {
        hopDongs = hopdong;
        hoDangNuoi = List(hopdong.length);
        hoDangNuoiGD2 = List(hopdong.length);
        for (var i = 0; i < hopdong.length; i++) {
          hoDangNuoi[i] = [];
          _getHoDangNuoi(hopdong[i].id, "1", i);
          _getHoDangNuoiDG2(hopdong[i].id, "2", i);
        }
      });

      giaiDoan1 = List(hopDongs.length);
    });
  }

  _getHoDangNuoi(String idhd, String idgd, int index) {
    Service_HoNuoiTom.getHoNuoiTomCuaHD(idhd, idgd).then((honuoitom) {
      setState(() {
        hoDangNuoi[index] = honuoitom;
      });
    });
  }

  _getHoDangNuoiDG2(String idhd, String idgd, int index) {
    Service_HoNuoiTom.getHoNuoiTomCuaHD(idhd, idgd).then((honuoitom) {
      setState(() {
        hoDangNuoiGD2[index] = honuoitom;
      });
    });
  }

  _getTank(Tinh _selectedTinh) {
    Service_Tank.getTank3(_selectedTinh.id).then((result) {
      setState(() {
        _dshocuatinh = result;
        _dshodangnuoi = List(_dshocuatinh.length);
        _dsBenhNhiem = List(_dshocuatinh.length);
        for (var i = 0; i < _dshodangnuoi.length; i++) {
          _dshodangnuoi[i] = [];
          _dsBenhNhiem[i] = [];
        }
      });
      for (var i = 0; i < _dshodangnuoi.length; i++) {
        _getHoDangNuoiTheoTank(_dshocuatinh[i].id, i);
        _getdsBenhTKTheoTinh(_dshocuatinh[i].id, i);
      }
    });
  }

  _getHoDangNuoiTheoTank(String id, int index) {
    Service_HoNuoiTom.hoNuoiTheoTank(id).then((result) {
      setState(() {
        _dshodangnuoi[index] = result;
      });
    });
  }

  _getdsBenhTKTheoTinh(String idHo, int index) {
    Service_DanhSachBenhDaNhiem.getDSBenhTheoHoDeThongKe(idHo).then((result) {
      setState(() {
        _dsBenhNhiem[index] = result;
        check = true;
      });
    });
  }

  _getTinh() {
    Service_Tinh.getTinh().then((tinh) {
      setState(() {
        listTinh = tinh;
        listDropCacTinh = builListDropdownMenuCacTinh(listTinh);
        _selectedTinh = listDropCacTinh[0].value;
        _getTank(_selectedTinh);
      });
    });
  }

  List<DropdownMenuItem<Tinh>> builListDropdownMenuCacTinh(List cacTinh) {
    List<DropdownMenuItem<Tinh>> item = List();
    for (Tinh tinh in listTinh) {
      item.add(DropdownMenuItem(
        value: tinh,
        child: Text(tinh.tenTinh),
      ));
    }
    return item;
  }

  onChangedDropItemBenh(Tinh selected) {
    setState(() {
      _selectedTinh = selected;
      check = false;
      _getTank(_selectedTinh);
    });
  }

  int _thongTinSLCuaLoaiTom(List<HopDong> hopDongs, String loaiTom,
      List<List<HoNuoiTom>> _dshodangnuoi, int quy) {
    int sl = 0;
    List<String> maHD = [];
    for (var i = 0; i < hopDongs.length; i++) {
      if (hopDongs[i].loaiTom == loaiTom) {
        maHD.add(hopDongs[i].id);
      }
    }
    if (maHD.length > 0) {
      for (var i = 0; i < _dshodangnuoi.length; i++) {
        for (var j = 0; j < _dshodangnuoi[i].length; j++) {
          for (var x = 0; x < maHD.length; x++) {
            if (_dshodangnuoi[i][j].idhd == maHD[x]) {
              String _day = _dshodangnuoi[i][j].ngayTha.substring(0, 8) +
                  _dshodangnuoi[i][j].ngayTha.substring(8);
              DateTime dateTime = DateTime.parse(_day);

              if (quy == 1 && dateTime.month >= 1 && dateTime.month < 4) {
                sl += int.parse(_dshodangnuoi[i][j].soluong);
              }
              if (quy == 2 && dateTime.month >= 4 && dateTime.month < 7) {
                sl += int.parse(_dshodangnuoi[i][j].soluong);
              }
              if (quy == 3 && dateTime.month >= 7 && dateTime.month < 10) {
                sl += int.parse(_dshodangnuoi[i][j].soluong);
              }
              if (quy == 4 && dateTime.month >= 10 && dateTime.month < 13) {
                sl += int.parse(_dshodangnuoi[i][j].soluong);
              }
            }
          }
        }
      }
      return sl;
    } else {
      return sl;
    }
  }

  int _thongTinSLNhiemBenhCuaLoaiTom(List<HopDong> hopDongs, String loaiTom,
      List<List<BenhDaNhiem>> _dsBenhNhiem, int quy) {
    int sl = 0;
    List<String> maHD = [];
    for (var i = 0; i < hopDongs.length; i++) {
      if (hopDongs[i].loaiTom == loaiTom) {
        maHD.add(hopDongs[i].id);
      }
    }
    if (maHD.length > 0) {
      for (var i = 0; i < _dsBenhNhiem.length; i++) {
        for (var j = 0; j < _dsBenhNhiem[i].length; j++) {
          for (var x = 0; x < maHD.length; x++) {
            if (_dsBenhNhiem[i][j].idHD == maHD[x]) {
              String _day = _dsBenhNhiem[i][j].ngayMacBenh.substring(0, 8) +
                  _dsBenhNhiem[i][j].ngayMacBenh.substring(8);
              DateTime dateTime = DateTime.parse(_day);
              if (quy == 1 && dateTime.month >= 1 && dateTime.month < 4) {
                sl += int.parse(_dsBenhNhiem[i][j].soLuongDaNhiem);
              }
              if (quy == 2 && dateTime.month >= 4 && dateTime.month < 7) {
                sl += int.parse(_dsBenhNhiem[i][j].soLuongDaNhiem);
              }
              if (quy == 3 && dateTime.month >= 7 && dateTime.month < 10) {
                sl += int.parse(_dsBenhNhiem[i][j].soLuongDaNhiem);
              }
              if (quy == 4 && dateTime.month >= 10 && dateTime.month < 13) {
                sl += int.parse(_dsBenhNhiem[i][j].soLuongDaNhiem);
              }
            }
          }
        }
      }
      return sl;
    } else {
      return sl;
    }
  }

  int _thongTinSLChuaDuocCuaLoaiTom(List<HopDong> hopDongs, String loaiTom,
      List<List<BenhDaNhiem>> _dsBenhNhiem, int quy) {
    int sl = 0;
    List<String> maHD = [];
    for (var i = 0; i < hopDongs.length; i++) {
      if (hopDongs[i].loaiTom == loaiTom) {
        maHD.add(hopDongs[i].id);
      }
    }
    if (maHD.length > 0) {
      for (var i = 0; i < _dsBenhNhiem.length; i++) {
        for (var j = 0; j < _dsBenhNhiem[i].length; j++) {
          for (var x = 0; x < maHD.length; x++) {
            if (_dsBenhNhiem[i][j].idHD == maHD[x]) {
              String _day = _dsBenhNhiem[i][j].ngayMacBenh.substring(0, 8) +
                  _dsBenhNhiem[i][j].ngayMacBenh.substring(8);
              DateTime dateTime = DateTime.parse(_day);

              if (quy == 1 && dateTime.month >= 1 && dateTime.month < 4) {
                sl += int.parse(_dsBenhNhiem[i][j].soLuongChuaDuoc);
              }
              if (quy == 2 && dateTime.month >= 4 && dateTime.month < 7) {
                sl += int.parse(_dsBenhNhiem[i][j].soLuongChuaDuoc);
              }
              if (quy == 3 && dateTime.month >= 7 && dateTime.month < 10) {
                sl += int.parse(_dsBenhNhiem[i][j].soLuongChuaDuoc);
              }
              if (quy == 4 && dateTime.month >= 10 && dateTime.month < 13) {
                sl += int.parse(_dsBenhNhiem[i][j].soLuongChuaDuoc);
              }
            }
          }
        }
      }
      return sl;
    } else {
      return sl;
    }
  }

  int _thongTinSLChetCuaLoaiTom(List<HopDong> hopDongs, String loaiTom,
      List<List<BenhDaNhiem>> _dsBenhNhiem, int quy) {
    int sl = 0;
    List<String> maHD = [];
    for (var i = 0; i < hopDongs.length; i++) {
      if (hopDongs[i].loaiTom == loaiTom) {
        maHD.add(hopDongs[i].id);
      }
    }
    if (maHD.length > 0) {
      for (var i = 0; i < _dsBenhNhiem.length; i++) {
        for (var j = 0; j < _dsBenhNhiem[i].length; j++) {
          for (var x = 0; x < maHD.length; x++) {
            if (_dsBenhNhiem[i][j].idHD == maHD[x]) {
              String _day = _dsBenhNhiem[i][j].ngayMacBenh.substring(0, 8) +
                  _dsBenhNhiem[i][j].ngayMacBenh.substring(8);
              DateTime dateTime = DateTime.parse(_day);

              if (quy == 1 && dateTime.month >= 1 && dateTime.month < 4) {
                sl += int.parse(_dsBenhNhiem[i][j].soLuongChet);
              }
              if (quy == 2 && dateTime.month >= 4 && dateTime.month < 7) {
                sl += int.parse(_dsBenhNhiem[i][j].soLuongChet);
              }
              if (quy == 3 && dateTime.month >= 7 && dateTime.month < 10) {
                sl += int.parse(_dsBenhNhiem[i][j].soLuongChet);
              }
              if (quy == 4 && dateTime.month >= 10 && dateTime.month < 13) {
                sl += int.parse(_dsBenhNhiem[i][j].soLuongChet);
              }
            }
          }
        }
      }
      return sl;
    } else {
      return sl;
    }
  }

  int _thongTinSLTDCuaLoaiTom(List<HopDong> hopDongs, String loaiTom,
      List<List<HoNuoiTom>> _dshodangnuoi, int quy) {
    int sl = 0;
    List<String> maHD = [];
    for (var i = 0; i < hopDongs.length; i++) {
      if (hopDongs[i].loaiTom == loaiTom) {
        maHD.add(hopDongs[i].id);
      }
    }
    if (maHD.length > 0) {
      for (var i = 0; i < _dshodangnuoi.length; i++) {
        for (var j = 0; j < _dshodangnuoi[i].length; j++) {
          for (var x = 0; x < maHD.length; x++) {
            if (_dshodangnuoi[i][j].idhd == maHD[x]) {
              String _day = _dshodangnuoi[i][j].ngayTha.substring(0, 8) +
                  _dshodangnuoi[i][j].ngayTha.substring(8);
              DateTime dateTime = DateTime.parse(_day);

              if (quy == 1 && dateTime.month >= 1 && dateTime.month < 4) {
                sl += int.parse(_dshodangnuoi[i][j].soluongthuduoc);
              }
              if (quy == 2 && dateTime.month >= 4 && dateTime.month < 7) {
                sl += int.parse(_dshodangnuoi[i][j].soluongthuduoc);
              }
              if (quy == 3 && dateTime.month >= 7 && dateTime.month < 10) {
                sl += int.parse(_dshodangnuoi[i][j].soluongthuduoc);
              }
              if (quy == 4 && dateTime.month >= 10 && dateTime.month < 13) {
                sl += int.parse(_dshodangnuoi[i][j].soluongthuduoc);
              }
            }
          }
        }
      }
      return sl;
    } else {
      return sl;
    }
  }

  List<charts.Series<ThongKeTinhTheoLoai, String>>
      _createSampleDataThongKeLoaiTomTheoTinh(int quy) {
    final List<ThongKeTinhTheoLoai> data = [
      new ThongKeTinhTheoLoai(
          "SLNV",
          _thongTinSLCuaLoaiTom(hopDongs, "Tôm sú", _dshodangnuoi, quy),
          _thongTinSLCuaLoaiTom(
              hopDongs, "Tôm thể chân trắng", _dshodangnuoi, quy)),
      new ThongKeTinhTheoLoai(
          "SLMB",
          _thongTinSLNhiemBenhCuaLoaiTom(hopDongs, "Tôm sú", _dsBenhNhiem, quy),
          _thongTinSLNhiemBenhCuaLoaiTom(
              hopDongs, "Tôm thể chân trắng", _dsBenhNhiem, quy)),
      new ThongKeTinhTheoLoai(
          "SLCD",
          _thongTinSLChuaDuocCuaLoaiTom(hopDongs, "Tôm sú", _dsBenhNhiem, quy),
          _thongTinSLChuaDuocCuaLoaiTom(
              hopDongs, "Tôm thể chân trắng", _dsBenhNhiem, quy)),
      new ThongKeTinhTheoLoai(
          "SLC",
          _thongTinSLChetCuaLoaiTom(hopDongs, "Tôm sú", _dsBenhNhiem, quy),
          _thongTinSLChetCuaLoaiTom(
              hopDongs, "Tôm thể chân trắng", _dsBenhNhiem, quy)),
      new ThongKeTinhTheoLoai(
          "SLTD",
          _thongTinSLTDCuaLoaiTom(hopDongs, "Tôm sú", _dshodangnuoi, quy),
          _thongTinSLTDCuaLoaiTom(
              hopDongs, "Tôm thể chân trắng", _dshodangnuoi, quy)),
    ];

    return [
      new charts.Series<ThongKeTinhTheoLoai, String>(
        id: 'Tôm sú',
        domainFn: (ThongKeTinhTheoLoai sales, _) => sales.kieuSS,
        measureFn: (ThongKeTinhTheoLoai sales, _) => sales.loaiTom1,
        data: data,
      ),
      new charts.Series<ThongKeTinhTheoLoai, String>(
        id: 'Tôm thể chân trắng',
        domainFn: (ThongKeTinhTheoLoai sales, _) => sales.kieuSS,
        measureFn: (ThongKeTinhTheoLoai sales, _) => sales.loaiTom2,
        data: data,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thống kê số liệu"),
      ),
      body: Column(
        children: <Widget>[
          Container(
            width: 150,
            margin: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                DropdownButton(
                    isExpanded: true,
                    items: listDropCacTinh,
                    value: _selectedTinh,
                    onChanged: onChangedDropItemBenh),
              ],
            ),
          ),
          check
              ? Container(
                  height: MediaQuery.of(context).size.height - 170,
                  child: ListView(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Quý 1",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                          Card(
                            color: Colors.transparent,
                            child: LegendWithMeasures(
                              _createSampleDataThongKeLoaiTomTheoTinh(1),
                              color: "black",
                              animate: false,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Quý 2",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                          Card(
                            color: Colors.transparent,
                            child: LegendWithMeasures(
                              _createSampleDataThongKeLoaiTomTheoTinh(2),
                              color: "black",
                              animate: false,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Quý 3",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                          Card(
                            color: Colors.transparent,
                            child: LegendWithMeasures(
                              _createSampleDataThongKeLoaiTomTheoTinh(3),
                              color: "black",
                              animate: false,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Quý 4",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                          Card(
                            color: Colors.transparent,
                            child: LegendWithMeasures(
                              _createSampleDataThongKeLoaiTomTheoTinh(4),
                              color: "black",
                              animate: false,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(),
                )
        ],
      ),
    );
  }
}
