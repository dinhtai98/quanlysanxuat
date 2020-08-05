import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quanlysanxuattom/models/giaidoan1.dart';
import 'package:quanlysanxuattom/models/honuoitom.dart';
import 'package:quanlysanxuattom/models/tank.dart';
import 'package:quanlysanxuattom/models/thongkebenh.dart';
import 'package:quanlysanxuattom/services/danhsachbenhnhiemService.dart';
import 'package:quanlysanxuattom/services/giaidoan1.dart';
import 'package:quanlysanxuattom/services/hoNuoiTomService.dart';
import 'package:quanlysanxuattom/services/tankService.dart';
import 'package:quanlysanxuattom/views/Barcharts.dart';
import 'package:quanlysanxuattom/views/mainPage.dart';
import 'package:quanlysanxuattom/views/xacNhanThongTinBenhCuaHo.dart';

import 'package:charts_flutter/flutter.dart' as charts;

class QuaTrinhNuoi extends StatefulWidget {
  final String chucVu;
  final String id;
  //final List<GiaiDoan1> listTTGD;
  final String idgd;
  final String tongSoLuongTom;
  QuaTrinhNuoi(
      {Key key,
      @required this.chucVu,
      @required this.id,
      @required this.idgd,
      //@required this.listTTGD,
      @required this.tongSoLuongTom})
      : super(key: key);
  @override
  _QuaTrinhNuoiState createState() => _QuaTrinhNuoiState();
}

final formatterNumber = new NumberFormat("###,###,###");
var title;
var formatter = new DateFormat('yyyy-MM-dd');

class _QuaTrinhNuoiState extends State<QuaTrinhNuoi> {
  List<HoNuoiTom> hoDangNuoi;
  List<Tank> listTank;
  bool check;
  List<List<BenhDaNhiem>> listBenhDaNhiem;
  List<GiaiDoan1> listGD;
  List<GiaiDoan1> listDSTomBan;
  GlobalKey<ScaffoldState> _scaffoldKey;
  List<BenhDaNhiem> listBenhDaNhiemThongKe;
  int soLuongTomChet;
  int soLuongTomNhiemBenh;
  int tongSoLuongThuDuoc;
  String dateWithT;
  List<DateTime> dateTime;
  List<TextEditingController> controllertf;
  List<List<Tank>> tenHo;

  @override
  void initState() {
    super.initState();
    hoDangNuoi = [];
    listTank = [];
    listDSTomBan = [];
    listBenhDaNhiemThongKe = [];
    listGD = [];
    title = 'Thông kê hồ nuôi của tôm';
    soLuongTomChet = 0;
    tongSoLuongThuDuoc = 0;
    soLuongTomNhiemBenh = 0;
    _getHoDangNuoi(widget.id, widget.idgd);
    _getTTGD(widget.id, widget.idgd);
    _getGiaiDoan(widget.id, widget.idgd);
    _scaffoldKey = GlobalKey();
    _getBenhDaNhiem(widget.id, widget.idgd);
    seriesList = [];
  }

  _getBenhDaNhiem(String idhd, String idgd) {
    Service_DanhSachBenhDaNhiem.getDSBenhTheoHD(idhd, idgd).then((dsbenh) {
      // setState(() {
      tenHo = List(dsbenh.length);
      for (var i = 0; i < tenHo.length; i++) {
        tenHo[i] = [];
      }
      listBenhDaNhiemThongKe = dsbenh;
      for (var i = 0; i < tenHo.length; i++) {
        Service_Tank.getTankTheoId(listBenhDaNhiemThongKe[i].idHo)
            .then((result) {
          setState(() {
            tenHo[i] = result;
          });
        });
      }
    });
    for (var i = 0; i < listBenhDaNhiemThongKe.length; i++) {
      soLuongTomChet += int.parse(listBenhDaNhiemThongKe[i].soLuongChet);
      soLuongTomNhiemBenh +=
          int.parse(listBenhDaNhiemThongKe[i].soLuongDaNhiem);
    }
    print(soLuongTomNhiemBenh);
    // });
  }

  _showSnackBar(context, message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  _getGiaiDoan(String idhd, String idgd) {
    Service_GiaiDoan1.getGiaiDoan(idhd, idgd).then((result) {
      setState(() {
        if (null != result) {
          listGD = result;
          //convert String sang date
          // dateWithT =
          //     listGD[0].ngayTha.substring(0, 8) + listGD[0].ngayTha.substring(8);
          // dateTime = DateTime.parse(dateWithT);
        }
      });
    });
  }

  _getTTGD(String id, String idgd) {
    Service_GiaiDoan1.getGDDaBan(id, idgd).then((ttgd) {
      setState(() {
        listDSTomBan = ttgd;
      });
    });
  }

  bool _kiemTraSoluongThu(List<TextEditingController> controllertf) {
    for (var i = 0; i < controllertf.length; i++) {
      if (controllertf[i].text != "") {
        if (int.parse(controllertf[i].text) < 0) {
          _showSnackBar(context, "Bạn phả nhập số lượng lớn hơn 0");
          return false;
        }
      } else {
        _showSnackBar(context, "Bạn phả nhập đầy đủ sản lượng");
        return false;
      }
    }
    return true;
  }

  bool _kiemTraDaThuHoachChua(List<HoNuoiTom> hoDangNuoi) {
    for (var i = 0; i < hoDangNuoi.length; i++) {
      if (int.parse(hoDangNuoi[i].soluongthuduoc) != 0) {
        return false;
      }
    }
    return true;
  }

  _kiemTraDangOGiaiDoan2(List<HoNuoiTom> hdn) {
    int tong = 0;
    for (var i = 0; i < hdn.length; i++) {
      tong += int.parse(hdn[i].soluongthuduoc);
    }
    return tong.toString();
  }

  bool _kiemTraNgayKetThucGiaiDoan(List<DateTime> datetime, DateTime day) {
    for (var i = 0; i < dateTime.length; i++) {
      if (!dateTime[i].add(Duration(days: 30)).isBefore(day)) {
        return false;
      }
    }
    return true;
  }

  _getHoDangNuoi(String idhd, String idgd) {
    Service_HoNuoiTom.getHoNuoiTomCuaHD(idhd, idgd).then((honuoitom) {
      setState(() {
        hoDangNuoi = honuoitom;
        dateTime = List(honuoitom.length);
        // convert String sang date
        for (var i = 0; i < dateTime.length; i++) {
          dateWithT = hoDangNuoi[i].ngayTha.substring(0, 8) +
              hoDangNuoi[i].ngayTha.substring(8);
          dateTime[i] = DateTime.parse(dateWithT);
        }
        listBenhDaNhiem = List(honuoitom.length);
        for (var i = 0; i < hoDangNuoi.length; i++) {
          listBenhDaNhiem[i] = [];
        }
        controllertf = List(honuoitom.length);
        for (var i = 0; i < honuoitom.length; i++) {
          controllertf[i] = new TextEditingController();
        }

        _getTank(hoDangNuoi);
      });
    });
  }

  _getTinhTrangBenh(String idhd, String idgd, String idho, int index) {
    Service_DanhSachBenhDaNhiem.getDSBenhTheoHo(idhd, idgd, idho)
        .then((dsbenh) {
      listBenhDaNhiem[index] = dsbenh;
    });
  }

  _getTank(List<HoNuoiTom> hodangnuoi) {
    for (var i = 0; i < hodangnuoi.length; i++) {
      _getTinhTrangBenh(
          hodangnuoi[i].idhd, hodangnuoi[i].idgd, hodangnuoi[i].idtank, i);
      Service_Tank.getTankTheoId(hodangnuoi[i].idtank).then((tank) {
        for (var i = 0; i < tank.length; i++) {
          setState(() {
            listTank.add(tank[i]);
          });
        }
      });
    }
  }

  _builDanhSachTomDaBan() {
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            "Danh sách các bên mua: ",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            height: 200,
            child: ListView.builder(
                itemCount: listDSTomBan.length,
                itemBuilder: (context, index) {
                  return Container(
                      // decoration: BoxDecoration(
                      //   border: Border.all(width: 0.5, color: Colors.black38),
                      //   borderRadius:
                      //       const BorderRadius.all(Radius.circular(10.0)),
                      // ),
                      margin:
                          EdgeInsets.only(top: 2, bottom: 2, left: 2, right: 2),
                      padding: const EdgeInsets.all(10),
                      child: Card(
                        elevation: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: <Widget>[
                              Text("Tên bên mua: ${listDSTomBan[index].benMua}",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15)),
                              SizedBox(height: 5),
                              Text(
                                  "Số lượng: ${formatterNumber.format(int.parse(listDSTomBan[index].soLuongBan))}",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15)),
                            ],
                          ),
                        ),
                      ));
                }),
          )
        ],
      ),
    );
  }

  _builViewDanhSachHoDangNuoi() {
    return Container(
      child: Column(
        children: <Widget>[
          listDSTomBan != null
              ? listDSTomBan.length > 0 ? _builDanhSachTomDaBan() : Container()
              : Container(),
          Text("Danh Sách các hồ: ",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          listTank.length > 0
              ? Container(
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: listTank.length,
                      itemBuilder: (context, index) {
                        return listGD[index].ketThuc !=
                                "1" //xác định hợp đồng đó kết thúc hay chưa. sau này có thể cải tiến hoặc thay đổi theo trường số lượng thu được của hồ đang nuôi tôm.
                            ? GestureDetector(
                                child: Container(
                                    // decoration: BoxDecoration(
                                    //   border:
                                    //       Border.all(width: 0.5, color: Colors.black38),
                                    //   borderRadius:
                                    //       const BorderRadius.all(Radius.circular(10.0)),
                                    // ),
                                    margin: EdgeInsets.only(
                                        top: 2, bottom: 2, left: 2, right: 2),
                                    padding: const EdgeInsets.all(10),
                                    child: Card(
                                      elevation: 10,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                                "Tên hồ: ${listTank[index].tenHo}",
                                                style: TextStyle(
                                                    color: Colors.black38,
                                                    fontSize: 20)),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                                "Số lượng: ${formatterNumber.format(int.parse(hoDangNuoi[index].soluong))}",
                                                style: TextStyle(
                                                    color: Colors.black38,
                                                    fontSize: 20)),
                                            Text(
                                                "Ngày thả: ${hoDangNuoi[index].ngayTha}",
                                                style: TextStyle(
                                                    color: Colors.black38,
                                                    fontSize: 20)),
                                            listBenhDaNhiem[index].length > 0
                                                ? Text("Tình Trạng: Đã có bệnh",
                                                    style: TextStyle(
                                                        color: Colors.black38,
                                                        fontSize: 20))
                                                : Text(
                                                    "Tình Trạng: Không có bệnh",
                                                    style: TextStyle(
                                                        color: Colors.black38,
                                                        fontSize: 20)),
                                            widget.chucVu != "quản lý bệnh"
                                                ? _kiemTraNgayKetThucGiaiDoan(
                                                        dateTime,
                                                        DateTime.now())
                                                    ? Container(
                                                        height: 40,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.5,
                                                        margin:
                                                            EdgeInsets.all(10),
                                                        decoration: BoxDecoration(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    240,
                                                                    240,
                                                                    240),
                                                            border: Border.all(
                                                                width: 1.2,
                                                                color: Colors
                                                                    .black12),
                                                            borderRadius:
                                                                const BorderRadius
                                                                        .all(
                                                                    const Radius
                                                                            .circular(
                                                                        10))),
                                                        child: TextField(
                                                          controller:
                                                              controllertf[
                                                                  index],
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          decoration: InputDecoration(
                                                              contentPadding:
                                                                  EdgeInsets.only(
                                                                      left: 10,
                                                                      bottom:
                                                                          10),
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              hintText:
                                                                  'Nhập số lượng thu được'),
                                                        ),
                                                      )
                                                    : Container()
                                                : Container(),
                                          ],
                                        ),
                                      ),
                                    )),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => XacNhanBenh(
                                                chucVu: widget.chucVu,
                                                id: hoDangNuoi[index].id,
                                                tenHo: listTank[index].tenHo,
                                                idHo: hoDangNuoi[index].idtank,
                                                idhd: hoDangNuoi[index].idhd,
                                                idgd: hoDangNuoi[index].idgd,
                                                tongSoLuongTom:
                                                    hoDangNuoi[index].soluong,
                                              )));
                                },
                              )
                            : Container();
                      }),
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                RaisedButton(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                    color: Color.fromARGB(255, 66, 165, 245),
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(10.0),
                    child: Text("Xác Nhận GĐ${widget.idgd}"),
                    onPressed: () {
                      if (widget.chucVu != "quản lý bệnh") {
                        if (_kiemTraNgayKetThucGiaiDoan(
                            dateTime, DateTime.now())) {
                          if (_kiemTraSoluongThu(controllertf)) {
                            print("update số lượng thu");
                            for (var i = 0; i < hoDangNuoi.length; i++) {
                              Service_HoNuoiTom.updateSoLuongTomThuDuoc(
                                  hoDangNuoi[i].id, controllertf[i].text);
                            }
                            var route = new MaterialPageRoute(
                                builder: (BuildContext context) => MainPage());

                            Navigator.of(context).pushAndRemoveUntil(route,
                                (Route<dynamic> route) {
                              print(route);
                              return route.isFirst;
                            });
                          }
                        } else
                          _showSnackBar(context, "Chưa đúng ngày");
                      } else
                        _showSnackBar(context, "Bạn không có quyền hạn này");
                    }),
                RaisedButton(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                    color: Color.fromARGB(255, 66, 165, 245),
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(10.0),
                    child: Text("Quay lại"),
                    onPressed: () {
                      //Navigator.pop(context);
                      // var route = new MaterialPageRoute(
                      //     builder: (BuildContext context) => MainPage());

                      // Navigator.of(context).pushAndRemoveUntil(route,
                      //     (Route<dynamic> route) {
                      //   print(route);
                      //   return route.isFirst;
                      // });
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => MainPage()));
                    })
              ],
            ),
          )
        ],
      ),
    );
  }

  _builViewThongKeGiaiDoan() {
    setState(() {
      title = 'Thống kê';
    });
    return Container(
      child: Column(
        children: <Widget>[
          Text("số lượng tôm ban đầu: ${widget.tongSoLuongTom}"),
          Text("Số Lượng tôm chết: $soLuongTomChet"),
          Text("Số Lượng tôm thu được: ${_kiemTraDangOGiaiDoan2(hoDangNuoi)}"),
          Container(
            height: 400,
            child: ListView.builder(
                itemCount: listBenhDaNhiemThongKe.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: Colors.black38),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                    ),
                    margin:
                        EdgeInsets.only(top: 2, bottom: 2, left: 2, right: 2),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        tenHo[index].length > 0
                            ? Text("Tên hồ: ${tenHo[index][0].tenHo}")
                            : Container(),
                        Text(
                            "Tên bệnh: ${listBenhDaNhiemThongKe[index].tenBenh}. Nhiễm ngày ${listBenhDaNhiemThongKe[index].ngayMacBenh}",
                            style:
                                TextStyle(color: Colors.black, fontSize: 15)),
                        SizedBox(height: 5),
                        Text(
                            "Số lượng chữa được: ${formatterNumber.format(int.parse(listBenhDaNhiemThongKe[index].soLuongChuaDuoc))}",
                            style:
                                TextStyle(color: Colors.black, fontSize: 15)),
                        SizedBox(height: 5),
                        Text(
                            "Số lượng chết: ${formatterNumber.format(int.parse(listBenhDaNhiemThongKe[index].soLuongChet))}",
                            style:
                                TextStyle(color: Colors.black, fontSize: 15)),
                        SizedBox(height: 5)
                      ],
                    ),
                  );
                }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              RaisedButton(child: Text("Xác Nhận"), onPressed: () {}),
              RaisedButton(
                  child: Text("hủy"),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ],
          ),
        ],
      ),
    );
  }

  List<charts.Series<dynamic, String>> seriesList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(title),
        ),
        body: WillPopScope(
            //Wrap out body with a `WillPopScope` widget that handles when a user is cosing current route
            onWillPop: () async => hoDangNuoi.length > 0
                ? listTank.length > 0 ? true : false
                : false, //return a `Future` with false value so this route cant be popped or closed.

            // FutureBuilder(
            //   future: Service_HoNuoiTom.getHoNuoiTomCuaHD(widget.id, widget.idgd),
            //   builder: (context, snapshot) {
            //     if (snapshot.hasError) {
            //       print(snapshot.error);
            //     }
            //     return snapshot.hasData
            child: hoDangNuoi.length > 0
                ? SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: _kiemTraDaThuHoachChua(hoDangNuoi)
                        ? _builViewDanhSachHoDangNuoi()
                        //: _builViewThongKeGiaiDoan(),
                        : LegendWithMeasures(
                            _createSampleData(),
                            color: "black",
                            animate: false,
                          ),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                    //);
                    // },
                  )));
  }

  List<charts.Series<OrdinalSales, String>> _createSampleData() {
    final data = [
      new OrdinalSales(
          'Hợp đồng ${widget.id}',
          double.parse(
              (soLuongTomNhiemBenh * 100 / int.parse(widget.tongSoLuongTom))
                  .toStringAsFixed(2)),
          double.parse((soLuongTomChet * 100 / int.parse(widget.tongSoLuongTom))
              .toStringAsFixed(2)),
          double.parse((int.parse(_kiemTraDangOGiaiDoan2(hoDangNuoi)) *
                  100 /
                  int.parse(widget.tongSoLuongTom))
              .toStringAsFixed(2))),
    ];

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Số lượng nhiễm',
        domainFn: (OrdinalSales sales, _) => sales.hoDong,
        measureFn: (OrdinalSales sales, _) => sales.soLuongNhiem,
        data: data,
      ),
      new charts.Series<OrdinalSales, String>(
        id: 'số lượng chết',
        domainFn: (OrdinalSales sales, _) => sales.hoDong,
        measureFn: (OrdinalSales sales, _) => sales.soLuongChet,
        data: data,
      ),
      new charts.Series<OrdinalSales, String>(
        id: 'sản lượng thu được',
        domainFn: (OrdinalSales sales, _) => sales.hoDong,
        measureFn: (OrdinalSales sales, _) => sales.soLuongThuDuoc,
        data: data,
      ),
    ];
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String hoDong;
  final double soLuongNhiem;
  final double soLuongChet;
  final double soLuongThuDuoc;

  OrdinalSales(
      this.hoDong, this.soLuongNhiem, this.soLuongChet, this.soLuongThuDuoc);
}
