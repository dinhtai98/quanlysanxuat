import 'package:flutter/material.dart';
import 'package:quanlysanxuattom/models/giaidoan1.dart';
import 'package:quanlysanxuattom/models/honuoitom.dart';
import 'package:quanlysanxuattom/models/hopDong.dart';
import 'package:quanlysanxuattom/models/nhietdotb.dart';
import 'package:quanlysanxuattom/models/tank.dart';
import 'package:quanlysanxuattom/models/thongkebenh.dart';
import 'package:quanlysanxuattom/models/tinhthanh.dart';
import 'package:quanlysanxuattom/services/danhsachbenhnhiemService.dart';
import 'package:quanlysanxuattom/services/giaidoan1.dart';
import 'package:quanlysanxuattom/services/hoNuoiTomService.dart';
import 'package:quanlysanxuattom/services/hopDongService.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:intl/intl.dart';
import 'package:quanlysanxuattom/services/nhietdoService.dart';
import 'package:quanlysanxuattom/services/tankService.dart';
import 'package:quanlysanxuattom/services/tinhThanhService.dart';
import 'package:quanlysanxuattom/views/Barcharts.dart';
import 'package:quanlysanxuattom/views/giaiDoan1HD.dart';
import 'package:quanlysanxuattom/views/quaTrinhNuoiGD1.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:quanlysanxuattom/views/thongKeLichSuHDDKT.dart';

class MainPage extends StatefulWidget {
  final String chucVu;
  MainPage({Key key, this.chucVu}) : super(key: key);
  String title = 'Giai Đoạn 1';
  @override
  _MainPageState createState() => _MainPageState();
}

final formatter = new NumberFormat("###,###,###");

class _MainPageState extends State<MainPage> {
  static List<HopDong> hopDongs;
  List<bool> giaiDoan1;
  List<List<HoNuoiTom>> hoDangNuoi;
  List<List<HoNuoiTom>> hoDangNuoiGD2;
  int _page = 1;
  GlobalKey _bottomNavigationKey = GlobalKey();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
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
  List<Tank> _dshocuatinh;
  List<List<HoNuoiTom>> _dshodangnuoi;
  List<NhietDoTB> _dsNhietDo;
  List<List<BenhDaNhiem>> _dsBenhNhiem;
  List<DropdownMenuItem<Tinh>> listDropCacTinh;
  bool check = false;
  @override
  void initState() {
    super.initState();
    hoDangNuoi = [];
    hoDangNuoiGD2 = [];
    hopDongs = [];
    _getHopDong();
    listTinh = [];
    tkNhiemBenh = List(13);
    tkNhiemChuaDuoc = List(13);
    tkNhiemChet = List(13);
    sanLuongThuDuoc = List(13);
    sanLuongBanDau = List(13);
    gd = List(13);
    _getDSBenhNhiem();
    _getDSThangThuHoach();
    _geSLBanDuoc();
    _getTinh();
    _selectedTinh = Tinh();
    _dshocuatinh = [];
    _dsNhietDo = [];
  }

  _getTank(Tinh _selectedTinh) {
    Service_Tank.getTank3(_selectedTinh.id).then((result) {
      setState(() {
        if (result != null) {
          _dshocuatinh = result;
          _dshodangnuoi = List(_dshocuatinh.length);
          _dsBenhNhiem = List(_dshocuatinh.length);
          for (var i = 0; i < _dshodangnuoi.length; i++) {
            _dshodangnuoi[i] = [];
            _dsBenhNhiem[i] = [];
          }
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
        if (result != null) {
          _dshodangnuoi[index] = result;
        }
      });
    });
  }

  _getdsBenhTKTheoTinh(String idHo, int index) {
    Service_DanhSachBenhDaNhiem.getDSBenhTheoHoDeThongKe(idHo).then((result) {
      setState(() {
        if (result != null) {
          _dsBenhNhiem[index] = result;
          check = true;
        }
      });
    });
  }

//Tính toán số liệu làm thống kê cho tất cả
  int _thongTinQuyND(List<NhietDoTB> _dsNhietDo, int quy) {
    int x = 0;
    if (quy == 1) {
      x = int.parse(_dsNhietDo[0].quy1);
    }
    if (quy == 2) {
      x = int.parse(_dsNhietDo[0].quy2);
    }
    if (quy == 3) {
      x = int.parse(_dsNhietDo[0].quy3);
    }
    if (quy == 4) {
      x = int.parse(_dsNhietDo[0].quy4);
    }
    return x;
  }

  int _thongTinQuySL(List<List<HoNuoiTom>> _dshodangnuoi, int quy) {
    int tsl = 0;
    for (var i = 0; i < _dshodangnuoi.length; i++) {
      for (var j = 0; j < _dshodangnuoi[i].length; j++) {
        String _day = _dshodangnuoi[i][j].ngayTha.substring(0, 8) +
            _dshodangnuoi[i][j].ngayTha.substring(8);
        DateTime dateTime = DateTime.parse(_day);

        if (quy == 1 && dateTime.month >= 1 && dateTime.month < 4) {
          tsl += int.parse(_dshodangnuoi[i][j].soluong);
        }
        if (quy == 2 && dateTime.month >= 4 && dateTime.month < 7) {
          tsl += int.parse(_dshodangnuoi[i][j].soluong);
        }
        if (quy == 3 && dateTime.month >= 7 && dateTime.month < 10) {
          tsl += int.parse(_dshodangnuoi[i][j].soluong);
        }
        if (quy == 4 && dateTime.month >= 10 && dateTime.month < 13) {
          tsl += int.parse(_dshodangnuoi[i][j].soluong);
        }
      }
    }
    return tsl;
  }

  int _thongTinQuySLmac(List<List<BenhDaNhiem>> _dsBenhNhiem, int quy) {
    int slmac = 0;
    for (var i = 0; i < _dsBenhNhiem.length; i++) {
      for (var j = 0; j < _dsBenhNhiem[i].length; j++) {
        String _day = _dsBenhNhiem[i][j].ngayMacBenh.substring(0, 8) +
            _dsBenhNhiem[i][j].ngayMacBenh.substring(8);
        DateTime dateTime = DateTime.parse(_day);
        if (quy == 1 && dateTime.month >= 1 && dateTime.month < 4) {
          slmac += int.parse(_dsBenhNhiem[i][j].soLuongDaNhiem);
        }
        if (quy == 2 && dateTime.month >= 4 && dateTime.month < 7) {
          slmac += int.parse(_dsBenhNhiem[i][j].soLuongDaNhiem);
        }
        if (quy == 3 && dateTime.month >= 7 && dateTime.month < 10) {
          slmac += int.parse(_dsBenhNhiem[i][j].soLuongDaNhiem);
        }
        if (quy == 4 && dateTime.month >= 10 && dateTime.month < 13) {
          slmac += int.parse(_dsBenhNhiem[i][j].soLuongDaNhiem);
        }
      }
    }
    return slmac;
  }

  int _thongTinQuySLchua(List<List<BenhDaNhiem>> _dsBenhNhiem, int quy) {
    int slChua = 0;
    for (var i = 0; i < _dsBenhNhiem.length; i++) {
      for (var j = 0; j < _dsBenhNhiem[i].length; j++) {
        String _day = _dsBenhNhiem[i][j].ngayMacBenh.substring(0, 8) +
            _dsBenhNhiem[i][j].ngayMacBenh.substring(8);
        DateTime dateTime = DateTime.parse(_day);

        if (quy == 1 && dateTime.month >= 1 && dateTime.month < 4) {
          slChua += int.parse(_dsBenhNhiem[i][j].soLuongChuaDuoc);
        }
        if (quy == 2 && dateTime.month >= 4 && dateTime.month < 7) {
          slChua += int.parse(_dsBenhNhiem[i][j].soLuongChuaDuoc);
        }
        if (quy == 3 && dateTime.month >= 7 && dateTime.month < 10) {
          slChua += int.parse(_dsBenhNhiem[i][j].soLuongChuaDuoc);
        }
        if (quy == 4 && dateTime.month >= 10 && dateTime.month < 13) {
          slChua += int.parse(_dsBenhNhiem[i][j].soLuongChuaDuoc);
        }
      }
    }
    return slChua;
  }

  int _thongTinQuySLChet(List<List<BenhDaNhiem>> _dsBenhNhiem, int quy) {
    int slChet = 0;
    for (var i = 0; i < _dsBenhNhiem.length; i++) {
      for (var j = 0; j < _dsBenhNhiem[i].length; j++) {
        String _day = _dsBenhNhiem[i][j].ngayMacBenh.substring(0, 8) +
            _dsBenhNhiem[i][j].ngayMacBenh.substring(8);
        DateTime dateTime = DateTime.parse(_day);

        if (quy == 1 && dateTime.month >= 1 && dateTime.month < 4) {
          slChet += int.parse(_dsBenhNhiem[i][j].soLuongChet);
        }
        if (quy == 2 && dateTime.month >= 4 && dateTime.month < 7) {
          slChet += int.parse(_dsBenhNhiem[i][j].soLuongChet);
        }
        if (quy == 3 && dateTime.month >= 7 && dateTime.month < 10) {
          slChet += int.parse(_dsBenhNhiem[i][j].soLuongChet);
        }
        if (quy == 4 && dateTime.month >= 10 && dateTime.month < 13) {
          slChet += int.parse(_dsBenhNhiem[i][j].soLuongChet);
        }
      }
    }
    return slChet;
  }

  int _thongTinQuySLThuDuoc(List<List<HoNuoiTom>> _dshodangnuoi, int quy) {
    int tsltd = 0;
    for (var i = 0; i < _dshodangnuoi.length; i++) {
      for (var j = 0; j < _dshodangnuoi[i].length; j++) {
        String _day = _dshodangnuoi[i][j].ngayTha.substring(0, 8) +
            _dshodangnuoi[i][j].ngayTha.substring(8);
        DateTime dateTime = DateTime.parse(_day);

        if (quy == 1 && dateTime.month >= 1 && dateTime.month < 4) {
          tsltd += int.parse(_dshodangnuoi[i][j].soluongthuduoc);
        }
        if (quy == 2 && dateTime.month >= 4 && dateTime.month < 7) {
          tsltd += int.parse(_dshodangnuoi[i][j].soluongthuduoc);
        }
        if (quy == 3 && dateTime.month >= 7 && dateTime.month < 10) {
          tsltd += int.parse(_dshodangnuoi[i][j].soluongthuduoc);
        }
        if (quy == 4 && dateTime.month >= 10 && dateTime.month < 13) {
          tsltd += int.parse(_dshodangnuoi[i][j].soluongthuduoc);
        }
      }
    }
    return tsltd;
  }

  List<charts.Series<ThongKeTinh, String>> _createSampleDataThongKeTheoTinh() {
    final List<ThongKeTinh> data = [
      new ThongKeTinh(
          "Quý 1",
          _thongTinQuyND(_dsNhietDo, 1),
          _thongTinQuySL(_dshodangnuoi, 1),
          _thongTinQuySLmac(_dsBenhNhiem, 1),
          _thongTinQuySLChet(_dsBenhNhiem, 1),
          _thongTinQuySLchua(_dsBenhNhiem, 1),
          _thongTinQuySLThuDuoc(_dshodangnuoi, 1)),
      new ThongKeTinh(
          "Quý 2",
          _thongTinQuyND(_dsNhietDo, 2),
          _thongTinQuySL(_dshodangnuoi, 2),
          _thongTinQuySLmac(_dsBenhNhiem, 2),
          _thongTinQuySLChet(_dsBenhNhiem, 2),
          _thongTinQuySLchua(_dsBenhNhiem, 2),
          _thongTinQuySLThuDuoc(_dshodangnuoi, 2)),
      new ThongKeTinh(
          "Quý 3",
          _thongTinQuyND(_dsNhietDo, 3),
          _thongTinQuySL(_dshodangnuoi, 3),
          _thongTinQuySLmac(_dsBenhNhiem, 3),
          _thongTinQuySLChet(_dsBenhNhiem, 3),
          _thongTinQuySLchua(_dsBenhNhiem, 3),
          _thongTinQuySLThuDuoc(_dshodangnuoi, 3)),
      new ThongKeTinh(
          "Quý 4",
          _thongTinQuyND(_dsNhietDo, 4),
          _thongTinQuySL(_dshodangnuoi, 4),
          _thongTinQuySLmac(_dsBenhNhiem, 4),
          _thongTinQuySLChet(_dsBenhNhiem, 4),
          _thongTinQuySLchua(_dsBenhNhiem, 4),
          _thongTinQuySLThuDuoc(_dshodangnuoi, 4)),
    ];

    return [
      new charts.Series<ThongKeTinh, String>(
        id: 'Nhiệt đồ trung bình',
        domainFn: (ThongKeTinh sales, _) => sales.quy,
        measureFn: (ThongKeTinh sales, _) => sales.nhietdo,
        data: data,
      ),
      new charts.Series<ThongKeTinh, String>(
        id: 'Tổng số lượng',
        domainFn: (ThongKeTinh sales, _) => sales.quy,
        measureFn: (ThongKeTinh sales, _) => sales.sl,
        data: data,
      ),
      new charts.Series<ThongKeTinh, String>(
        id: 'Số lượng mắc bệnh',
        domainFn: (ThongKeTinh sales, _) => sales.quy,
        measureFn: (ThongKeTinh sales, _) => sales.slmacbenh,
        data: data,
      ),
      new charts.Series<ThongKeTinh, String>(
        id: 'Số lượng chữa được',
        domainFn: (ThongKeTinh sales, _) => sales.quy,
        measureFn: (ThongKeTinh sales, _) => sales.slchua,
        data: data,
      ),
      new charts.Series<ThongKeTinh, String>(
        id: 'Số lượng chết',
        domainFn: (ThongKeTinh sales, _) => sales.quy,
        measureFn: (ThongKeTinh sales, _) => sales.slchet,
        data: data,
      ),
      new charts.Series<ThongKeTinh, String>(
        id: 'Số lượng thu được',
        domainFn: (ThongKeTinh sales, _) => sales.quy,
        measureFn: (ThongKeTinh sales, _) => sales.slthuduoc,
        data: data,
      ),
    ];
  }

//Tính toán số liệu để thống kê theo loại.
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

  _getTinh() {
    Service_Tinh.getTinh().then((tinh) {
      setState(() {
        listTinh = tinh;
        listDropCacTinh = builListDropdownMenuCacTinh(listTinh);
        _selectedTinh = listDropCacTinh[0].value;
        _getTank(_selectedTinh);
        _getNhietDoTB(_selectedTinh.id);
      });
    });
  }

  _getNhietDoTB(String idtinh) {
    Service_NhietDo.getNhietDoTB(idtinh).then((result) {
      setState(() {
        _dsNhietDo = result;
      });
    });
  }

  onChangedDropItemBenh(Tinh selected) {
    setState(() {
      _selectedTinh = selected;
      _getTank(_selectedTinh);
      _getNhietDoTB(_selectedTinh.id);
      check = false;
      _dshocuatinh = [];
      _dsNhietDo = [];
    });
  }

  List<DropdownMenuItem<Tinh>> builListDropdownMenuCacTinh(List cacTinh) {
    List<DropdownMenuItem<Tinh>> item = List();
    for (Tinh tinh in cacTinh) {
      item.add(DropdownMenuItem(
        value: tinh,
        child: Text(tinh.tenTinh),
      ));
    }
    return item;
  }

  _geSLBanDuoc() {
    for (var i = 1; i < gd.length; i++) {
      setState(() {
        gd[i] = 0;
      });
    }
    Service_GiaiDoan1.getSLBan().then((result) {
      if (null != result) {
        for (var i = 0; i < result.length; i++) {
          String _day = result[i].ngayBan.substring(0, 8) +
              result[i].ngayBan.substring(8);
          DateTime dateTime = DateTime.parse(_day);
          int index = dateTime.month;
          gd[index] += int.parse(result[i].soLuongBan);
        }
      }
    });
  }

  _getDSThangThuHoach() {
    for (var i = 0; i < 13; i++) {
      setState(() {
        sanLuongThuDuoc[i] = 0;
        sanLuongBanDau[i] = 0;
      });
    }
    Service_HoNuoiTom.getAllHoNuoiTom().then((result) {
      for (var i = 0; i < result.length; i++) {
        String _day =
            result[i].ngayTha.substring(0, 8) + result[i].ngayTha.substring(8);
        DateTime dateTime = DateTime.parse(_day);
        int index = dateTime.month;
        sanLuongThuDuoc[index] += int.parse(result[i].soluongthuduoc);
        sanLuongBanDau[index] += int.parse(result[i].soluong);
      }
    });
  }

  _getDSBenhNhiem() {
    for (var i = 0; i < tkNhiemBenh.length; i++) {
      setState(() {
        tkNhiemBenh[i] = 0;
        tkNhiemChuaDuoc[i] = 0;
        tkNhiemChet[i] = 0;
      });
    }
    Service_DanhSachBenhDaNhiem.getAll().then((result) {
      for (var i = 0; i < result.length; i++) {
        String _day = result[i].ngayMacBenh.substring(0, 8) +
            result[i].ngayMacBenh.substring(8);
        DateTime dateTime = DateTime.parse(_day);
        int index = dateTime.month;
        tkNhiemBenh[index] += int.parse(result[i].soLuongDaNhiem);
        tkNhiemChuaDuoc[index] += int.parse(result[i].soLuongChuaDuoc);
        tkNhiemChet[index] += int.parse(result[i].soLuongChet);
      }
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

  _getHopDong() {
    Service_Hop_Dong.getHopDong().then((hopdong) {
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

  int _kiemTraDangOGiaiDoan2(List<HoNuoiTom> hdn) {
    int tong = 0;
    if (hdn != null) {
      for (var i = 0; i < hdn.length; i++) {
        tong += int.parse(hdn[i].soluongthuduoc);
      }
    }
    return tong;
  }

  // bool _kiemTraSoLuong(HopDong hd, String idgd) {
  //   int sltomconlai = int.parse(hd.soLuong);
  //   List<GiaiDoan1> list = [];
  //   // Service_GiaiDoan1.getGiaiDoan(hd.id, idgd).then((ttgd) {
  //   //   setState(() {
  //   //     list = ttgd;
  //   //   });
  //   // });
  //   // for (var i = 0; i < list.length; i++) {
  //   //   sltomconlai -= int.parse(list[i].soLuongBan);
  //   // }
  //   _getGiaiDoan123(hd.id, idgd, list, sltomconlai);
  //   if (sltomconlai == 0) return true;
  //   return false;
  // }

  //  _getGiaiDoan123(
  //     String id, String idgd, List<GiaiDoan1> list, int sltomconlai) {
  //   Service_GiaiDoan1.getGiaiDoan(id, idgd).then((ttgd) {
  //     setState(() {
  //       list = ttgd;
  //       if (list != null) {
  //         for (var i = 0; i < list.length; i++) {
  //           sltomconlai -= int.parse(list[i].soLuongBan);
  //         }
  //       }
  //     });
  //   });
  //   print(sltomconlai);
  // }

  _showSnackBar(context, message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  _getGiaiDoan(String id, int index) {
    Service_GiaiDoan1.getTTGiaiDoan(id, "1").then((ttgd) {
      setState(() {
        giaiDoan1[index] = ttgd;
      });
      giaiDoan1[index]
          ? Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => QuaTrinhNuoi(
                        chucVu: widget.chucVu,
                        id: hopDongs[index].id,
                        idgd: "1",
                        tongSoLuongTom: hopDongs[index].soLuong,
                      )))
          : widget.chucVu != "quản lý bệnh"
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => GiaiDoan1HD(
                            chucVu: widget.chucVu,
                            id: hopDongs[index].id,
                            idgd: "1",
                            tongSoLuongTom: hopDongs[index].soLuong,
                          )))
              : _showSnackBar(context,
                  "Hợp đồng chưa được xác nhận nuôi, bạn không có quyền truy cập!");
    });
  }

  _getGiaiDoan2(String id, int index) {
    Service_GiaiDoan1.getTTGiaiDoan(id, "2").then((ttgd) {
      setState(() {
        giaiDoan1[index] = ttgd;
      });
      giaiDoan1[index]
          ? Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => QuaTrinhNuoi(
                        chucVu: widget.chucVu,
                        id: hopDongs[index].id,
                        idgd: "2",
                        tongSoLuongTom:
                            _kiemTraDangOGiaiDoan2(hoDangNuoi[index])
                                .toString(),
                      )))
          : widget.chucVu != "quản lý bệnh"
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => GiaiDoan1HD(
                            chucVu: widget.chucVu,
                            id: hopDongs[index].id,
                            idgd: "2",
                            tongSoLuongTom:
                                _kiemTraDangOGiaiDoan2(hoDangNuoi[index])
                                    .toString(),
                          )))
              : _showSnackBar(context,
                  "Hợp đồng chưa được xác nhận nuôi, bạn không có quyền truy cập!");
    });
  }

  _buildThongKeCacHopDong() {
    return Theme(
      data: ThemeData.dark(),
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Radio(
                        activeColor: Colors.white,
                        value: 1,
                        groupValue: gr,
                        onChanged: (T) {
                          setState(() {
                            gr = T;
                          });
                        },
                      ),
                      Text(
                        "Thông kế dịch bệnh",
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Radio(
                        activeColor: Colors.white,
                        value: 2,
                        groupValue: gr,
                        onChanged: (T) {
                          setState(() {
                            gr = T;
                          });
                        },
                      ),
                      Text("Thông kế thu hoạch",
                          style: TextStyle(color: Colors.white, fontSize: 17))
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Radio(
                        activeColor: Colors.white,
                        value: 3,
                        groupValue: gr,
                        onChanged: (T) {
                          setState(() {
                            gr = T;
                          });
                        },
                      ),
                      Text("Thông kế bán",
                          style: TextStyle(color: Colors.white, fontSize: 17))
                    ],
                  ),
                  gr == 1
                      ? Card(
                          color: Colors.transparent,
                          child: LegendWithMeasures(
                            _createSampleData(),
                            color: "white",
                            animate: false,
                          ),
                        )
                      : Container(),
                  gr == 2
                      ? Card(
                          color: Colors.transparent,
                          child: LegendWithMeasures(
                            _createSampleDataThuHoach(),
                            color: "white",
                            animate: false,
                          ),
                        )
                      : Container(),
                  gr == 3
                      ? Card(
                          color: Colors.transparent,
                          child: LegendWithMeasures(
                            _createSampleDataBan(),
                            color: "white",
                            animate: false,
                          ),
                        )
                      : Container(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildThongKeCacHopDongTheoTinh() {
    return SingleChildScrollView(
      child: Theme(
        data: ThemeData.dark(),
        child: Column(
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
            // _dsNhietDo.length > 0 &&
            //         _dshocuatinh.length > 0 &&
            //         _dshodangnuoi.length > 0
            check
                ? Container(
                    height: MediaQuery.of(context).size.height - 220,
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
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            ),
                            Card(
                              color: Colors.transparent,
                              child: LegendWithMeasures(
                                _createSampleDataThongKeLoaiTomTheoTinh(1),
                                color: "white",
                                animate: false,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Quý 2",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            ),
                            Card(
                              color: Colors.transparent,
                              child: LegendWithMeasures(
                                _createSampleDataThongKeLoaiTomTheoTinh(2),
                                color: "white",
                                animate: false,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Quý 3",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            ),
                            Card(
                              color: Colors.transparent,
                              child: LegendWithMeasures(
                                _createSampleDataThongKeLoaiTomTheoTinh(3),
                                color: "white",
                                animate: false,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Quý 4",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            ),
                            Card(
                              color: Colors.transparent,
                              child: LegendWithMeasures(
                                _createSampleDataThongKeLoaiTomTheoTinh(4),
                                color: "white",
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
      ),
    );
  }

  _buildDanhSachHopDongDaKetThuc() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FutureBuilder(
              future: Service_Hop_Dong.getHopDong(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                }
                return snapshot.hasData
                    ? Container(
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return _kiemTraDangOGiaiDoan2(hoDangNuoi[index]) > 0
                                ? _kiemTraDangOGiaiDoan2(hoDangNuoiGD2[index]) >
                                        0
                                    ? GestureDetector(
                                        child: Container(
                                          margin: EdgeInsets.all(2),
                                          padding: const EdgeInsets.all(5),
                                          child: Card(
                                            color:
                                                Color(0xc9c4bb).withOpacity(.5),
                                            elevation: 10,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Column(
                                                children: <Widget>[
                                                  Text(
                                                    snapshot.data[index].benBan,
                                                    style: TextStyle(
                                                        color: Colors.yellow,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w900),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    snapshot
                                                        .data[index].ngayKyHD,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    snapshot
                                                        .data[index].loaiTom,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    'Tổng sản lượng: ${formatter.format(_kiemTraDangOGiaiDoan2(hoDangNuoi[index]) + _kiemTraDangOGiaiDoan2(hoDangNuoiGD2[index]))}',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          // _getGiaiDoan2(
                                          //     snapshot.data[index].id, index);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      ThongKeDSHDDKT(
                                                        tenHD: snapshot
                                                            .data[index].benBan,
                                                        id: snapshot
                                                            .data[index].id,
                                                        slvao: int.parse(
                                                            snapshot.data[index]
                                                                .soLuong),
                                                        sltdgd1:
                                                            _kiemTraDangOGiaiDoan2(
                                                                hoDangNuoi[
                                                                    index]),
                                                        sltdgd2:
                                                            _kiemTraDangOGiaiDoan2(
                                                                hoDangNuoiGD2[
                                                                    index]),
                                                      )));
                                          print("Thống kê các giai đoạn");
                                        },
                                      )
                                    : Container()
                                : Container();
                          },
                          itemCount: snapshot.data.length,
                        ),
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      );
              })
        ],
      ),
    );
  }

  List<charts.Series<TKBD, String>> _createSampleData() {
    final List<TKBD> data = [];
    for (var i = 1; i < 13; i++) {
      data.add(new TKBD(
          (i).toString(), tkNhiemBenh[i], tkNhiemChuaDuoc[i], tkNhiemChet[i]));
    }

    return [
      new charts.Series<TKBD, String>(
        id: 'Số lượng nhiễm',
        domainFn: (TKBD sales, _) => sales.thang,
        measureFn: (TKBD sales, _) => sales.slNhiem,
        data: data,
      ),
      new charts.Series<TKBD, String>(
        id: 'số lượng chết',
        domainFn: (TKBD sales, _) => sales.thang,
        measureFn: (TKBD sales, _) => sales.slChet,
        data: data,
      ),
      new charts.Series<TKBD, String>(
        id: 'sản lượng chữa được',
        domainFn: (TKBD sales, _) => sales.thang,
        measureFn: (TKBD sales, _) => sales.slChua,
        data: data,
      ),
    ];
  }

  List<charts.Series<ThuHoach, String>> _createSampleDataThuHoach() {
    final List<ThuHoach> data = [];
    for (var i = 1; i < 13; i++) {
      data.add(
          new ThuHoach((i).toString(), sanLuongBanDau[i], sanLuongThuDuoc[i]));
    }

    return [
      new charts.Series<ThuHoach, String>(
        id: 'Số lượng ban đầu',
        domainFn: (ThuHoach sales, _) => sales.thang,
        measureFn: (ThuHoach sales, _) => sales.sanLuongBanDau,
        data: data,
      ),
      new charts.Series<ThuHoach, String>(
        id: 'số lượng sản lượng thu được',
        domainFn: (ThuHoach sales, _) => sales.thang,
        measureFn: (ThuHoach sales, _) => sales.sanLuongThuDuoc,
        data: data,
      ),
    ];
  }

  List<charts.Series<Ban, String>> _createSampleDataBan() {
    final List<Ban> data = [];
    for (var i = 1; i < 13; i++) {
      data.add(new Ban((i).toString(), sanLuongBanDau[i], gd[i]));
    }

    return [
      new charts.Series<Ban, String>(
        id: 'Số lượng ban đầu',
        domainFn: (Ban sales, _) => sales.thang,
        measureFn: (Ban sales, _) => sales.sanLuongBanDau,
        data: data,
      ),
      new charts.Series<Ban, String>(
        id: 'Số lượng bán',
        domainFn: (Ban sales, _) => sales.thang,
        measureFn: (Ban sales, _) => sales.sl,
        data: data,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        //Wrap out body with a `WillPopScope` widget that handles when a user is cosing current route
        onWillPop: () async => false,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Container(
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/tomthe.jpg'),
                          fit: BoxFit.cover)),
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                      Colors.black.withOpacity(0.4),
                      Colors.black.withOpacity(0.4)
                    ])),
                  ),
                ),
                Scaffold(
                  key: _scaffoldKey,
                  backgroundColor: Colors.transparent,
                  appBar: AppBar(
                    title: Text(
                      widget.title,
                    ),
                    backgroundColor: Color(0xFFB4C56C).withOpacity(.5),
                  ),
                  body: _page == 1
                      ? SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              FutureBuilder(
                                future: Service_Hop_Dong.getHopDong(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    print(snapshot.error);
                                  }
                                  return snapshot.hasData
                                      ? Container(
                                          child: ListView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              return 
                                              // !_kiemTraSoLuong(
                                              //         snapshot.data[index], "1")
                                              // ?
                                              hoDangNuoi.length > 0
                                                  ? hoDangNuoi[index] != null
                                                      ? _kiemTraDangOGiaiDoan2(
                                                                  hoDangNuoi[
                                                                      index]) <=
                                                              0
                                                          ? GestureDetector(
                                                              child: Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        top: 2,
                                                                        bottom:
                                                                            2,
                                                                        left: 2,
                                                                        right:
                                                                            2),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(5),
                                                                child: Card(
                                                                  color: Color(
                                                                          0xc9c4bb)
                                                                      .withOpacity(
                                                                          .5),
                                                                  elevation: 10,
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .all(
                                                                        10.0),
                                                                    child:
                                                                        Column(
                                                                      children: <
                                                                          Widget>[
                                                                        Text(
                                                                          snapshot
                                                                              .data[index]
                                                                              .benBan,
                                                                          style: TextStyle(
                                                                              color: Colors.yellow,
                                                                              fontSize: 20,
                                                                              fontWeight: FontWeight.w900),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              5,
                                                                        ),
                                                                        Text(
                                                                          snapshot
                                                                              .data[index]
                                                                              .ngayKyHD,
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 20),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              5,
                                                                        ),
                                                                        Text(
                                                                          snapshot
                                                                              .data[index]
                                                                              .loaiTom,
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 15),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              5,
                                                                        ),
                                                                        Text(
                                                                          '${formatter.format(int.parse(snapshot.data[index].soLuong))}',
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 15),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              onTap: () {
                                                                _getGiaiDoan(
                                                                    snapshot
                                                                        .data[
                                                                            index]
                                                                        .id,
                                                                    index);
                                                              },
                                                            )
                                                          : Container()
                                                      : Container()
                                                  // : Container()
                                                  : Container();
                                            },
                                            itemCount: snapshot.data.length,
                                          ),
                                        )
                                      : Center(
                                          child: CircularProgressIndicator(),
                                        );
                                },
                              ),
                            ],
                          ),
                        )
                      : _page == 0
                          ? SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  FutureBuilder(
                                      future: Service_Hop_Dong.getHopDong(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          print(snapshot.error);
                                        }
                                        return snapshot.hasData
                                            ? Container(
                                                child: ListView.builder(
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return 
                                                    // !_kiemTraSoLuong(
                                                    //         snapshot
                                                    //             .data[index],
                                                    //         "2")
                                                    // ?
                                                    hoDangNuoi.length > 0
                                                        ? hoDangNuoi[index] !=
                                                                null
                                                            ? hoDangNuoi[index]
                                                                        .length >
                                                                    0
                                                                ? hoDangNuoiGD2
                                                                            .length >
                                                                        0
                                                                    ? hoDangNuoiGD2[index] !=
                                                                            null
                                                                        ? _kiemTraDangOGiaiDoan2(hoDangNuoi[index]) >
                                                                                0
                                                                            ? _kiemTraDangOGiaiDoan2(hoDangNuoiGD2[index]) <= 0
                                                                                ? GestureDetector(
                                                                                    child: Container(
                                                                                      margin: EdgeInsets.all(2),
                                                                                      padding: const EdgeInsets.all(5),
                                                                                      child: Card(
                                                                                        color: Color(0xc9c4bb).withOpacity(.5),
                                                                                        elevation: 10,
                                                                                        child: Padding(
                                                                                          padding: const EdgeInsets.all(10.0),
                                                                                          child: Column(
                                                                                            children: <Widget>[
                                                                                              Text(
                                                                                                snapshot.data[index].benBan,
                                                                                                style: TextStyle(color: Colors.yellow, fontSize: 20, fontWeight: FontWeight.w900),
                                                                                              ),
                                                                                              SizedBox(
                                                                                                height: 5,
                                                                                              ),
                                                                                              Text(
                                                                                                snapshot.data[index].ngayKyHD,
                                                                                                style: TextStyle(color: Colors.white, fontSize: 20),
                                                                                              ),
                                                                                              SizedBox(
                                                                                                height: 5,
                                                                                              ),
                                                                                              Text(
                                                                                                snapshot.data[index].loaiTom,
                                                                                                style: TextStyle(color: Colors.white, fontSize: 15),
                                                                                              ),
                                                                                              SizedBox(
                                                                                                height: 5,
                                                                                              ),
                                                                                              Text(
                                                                                                '${formatter.format(_kiemTraDangOGiaiDoan2(hoDangNuoi[index]))}',
                                                                                                style: TextStyle(color: Colors.white, fontSize: 15),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    onTap: () {
                                                                                      _getGiaiDoan2(snapshot.data[index].id, index);
                                                                                    },
                                                                                  )
                                                                                : Container()
                                                                            : Container()
                                                                        : Container()
                                                                    : Container()
                                                                // : Container()
                                                                : Container()
                                                            : Container()
                                                        : Container();
                                                  },
                                                  itemCount:
                                                      snapshot.data.length,
                                                ),
                                              )
                                            : Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                      })
                                ],
                              ),
                            )
                          : _page == 2
                              ? _buildThongKeCacHopDong()
                              : _page == 3
                                  ? _buildThongKeCacHopDongTheoTinh()
                                  : _page == 4
                                      ? _buildDanhSachHopDongDaKetThuc()
                                      : Container(),
                  bottomNavigationBar: CurvedNavigationBar(
                    color: Color(0xFFB4C56C).withOpacity(.5),
                    backgroundColor: Color(0xFFB4C56C).withOpacity(.01),
                    key: _bottomNavigationKey,
                    height: 60,
                    items: <Widget>[
                      Icon(Icons.list, size: 20, color: Colors.white),
                      Icon(Icons.library_books, size: 20, color: Colors.white),
                      Icon(Icons.multiline_chart,
                          size: 20, color: Colors.white),
                      Icon(Icons.multiline_chart,
                          size: 20, color: Colors.white),
                      Icon(Icons.library_books, size: 20, color: Colors.white)
                    ],
                    animationDuration: Duration(milliseconds: 200),
                    animationCurve: Curves.bounceInOut,
                    index: 1,
                    onTap: (index) {
                      setState(() {
                        _page = index;
                        index == 1
                            ? widget.title = "Giai Đoạn 1"
                            : index == 0
                                ? widget.title = "Giai Đoạn 2"
                                : index == 2
                                    ? widget.title = "Thống Kê"
                                    : index == 3
                                        ? widget.title = "Thống Kê Theo Tỉnh"
                                        : widget.title = "Hợp đồng đã kết thúc";
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class TKBD {
  final String thang;
  final int slNhiem;
  final int slChua;
  final int slChet;
  TKBD(this.thang, this.slNhiem, this.slChua, this.slChet);
}

class ThuHoach {
  final String thang;
  final int sanLuongBanDau;
  final int sanLuongThuDuoc;
  ThuHoach(this.thang, this.sanLuongBanDau, this.sanLuongThuDuoc);
}

class Ban {
  final String thang;
  final int sanLuongBanDau;
  final int sl;
  Ban(this.thang, this.sanLuongBanDau, this.sl);
}

class ThongKeTinh {
  final String quy;
  final int nhietdo;
  final int sl;
  final int slmacbenh;
  final int slchet;
  final int slchua;
  final int slthuduoc;
  ThongKeTinh(this.quy, this.nhietdo, this.sl, this.slmacbenh, this.slchet,
      this.slchua, this.slthuduoc);
}

class ThongKeTinhTheoLoai {
  final int loaiTom1;
  final int loaiTom2;
  final String kieuSS;
  ThongKeTinhTheoLoai(this.kieuSS, this.loaiTom1, this.loaiTom2);
}
