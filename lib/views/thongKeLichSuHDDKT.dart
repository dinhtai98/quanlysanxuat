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

class ThongKeDSHDDKT extends StatefulWidget {
  final String tenHD;
  final String id;
  final int sltdgd1;
  final int sltdgd2;
  final int slvao;
  ThongKeDSHDDKT({
    Key key,
    @required this.tenHD,
    @required this.id,
    @required this.slvao,
    @required this.sltdgd1,
    @required this.sltdgd2,
  }) : super(key: key);
  @override
  _ThongKeDSHDDKTState createState() => _ThongKeDSHDDKTState();
}

final formatter = new NumberFormat("###,###,###");

class _ThongKeDSHDDKTState extends State<ThongKeDSHDDKT> {
  List<List<GiaiDoan1>> listDSTomBan;
  List<List<HoNuoiTom>> hoDangNuoi;
  List<List<Tank>> listTank;
  List<List<List<BenhDaNhiem>>> listBenhDaNhiem;
  @override
  void initState() {
    listDSTomBan = List(2);
    hoDangNuoi = List(2);
    listBenhDaNhiem = List(2);
    listTank = List(2);
    for (var i = 0; i < 2; i++) {
      listDSTomBan[i] = [];
      hoDangNuoi[i] = [];
      listBenhDaNhiem[i] = [];
      listTank[i] = [];
    }
    super.initState();
    _getTTGD(widget.id, "1", 0);
    _getTTGD(widget.id, "2", 1);
    _getHoDangNuoi(widget.id, "1", 0);
    _getHoDangNuoi(widget.id, "2", 1);
  }

  _getTTGD(String id, String idgd, int gd) {
    Service_GiaiDoan1.getGDDaBan(id, idgd).then((ttgd) {
      setState(() {
        listDSTomBan[gd] = ttgd;
      });
    });
  }

  _getHoDangNuoi(String idhd, String idgd, int gd) {
    Service_HoNuoiTom.getHoNuoiTomCuaHD(idhd, idgd).then((honuoitom) {
      setState(() {
        hoDangNuoi[gd] = honuoitom;
        listBenhDaNhiem[gd] = List(hoDangNuoi[gd].length);
        for (var i = 0; i < listBenhDaNhiem[gd].length; i++) {
          listBenhDaNhiem[gd][i] = [];
        }
        _getTank(hoDangNuoi[gd], gd);
      });
    });
  }

  _getTinhTrangBenh(String idhd, String idgd, String idho, int index, int gd) {
    Service_DanhSachBenhDaNhiem.getDSBenhTheoHo(idhd, idgd, idho)
        .then((dsbenh) {
      listBenhDaNhiem[gd][index] = dsbenh;
    });
  }

  _getTank(List<HoNuoiTom> hodangnuoi, int gd) {
    for (var i = 0; i < hodangnuoi.length; i++) {
      _getTinhTrangBenh(
          hodangnuoi[i].idhd, hodangnuoi[i].idgd, hodangnuoi[i].idtank, i, gd);
      Service_Tank.getTankTheoId(hodangnuoi[i].idtank).then((tank) {
        for (var i = 0; i < tank.length; i++) {
          setState(() {
            listTank[gd].add(tank[i]);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thống kê"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              child: Text("${widget.tenHD}",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
            ),
            Card(
              color: Color(0xc9c4bb).withOpacity(.5),
              elevation: 5,
              child: Column(
                children: <Widget>[
                  Text("Giai Đoạn 1",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 25)),
                  Text("Số lượng vào ${formatter.format(widget.slvao)}",
                      style: TextStyle(color: Colors.black54, fontSize: 20)),
                  listDSTomBan[0] != null
                      ? listDSTomBan[0].length > 0
                          ? Column(
                              children: <Widget>[
                                Text("Danh sách đã bán:",
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 20)),
                                Container(
                                  child: ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: listDSTomBan[0].length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          child: Column(
                                            children: <Widget>[
                                              Text(
                                                  "Tên công ty mua: ${listDSTomBan[0][index].benMua}",
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 20)),
                                              Text(
                                                  "Số lượng bán: ${formatter.format(int.parse(listDSTomBan[0][index].soLuongBan))}",
                                                  style: TextStyle(
                                                      color: Colors.black38,
                                                      fontSize: 20)),
                                            ],
                                          ),
                                        );
                                      }),
                                ),
                              ],
                            )
                          : Container()
                      : Container(),
                  Text("Nuôi ở và danh sách bệnh:",
                      style: TextStyle(color: Colors.black54, fontSize: 20)),
                  Container(
                    child: listTank.length > 0
                        ? listTank[0].length > 0
                            ? ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: listTank[0].length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                            "Tên hồ: ${listTank[0][index].tenHo}",
                                            style: TextStyle(
                                                color: Colors.black38,
                                                fontSize: 20)),
                                        listBenhDaNhiem[0][index] != null
                                            ? Container(
                                                child: ListView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    itemCount:
                                                        listBenhDaNhiem[0]
                                                                [index]
                                                            .length,
                                                    itemBuilder:
                                                        (context, index2) {
                                                      return Container(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: <Widget>[
                                                            Text(
                                                                "Tên bệnh: ${listBenhDaNhiem[0][index][index2].tenBenh}",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black38,
                                                                    fontSize:
                                                                        20)),
                                                            Text(
                                                                "Chết: ${formatter.format(int.parse(listBenhDaNhiem[0][index][index2].soLuongChet))}",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black38,
                                                                    fontSize:
                                                                        20))
                                                          ],
                                                        ),
                                                      );
                                                    }),
                                              )
                                            : Container()
                                      ],
                                    ),
                                  );
                                })
                            : Center(
                                child: CircularProgressIndicator(),
                              )
                        : Container(),
                  ),
                  Text(
                      "Thu lại được bao nhiêu: ${formatter.format(widget.sltdgd1)}",
                      style: TextStyle(color: Colors.black54, fontSize: 20))
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Card(
              color: Color(0xc9c4bb).withOpacity(.5),
              elevation: 5,
              child: Column(
                children: <Widget>[
                  Text("Giai Đoạn 2",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 25)),
                  Text("Số lượng vào ${formatter.format(widget.sltdgd1)}",
                      style: TextStyle(color: Colors.black54, fontSize: 20)),
                  listDSTomBan[1].length > 0
                      ? Column(
                          children: <Widget>[
                            Text("Danh sách đã bán:",
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 20)),
                            Container(
                              child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: listDSTomBan[1].length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                              "Tên công ty mua: ${listDSTomBan[1][index].benMua}",
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 20)),
                                          Text(
                                              "Số lượng bán: ${formatter.format(int.parse(listDSTomBan[1][index].soLuongBan))}",
                                              style: TextStyle(
                                                  color: Colors.black38,
                                                  fontSize: 20)),
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        )
                      : Container(),
                  Text("Nuôi ở và danh sách bệnh:",
                      style: TextStyle(color: Colors.black54, fontSize: 20)),
                  Container(
                    child: listTank.length > 0
                        ? listTank[1].length > 0
                            ? ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: listTank[1].length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                            "Tên hồ: ${listTank[1][index].tenHo}",
                                            style: TextStyle(
                                                color: Colors.black38,
                                                fontSize: 20)),
                                        listBenhDaNhiem[1][index] != null
                                            ? Container(
                                                child: ListView.builder(
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        listBenhDaNhiem[1]
                                                                [index]
                                                            .length,
                                                    itemBuilder:
                                                        (context, index2) {
                                                      return Container(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: <Widget>[
                                                            Text(
                                                                "Tên bệnh: ${listBenhDaNhiem[1][index][index2].tenBenh}",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black38,
                                                                    fontSize:
                                                                        20)),
                                                            Text(
                                                                "Chết: ${formatter.format(int.parse(listBenhDaNhiem[1][index][index2].soLuongChet))}",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black38,
                                                                    fontSize:
                                                                        20))
                                                          ],
                                                        ),
                                                      );
                                                    }),
                                              )
                                            : Container()
                                      ],
                                    ),
                                  );
                                })
                            : Center(
                                child: CircularProgressIndicator(),
                              )
                        : Container(),
                  ),
                  Text(
                      "Thu lại được bao nhiêu  ${formatter.format(widget.sltdgd2)}",
                      style: TextStyle(color: Colors.black54, fontSize: 20))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
