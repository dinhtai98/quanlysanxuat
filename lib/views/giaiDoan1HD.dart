import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quanlysanxuattom/models/giaidoan1.dart';
import 'package:quanlysanxuattom/models/tank.dart';
import 'package:quanlysanxuattom/models/tinhthanh.dart';
import 'package:quanlysanxuattom/services/giaidoan1.dart';
import 'package:quanlysanxuattom/services/hoNuoiTomService.dart';
import 'package:quanlysanxuattom/services/hopDongService.dart';
import 'package:quanlysanxuattom/services/tinhThanhService.dart';
import 'package:quanlysanxuattom/services/tankService.dart';
import 'package:quanlysanxuattom/views/mainPage.dart';
import 'package:quanlysanxuattom/views/quaTrinhNuoiGD1.dart';

class GiaiDoan1HD extends StatefulWidget {
  final String chucVu;
  final String id;
  final String idgd;
  final String tongSoLuongTom;
  GiaiDoan1HD(
      {Key key,
      @required this.chucVu,
      @required this.id,
      @required this.idgd,
      @required this.tongSoLuongTom})
      : super(key: key);
  @override
  _GiaiDoan1HDState createState() => _GiaiDoan1HDState();
}

final formatterNumber = new NumberFormat("###,###,###");

class _GiaiDoan1HDState extends State<GiaiDoan1HD> {
  static List<String> listHinhThuc = [
    'Nuôi toàn bộ',
    'Bán lại',
  ];
  GlobalKey<ScaffoldState> _scaffoldKey;
  List<DropdownMenuItem<String>> listDrop;
  String _selectedString;
  List<Tinh> listTinh;
  List<List<Tank>> listTank;
  List<List<bool>> check;
  List<bool> checkTinh;
  List<List<TextEditingController>> controllertf;
  List<GiaiDoan1> listDSTomBan;
  GiaiDoan1 giaiDoan1Ban;
  List<List<String>> listNgayTha;
  var now = new DateTime.now();
  var formatter = new DateFormat('yyyy-MM-dd');

  DateTime _day = DateTime.now();

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
        initialDate: now,
        firstDate: DateTime(1970),
        lastDate: DateTime(2100));

    if (picked != null && picked != now) {
      if (picked.isBefore(DateTime.now())) {
        setState(() {
          now = picked;
          //this.giaiDoan1Ban.ngayTha = formatter.format(now);
        });
      } else {
        showDialog(
            context: context,
            builder: (_) => _alertDialog,
            barrierDismissible: false);
        setState(() {
          now = DateTime.now();
        });
      }
    }
  }

  Future<Null> selectDateTha(BuildContext context, index1, index) async {
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
          listNgayTha[index1][index] = formatter.format(_day);
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

  int sltomconlai;
  @override
  void initState() {
    super.initState();
    listDrop = builListDropdownMenu(listHinhThuc);
    _scaffoldKey = GlobalKey();
    listTinh = [];
    listDSTomBan = [];
    giaiDoan1Ban = GiaiDoan1();
    sltomconlai = int.parse(widget.tongSoLuongTom);
    _getTinh();
    _selectedString = listDrop[0].value;
    _getGiaiDoan(widget.id);
    giaiDoan1Ban.idHD = widget.id;
    giaiDoan1Ban.hinhThuc = _selectedString;
    giaiDoan1Ban.giaiDoan = widget.idgd;
    giaiDoan1Ban.ketThuc =
        "0"; // xác định hợp đồng đó kết thúc hay chưa. sau này có thể cải tiến hoặc thay đổi theo trường số lượng thu được của hồ đang nuôi tôm.
    giaiDoan1Ban.idTinh = "-1";
    giaiDoan1Ban.benMua = "";
    giaiDoan1Ban.ngayBan = formatter.format(DateTime.now());
    giaiDoan1Ban.soLuongBan = "";
  }

// xuất thông báo SnackBar
  _showSnackBar(context, message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

//lấy thông tin các tỉnh
  _getTinh() {
    Service_Tinh.getTinh().then((tinh) {
      setState(() {
        listTinh = tinh;
        checkTinh = Service_Tinh.check;
        listTank = List(listTinh.length);
        check = List(listTinh.length);
        controllertf = List(listTinh.length);
        listNgayTha = List(listTinh.length);
      });
    });
  }

//lấy thông tin dánh sách đã bán của hợp đồng trong giai đoạn đó (vd: giai đoạn 1),
  _getGiaiDoan(String id) {
    Service_GiaiDoan1.getGiaiDoan(id, widget.idgd).then((ttgd) {
      setState(() {
        listDSTomBan = ttgd;
        if (listDSTomBan != null) {
          for (var i = 0; i < listDSTomBan.length; i++) {
            sltomconlai -= int.parse(listDSTomBan[i].soLuongBan);
          }
        }
      });
    });
  }

  bool _kiemTraSoluong(List<List<TextEditingController>> controllertf, int sl) {
    int tong = 0;
    for (var i = 0; i < controllertf.length; i++) {
      if (controllertf[i] != null) {
        for (var j = 0; j < controllertf[i].length; j++) {
          if (controllertf[i][j].text != "") {
            if (int.parse(controllertf[i][j].text) > 0) {
              tong += int.parse(controllertf[i][j].text);
            } else {
              _showSnackBar(context, "Bạn không được nhập giá trị nhỏ hơn 1");
              return false;
            }
          }
        }
      }
    }

    if (tong > sl) {
      _showSnackBar(context,
          "Bạn nhập quá tổng số lượng ${formatterNumber.format(sltomconlai)}");
      return false;
    } else if (tong == 0) {
      _showSnackBar(context, "Bạn chưa nhập dữ liệu");
      return false;
    } else if (tong < sl) {
      _showSnackBar(context,
          "Bạn nhập dữ liệu phải bằng số lượng tôm đang có ${formatterNumber.format(sltomconlai)}");
      return false;
    } else {
      return true;
    }
  }

// kiểm thông tin hồ có đang nuôi hay không?

// lấy thông tin hồ
  _getTank(String idtinh, int index) {
    Service_Tank.getTank2(idtinh, index).then((tank) {
      if (tank != null && tank.length > 0) {
        setState(() {
          listTank[index] = tank;
          check[index] = Service_Tank.check[index];
          checkTinh[index] = !checkTinh[index];
          controllertf[index] = List(check[index].length);
          listNgayTha[index] = List(check[index].length);
          for (var i = 0; i < check[index].length; i++) {
            controllertf[index][i] = new TextEditingController();
            listNgayTha[index][i] = formatter.format(DateTime.now());
          }
        });
      } else {
        _showSnackBar(context, "Tỉnh không còn hồ trống");
      }
    });
  }

  List<DropdownMenuItem<String>> builListDropdownMenu(List listHinhThuc) {
    List<DropdownMenuItem<String>> item = List();
    for (String hinhThuc in listHinhThuc) {
      item.add(DropdownMenuItem(
        value: hinhThuc,
        child: Text(hinhThuc),
      ));
    }
    return item;
  }

  onChangedDropItem(String selected) {
    setState(() {
      _selectedString = selected;
      giaiDoan1Ban.hinhThuc = _selectedString;
    });
  }

// Chức năng thêm thông tin bán tôm vào cơ sở dữ liệu
  _addTTBan(GiaiDoan1 gd) {
    if (sltomconlai - int.parse(gd.soLuongBan) == 0) {
      gd.ketThuc = "1";
      Service_GiaiDoan1.addGiaiDoan(gd.idHD, gd.hinhThuc, gd.idTinh, gd.benMua,
              gd.ngayBan, gd.soLuongBan, gd.giaiDoan, gd.ketThuc)
          .then((result) {
        if (result == 'success') {
          _showSnackBar(context, result);
          var route = new MaterialPageRoute(
              builder: (BuildContext context) => MainPage());

          Navigator.of(context).pushAndRemoveUntil(route,
              (Route<dynamic> route) {
            print(route);
            return route.isFirst;
          });
        }
      });
    } else if (sltomconlai - int.parse(gd.soLuongBan) > 0) {
      Service_GiaiDoan1.addGiaiDoan(gd.idHD, gd.hinhThuc, gd.idTinh, gd.benMua,
              gd.ngayBan, gd.soLuongBan, gd.giaiDoan, gd.ketThuc)
          .then((result) {
        if (result == 'success') {
          _showSnackBar(context, result);
          var route = new MaterialPageRoute(
              builder: (BuildContext context) => MainPage());

          Navigator.of(context).pushAndRemoveUntil(route,
              (Route<dynamic> route) {
            print(route);
            return route.isFirst;
          });
        }
      });
    } else {
      _showSnackBar(context, "Bạn không thể bán quá số lượng tôm đang có");
    }
  }

// kiểm tra hợp đồng đã từng bán

// Chức năng thêm thông tin vào cơ sở dữ liệu
  _addThongTinGiaiDoan1(
      String idhd,
      String hinhThuc,
      String idTinh,
      String benMua,
      String ngayban,
      String soLuongBan,
      String giaiDoan,
      String ketthuc) {
    Service_GiaiDoan1.addGiaiDoan(idhd, hinhThuc, idTinh, benMua, ngayban,
            soLuongBan, giaiDoan, ketthuc)
        .then((result) {
      if (result == 'success') {
        // _showSnackBar(context, result);
        var route = new MaterialPageRoute(
            builder: (BuildContext context) => QuaTrinhNuoi(
                chucVu: widget.chucVu,
                id: widget.id,
                idgd: giaiDoan,
                tongSoLuongTom: widget.tongSoLuongTom));

        Navigator.of(context).pushAndRemoveUntil(route, (Route<dynamic> route) {
          print(route);
          return route.isFirst;
        });
      }
    });
  }

// thêm thông tin hồ nuôi tôm sau khi nuôi
  _addThongTinHoNuoi(String idho, String idgd, String ngaytha, String soluong,
      String soluongthuduoc, String idhd) {
    Service_HoNuoiTom.addHoNuoiTom(
            idho, idgd, ngaytha, soluong, soluongthuduoc, idhd)
        .then((result) {
      if (result == 'success') {
        // _showSnackBar(context, result);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextField _txtBenMua = TextField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          hintText: 'Tên công ty bên mua',
          contentPadding: EdgeInsets.all(10),
          border: InputBorder.none),
      autocorrect: false,
      onChanged: (text) {
        setState(() {
          this.giaiDoan1Ban.benMua = text;
        });
      },
    );
    final TextField _txtSoLuong = TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          hintText: 'Số lượng bán',
          contentPadding: EdgeInsets.all(10),
          border: InputBorder.none),
      autocorrect: false,
      onChanged: (text) {
        setState(() {
          this.giaiDoan1Ban.soLuongBan = text;
        });
      },
    );
    return Scaffold(
      key: _scaffoldKey,
      // resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: Text("Giai đoạn 1 của hợp đồng ${widget.id}"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: sltomconlai > 0
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.list),
                        SizedBox(
                          width: 10,
                        ),
                        DropdownButton(
                            items: listDrop,
                            value: _selectedString,
                            onChanged: onChangedDropItem),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _selectedString == "Nuôi toàn bộ"
                      ? Container(
                          child: _buildViewNuoi1(),
                        )
                      : Container(),
                  _selectedString == "Bán lại"
                      ? Container(
                          child: Column(
                          children: <Widget>[
                            listDSTomBan.length > 0
                                ? _builDanhSachTomDaBan()
                                : Container(),
                            _builViewBanLai(_txtBenMua, _txtSoLuong),
                          ],
                        ))
                      : Container(),
                ],
              )
            : Container(
                child: Text("Số lượng tôm đã bán hết"),
              ),
      ),
    );
  }

  _buildViewNuoi1() {
    return listTinh != null
        ? listTinh.length > 0
            ? Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Chọn nơi nuôi với số lượng tôm ${formatterNumber.format(sltomconlai)}: ",
                      style: TextStyle(fontSize: 17),
                    ),
                    Container(
                      height:
                          MediaQuery.of(context).size.height.toDouble() - 250,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Checkbox(
                                    value: checkTinh[index],
                                    onChanged: (bool value) {
                                      setState(() {
                                        if (!checkTinh[index]) {
                                          _getTank(listTinh[index].id, index);
                                        } else {
                                          checkTinh[index] = !checkTinh[index];
                                          //   for (var i = 0;
                                          //       i < check[index].length;
                                          //       i++) {
                                          //     controllertf[index][i] =
                                          //         new TextEditingController();
                                          //     listNgayTha[index][i] =
                                          //         formatter.format(DateTime.now());
                                          //   }
                                        }
                                      });
                                    },
                                  ),
                                  Text(
                                    '${listTinh[index].tenTinh}',
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ],
                              ),
                              checkTinh[index]
                                  ? _selectedTank(index, listTank[index].length)
                                  : Container(),
                            ],
                          );
                        },
                        itemCount: listTinh.length,
                      ),
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
                          child:
                              Text('Xác nhận', style: TextStyle(fontSize: 20)),
                          onPressed: () {
                            if (_kiemTraSoluong(controllertf, sltomconlai)) {
                              for (var i = 0; i < controllertf.length; i++) {
                                if (controllertf[i] != null) {
                                  for (var j = 0;
                                      j < controllertf[i].length;
                                      j++) {
                                    if (controllertf[i][j].text != "") {
                                      if (listDSTomBan.length > 0) {
                                        _addThongTinGiaiDoan1(
                                            widget.id,
                                            "Bán một phần",
                                            listTinh[i].id,
                                            "",
                                            "0000-00-00",
                                            "0",
                                            widget.idgd,
                                            "0");
                                        _addThongTinHoNuoi(
                                            listTank[i][j].id,
                                            widget.idgd,
                                            listNgayTha[i][j],
                                            controllertf[i][j].text,
                                            "0",
                                            widget.id.toString());
                                      } else {
                                        _addThongTinGiaiDoan1(
                                            widget.id,
                                            _selectedString,
                                            listTinh[i].id,
                                            "",
                                            "0000-00-00",
                                            "0",
                                            widget.idgd,
                                            "0");
                                        _addThongTinHoNuoi(
                                            listTank[i][j].id,
                                            widget.idgd,
                                            listNgayTha[i][j],
                                            controllertf[i][j].text,
                                            "0",
                                            widget.id.toString());
                                      }
                                    }
                                  }
                                }
                              }
                            }
                          },
                        ),
                        RaisedButton(
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                          color: Color.fromARGB(255, 66, 165, 245),
                          textColor: Colors.white,
                          padding: const EdgeInsets.all(10.0),
                          child: Text('Hủy', style: TextStyle(fontSize: 20)),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    )
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              )
        : Center(
            child: CircularProgressIndicator(),
          );
  }

//buil danh sách các hồ khi chọn vào từng tỉnh.
  Container _selectedTank(int index1, int x) {
    return Container(
      margin: EdgeInsets.only(left: 10),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(), // disable scroll
        shrinkWrap: true,
        itemCount: listTank[index1].length,
        itemBuilder: (context, index) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Checkbox(
                  value: check[index1][index],
                  onChanged: (bool value) {
                    setState(() {
                      check[index1][index] = value;
                    });
                  }),
              Container(
                width: MediaQuery.of(context).size.width.toDouble() - 290,
                child: Text(
                  '${listTank[index1][index].tenHo}',
                  style: TextStyle(fontSize: 17),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              check[index1][index]
                  ? Container(
                      child: Row(
                        children: <Widget>[
                          Text("${listNgayTha[index1][index]}"),
                          IconButton(
                              icon: Icon(Icons.date_range),
                              onPressed: () {
                                selectDateTha(context, index1, index);
                              })
                        ],
                      ),
                    )
                  : Container(),
              check[index1][index]
                  ? Expanded(
                      child: Container(
                          child: TextField(
                        controller: controllertf[index1][index],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration.collapsed(
                            hintText: 'Nhập số lượng'),
                      )),
                    )
                  : Container()
            ],
          );
        },
      ),
    );
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

  _builViewBanLai(TextField _txtBenMua, TextField _txtSoLuong) {
    return Container(
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Bên bán: ${Service_Hop_Dong.BEN_MUA}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(
            height: 10,
          ),
          Text(
              "Số lượng còn lại của hợp đồng ${widget.id}: ${formatterNumber.format(sltomconlai)}",
              style: TextStyle(fontSize: 15)),
          SizedBox(
            height: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Ngày bán: ${formatter.format(now)}",
                  style: TextStyle(fontSize: 15),
                ),
                IconButton(
                  icon: Icon(
                    Icons.date_range,
                    size: 25,
                  ),
                  onPressed: () {
                    selectDate(context);
                  },
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              width: MediaQuery.of(context).size.width * 0.8,
              margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 240, 240, 240),
                  border: Border.all(width: 1.2, color: Colors.black12),
                  borderRadius:
                      const BorderRadius.all(const Radius.circular(10))),
              child: _txtBenMua),
          Container(
              width: MediaQuery.of(context).size.width * 0.8,
              margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 240, 240, 240),
                  border: Border.all(width: 1.2, color: Colors.black12),
                  borderRadius:
                      const BorderRadius.all(const Radius.circular(10))),
              child: _txtSoLuong),
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
                    if (giaiDoan1Ban.benMua == "" ||
                        giaiDoan1Ban.soLuongBan == "") {
                      _showSnackBar(context, "Bạn chưa nhập dữ liệu");
                    } else {
                      _addTTBan(giaiDoan1Ban);
                    }
                  }),
              RaisedButton(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  color: Color.fromARGB(255, 66, 165, 245),
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(10.0),
                  child: Text("Hủy"),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ],
          )
        ],
      ),
    );
  }
}
