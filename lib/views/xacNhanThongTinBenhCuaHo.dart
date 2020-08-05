import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quanlysanxuattom/models/benh.dart';
import 'package:quanlysanxuattom/models/thongkebenh.dart';
import 'package:quanlysanxuattom/services/benhService.dart';
import 'package:quanlysanxuattom/services/danhsachbenhnhiemService.dart';
import 'package:quanlysanxuattom/views/quaTrinhNuoiGD1.dart';

class XacNhanBenh extends StatefulWidget {
  final String chucVu;
  final String id;
  final String tenHo;
  final String idHo;
  final String idhd;
  final String idgd;
  final String tongSoLuongTom;
  XacNhanBenh(
      {Key key,
      @required this.chucVu,
      @required this.id,
      @required this.tenHo,
      @required this.idHo,
      @required this.idhd,
      @required this.idgd,
      @required this.tongSoLuongTom})
      : super(key: key);
  @override
  _XacNhanBenhState createState() => _XacNhanBenhState();
}

final formatterNumber = new NumberFormat("###,###,###");

class _XacNhanBenhState extends State<XacNhanBenh> {
  List<DropdownMenuItem<Benh>> listDropCacBenh;
  Benh _selectedBenh;
  List<Benh> cacLoaiBenh;
  var formatter = new DateFormat('yyyy-MM-dd');
  DateTime _day = DateTime.now();
  BenhDaNhiem benhDaNhiem = BenhDaNhiem();
  GlobalKey<ScaffoldState> _scaffoldKey;
  List<BenhDaNhiem> listBenhDaNhiem;
  int tslConLai;
  TextEditingController txtsln, txtslchet, txtslchua, txthinhthuc;
  String id;
  bool _isUpdate;
  Future<Null> selectDate(BuildContext context) async {
    final AlertDialog _alertDialog = AlertDialog(
      title: Text(
        'Error',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.red, fontSize: 25),
      ),
      content: Text(
        'Bạn không được nhập ngày sau ngày hiện tại ${formatter.format(DateTime.now())}!',
        style: TextStyle(fontSize: 20),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Ok'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
      elevation: 22,
    );
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _day,
        firstDate: DateTime(1970),
        lastDate: DateTime(2100));

    if (picked != null && picked != _day) {
      if (picked.isBefore(DateTime.now())) {
        setState(() {
          _day = picked;
          this.benhDaNhiem.ngayMacBenh = formatter.format(_day);
        });
      } else {
        showDialog(
            context: context,
            builder: (_) => _alertDialog,
            barrierDismissible: false);
        setState(() {
          _day = DateTime.now();
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    txtsln = TextEditingController();
    txtslchet = TextEditingController();
    txtslchua = TextEditingController();
    txthinhthuc = TextEditingController();
    listBenhDaNhiem = [];
    _scaffoldKey = GlobalKey();
    cacLoaiBenh = [];
    _isUpdate = false;
    tslConLai = int.parse(widget.tongSoLuongTom);
    _getBenh();
    _getBenhDaNhiem(widget.idhd, widget.idgd, widget.idHo);
  }

  _showSnackBar(context, message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  onChangedDropItemBenh(Benh selected) {
    setState(() {
      _selectedBenh = selected;
      this.benhDaNhiem.tenBenh = _selectedBenh.tenBenh;
    });
  }
  // xuất thông báo SnackBar

  _getBenhDaNhiem(String idhd, String idgd, String idho) {
    Service_DanhSachBenhDaNhiem.getDSBenhTheoHo(idhd, idgd, idho)
        .then((dsbenh) {
      listBenhDaNhiem = dsbenh;
      for (var i = 0; i < listBenhDaNhiem.length; i++) {
        tslConLai -= int.parse(listBenhDaNhiem[i].soLuongChet);
      }
    });
  }

  _getBenh() {
    Service_Benh.getBenh().then((benh) {
      setState(() {
        cacLoaiBenh = benh;
        listDropCacBenh = builListDropdownMenuCacBenh(cacLoaiBenh);
        _selectedBenh = listDropCacBenh[0].value;

        this.benhDaNhiem.ngayMacBenh = formatter.format(DateTime.now());
        this.benhDaNhiem.idHo = widget.idHo;
        this.benhDaNhiem.tenBenh = _selectedBenh.tenBenh;
        this.benhDaNhiem.idGD = widget.idgd;
        this.benhDaNhiem.idHD = widget.idhd;
        this.benhDaNhiem.soLuongDaNhiem = txtsln.text;
        this.benhDaNhiem.soLuongChuaDuoc = txtslchua.text;
        this.benhDaNhiem.soLuongChet = txtslchet.text;
        this.benhDaNhiem.hinhThucTieuHuy = txthinhthuc.text;
      });
    });
  }

  List<DropdownMenuItem<Benh>> builListDropdownMenuCacBenh(List cacLoaiBenh) {
    List<DropdownMenuItem<Benh>> item = List();
    for (Benh benh in cacLoaiBenh) {
      item.add(DropdownMenuItem(
        value: benh,
        child: Text(benh.tenBenh),
      ));
    }
    return item;
  }

  bool _kiemTraSoluong(int tsl, int nhiem, int chet, int chua) {
    if (nhiem > 0) {
      if (tsl >= nhiem) {
        if (nhiem >= chet + chua) {
          return true;
        } else {
          _showSnackBar(
              context, "Bạn không được nhập tổng quá số tôm đã nhiễm bệnh");
          return false;
        }
      } else {
        _showSnackBar(context, "Bạn không được nhập quá số tôm đã thả");
        return false;
      }
    } else {
      _showSnackBar(
          context, "Bạn không thể xác nhận bệnh vì chưa nhập đủ thông tin");
      return false;
    }
  }

  // _updateSoLuongTomTrongHo(String idhdn, int tsl, int slchet) {
  //   int soluong = tsl - slchet;
  //   Service_HoNuoiTom.updateSoLuongTom(idhdn, soluong.toString())
  //       .then((result) {
  //     if (result == 'success') {
  //       _showSnackBar(context, result);
  //     }
  //   });
  // }

  _addBenhDaNhiem(BenhDaNhiem benhDaNhiem) {
    print(tslConLai);
    if (benhDaNhiem.soLuongChet == "") {
      benhDaNhiem.soLuongChet = "0";
    }
    if (benhDaNhiem.soLuongChuaDuoc == "") {
      benhDaNhiem.soLuongChuaDuoc = "0";
    }
    if (benhDaNhiem.soLuongDaNhiem == "") {
      benhDaNhiem.soLuongDaNhiem = "0";
    }
    if (_kiemTraSoluong(
        tslConLai,
        int.parse(benhDaNhiem.soLuongDaNhiem),
        int.parse(benhDaNhiem.soLuongChet),
        int.parse(benhDaNhiem.soLuongChuaDuoc))) {
      Service_DanhSachBenhDaNhiem.addBenhDaNhiem(benhDaNhiem).then((result) {
        if (result == 'success') {
          _showSnackBar(context, result);
          // _updateSoLuongTomTrongHo(widget.id, int.parse(widget.tongSoLuongTom),
          //     int.parse(benhDaNhiem.soLuongChet));
          var route = new MaterialPageRoute(
              builder: (BuildContext context) => QuaTrinhNuoi(
                  chucVu: widget.chucVu,
                  id: widget.idhd,
                  idgd: widget.idgd,
                  tongSoLuongTom: widget.tongSoLuongTom));

          Navigator.of(context).pushAndRemoveUntil(route,
              (Route<dynamic> route) {
            print(route);
            return route.isFirst;
          });
        }
      });
    }
  }

  _updateBenh(String id, String tenbenh, String ngaymac, String sln,
      String slchet, String slchua, String hinhthuc) {
    if (_kiemTraSoluong(
        tslConLai, int.parse(sln), int.parse(slchet), int.parse(slchua))) {
      Service_DanhSachBenhDaNhiem.upDateBenhDaNhiem(
              id, tenbenh, ngaymac, sln, slchet, slchua, hinhthuc)
          .then((result) {
        if (result == 'success') {
          _showSnackBar(context, result);
          // _updateSoLuongTomTrongHo(widget.id, int.parse(widget.tongSoLuongTom),
          //     int.parse(benhDaNhiem.soLuongChet));
          var route = new MaterialPageRoute(
              builder: (BuildContext context) => QuaTrinhNuoi(
                  chucVu: widget.chucVu,
                  id: widget.idhd,
                  idgd: widget.idgd,
                  tongSoLuongTom: widget.tongSoLuongTom));

          Navigator.of(context).pushAndRemoveUntil(route,
              (Route<dynamic> route) {
            print(route);
            return route.isFirst;
          });
          setState(() {
            _isUpdate = false;
          });
        }
      });
    }
  }

  _builViewXacNhanBenh() {
    return Container(
      padding: EdgeInsets.all(5),
      child: Column(
        children: <Widget>[
          Text(
            "Xác nhận bệnh mới: ",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            margin: EdgeInsets.all(5),
            child: DropdownButton(
                isExpanded: true,
                items: listDropCacBenh,
                value: _selectedBenh,
                onChanged: onChangedDropItemBenh),
          ),
        ],
      ),
    );
  }

  _builDanhSachBenhDaNhiem() {
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            "Danh Sách bệnh đã nhiễm: ",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            height: 200,
            child: ListView.builder(
                itemCount: listBenhDaNhiem.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: Container(
                        // decoration: BoxDecoration(
                        //   border: Border.all(width: 0.5, color: Colors.black38),
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
                                    "Tên bệnh: ${listBenhDaNhiem[index].tenBenh}. Nhiễm ngày ${listBenhDaNhiem[index].ngayMacBenh}",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15)),
                                SizedBox(height: 5),
                                Text(
                                    "Số lượng chữa được: ${formatterNumber.format(int.parse(listBenhDaNhiem[index].soLuongChuaDuoc))}",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15)),
                                SizedBox(height: 5),
                                Text(
                                    "Số lượng chết: ${formatterNumber.format(int.parse(listBenhDaNhiem[index].soLuongChet))}",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15)),
                                SizedBox(height: 5)
                              ],
                            ),
                          ),
                        )),
                    onTap: () {
                      setState(() {
                        id = listBenhDaNhiem[index].id;
                      });

                      _setDuLieuDeSua(
                          listBenhDaNhiem[index].tenBenh,
                          listBenhDaNhiem[index].soLuongDaNhiem,
                          listBenhDaNhiem[index].soLuongChet,
                          listBenhDaNhiem[index].soLuongChuaDuoc,
                          listBenhDaNhiem[index].hinhThucTieuHuy,
                          listBenhDaNhiem[index].id,
                          listBenhDaNhiem[index].ngayMacBenh);
                    },
                  );
                }),
          )
        ],
      ),
    );
  }

  _setDuLieuDeSua(String tenbenh, String sln, String slc, String slchua,
      String hinhthuctieuhuy, String id, String ngay) {
    setState(() {
      _isUpdate = true;
      txtsln.text = sln;
      txtslchua.text = slchua;
      txtslchet.text = slc;
      txthinhthuc.text = hinhthuctieuhuy;
      for (var i = 0; i < listDropCacBenh.length; i++) {
        if (listDropCacBenh[i].value.tenBenh == tenbenh) {
          _selectedBenh = listDropCacBenh[i].value;
          benhDaNhiem.id = id;
          String _day1 = ngay.substring(0, 8) + ngay.substring(8);
          DateTime dateTime = DateTime.parse(_day1);
          _day = dateTime;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextField _txtSoLuongNhiem = TextField(
      controller: txtsln,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          hintText: 'Số lượng nhiễm',
          contentPadding: EdgeInsets.all(10),
          border: InputBorder.none),
      autocorrect: false,
      onChanged: (text) {
        setState(() {
          this.benhDaNhiem.soLuongDaNhiem = text;
        });
      },
    );
    final TextField _txtSoLuongChua = TextField(
      controller: txtslchua,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          hintText: 'Số lượng chữa được: ',
          contentPadding: EdgeInsets.all(10),
          border: InputBorder.none),
      autocorrect: false,
      onChanged: (text) {
        setState(() {
          this.benhDaNhiem.soLuongChuaDuoc = text;
        });
      },
    );
    final TextField _txtSoLuongChet = TextField(
      controller: txtslchet,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          hintText: 'Số lượng chết: ',
          contentPadding: EdgeInsets.all(10),
          border: InputBorder.none),
      autocorrect: false,
      onChanged: (text) {
        setState(() {
          this.benhDaNhiem.soLuongChet = text;
        });
      },
    );

    final TextField _txtCachTieuHuy = TextField(
      controller: txthinhthuc,
      keyboardType: TextInputType.text,
      maxLines: 4,
      decoration: InputDecoration(
          hintText: 'Cách tiêu hủy: ',
          contentPadding: EdgeInsets.all(10),
          border: InputBorder.none),
      autocorrect: false,
      onChanged: (text) {
        setState(() {
          this.benhDaNhiem.hinhThucTieuHuy = text;
        });
      },
    );

    return Scaffold(
      //resizeToAvoidBottomPadding: false,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("${widget.tenHo}"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              widget.chucVu != "quản lý sản xuất"
                  ? Text(
                      "Xác nhận bệnh trong quá trình nuôi: ",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )
                  : listBenhDaNhiem.length == 0
                      ? Text("Bạn không có quyền xác nhận bệnh",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold))
                      : Container(),
              SizedBox(
                height: 5,
              ),
              listBenhDaNhiem.length > 0
                  ? _builDanhSachBenhDaNhiem()
                  : Container(),
              widget.chucVu != "quản lý sản xuất"
                  ? _builViewXacNhanBenh()
                  : Container(),
              widget.chucVu != "quản lý sản xuất"
                  ? Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Container(
                                    width: MediaQuery.of(context)
                                            .size
                                            .width
                                            .toDouble() *
                                        0.43,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "Ngày nhiễm:",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text("${formatter.format(_day)}",
                                                style: TextStyle(fontSize: 17)),
                                            IconButton(
                                              icon: Icon(
                                                Icons.date_range,
                                                size: 25,
                                              ),
                                              onPressed: () {
                                                selectDate(context);
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                                Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.37,
                                    margin: EdgeInsets.only(
                                        left: 20, right: 20, bottom: 10),
                                    decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 240, 240, 240),
                                        border: Border.all(
                                            width: 1.2, color: Colors.black12),
                                        borderRadius: const BorderRadius.all(
                                            const Radius.circular(10))),
                                    child: _txtSoLuongNhiem)
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                width: MediaQuery.of(context)
                                        .size
                                        .width
                                        .toDouble() *
                                    0.43,
                                child: Text(
                                  "Chữa được bao nhiêu: ",
                                  style: TextStyle(fontSize: 17),
                                )),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.37,
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, bottom: 10),
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 240, 240, 240),
                                    border: Border.all(
                                        width: 1.2, color: Colors.black12),
                                    borderRadius: const BorderRadius.all(
                                        const Radius.circular(10))),
                                child: _txtSoLuongChua)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                width: MediaQuery.of(context)
                                        .size
                                        .width
                                        .toDouble() *
                                    0.43,
                                child: Text("Chết bao nhiêu: ",
                                    style: TextStyle(fontSize: 17))),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.37,
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, bottom: 10),
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 240, 240, 240),
                                    border: Border.all(
                                        width: 1.2, color: Colors.black12),
                                    borderRadius: const BorderRadius.all(
                                        const Radius.circular(10))),
                                child: _txtSoLuongChet)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, bottom: 10),
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 240, 240, 240),
                                    border: Border.all(
                                        width: 1.2, color: Colors.black12),
                                    borderRadius: const BorderRadius.all(
                                        const Radius.circular(10))),
                                child: _txtCachTieuHuy)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            RaisedButton(
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(10.0),
                                ),
                                color: Color.fromARGB(255, 66, 165, 245),
                                textColor: Colors.white,
                                padding: const EdgeInsets.all(10.0),
                                child: Text("Xác Nhận"),
                                onPressed: () {
                                  _isUpdate
                                      ? _updateBenh(
                                          id,
                                          _selectedBenh.tenBenh,
                                          formatter.format(_day),
                                          txtsln.text,
                                          txtslchet.text,
                                          txtslchua.text,
                                          txthinhthuc.text)
                                      : _addBenhDaNhiem(benhDaNhiem);
                                }),
                            RaisedButton(
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(10.0),
                                ),
                                color: Color.fromARGB(255, 66, 165, 245),
                                textColor: Colors.white,
                                padding: const EdgeInsets.all(10.0),
                                child: Text("hủy"),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                          ],
                        ),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
