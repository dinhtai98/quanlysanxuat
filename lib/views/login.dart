import 'package:flutter/material.dart';
import 'package:quanlysanxuattom/models/user.dart';
import 'package:quanlysanxuattom/services/userService.dart';
import 'package:quanlysanxuattom/views/ThongKeCacCoSo.dart';
import 'package:quanlysanxuattom/views/mainPage.dart';
import 'package:quanlysanxuattom/animations/fadeAnimation.dart';

import 'package:fluttie/fluttie.dart';

class LoginPageState extends State<LoginPage> {
  final User user = User();

  List<User> kt;
  GlobalKey<ScaffoldState> _scaffoldKey;
  TextEditingController txtus, txtpw;
  bool check;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scaffoldKey = GlobalKey();
    kt = [];
    check = false;
    txtus = TextEditingController();
    txtpw = TextEditingController();
  }

  _showSnackBar(context, message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 1),
    ));
  }

  _kiemtraUser() {
    Service_User.getUser(txtus.text, txtpw.text).then((result) {
      setState(() {
        if (result != null) {
          kt = result;
          if (kt.length > 0) {
            busy = false;
            _clearValues();
            if (kt[0].chucVu != "thongkecaccoso") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => MainPage(
                            chucVu: "${kt[0].chucVu}",
                          )));
            } else {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => ThongKeNhieuCoSo()));
            }
          } else {
            busy = false;
            _clearValues();
            _showSnackBar(context, "Bạn nhập sai tài khoản hoặc mật khẩu");
          }
        }
      });
    });
  }

  _clearValues() {
    txtus.text = '';
    txtpw.text = '';
  }

  @override
  Widget build(BuildContext context) {
    final TextField _txtUserName = TextField(
      controller: txtus,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          hintText: 'Enter your username',
          hintStyle: TextStyle(
              color: Colors.grey.withOpacity(.8), fontStyle: FontStyle.italic),
          contentPadding: EdgeInsets.all(10),
          border: InputBorder.none),
      autocorrect: false,
      onChanged: (text) {
        setState(() {
          this.user.username = text;
        });
      },
    );
    final TextField _txtPassWord = TextField(
      controller: txtpw,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          hintText: 'Enter your password',
          hintStyle: TextStyle(
              color: Colors.grey.withOpacity(.8), fontStyle: FontStyle.italic),
          contentPadding: EdgeInsets.all(10),
          border: InputBorder.none),
      autocorrect: false,
      obscureText: true,
      onChanged: (text) {
        setState(() {
          this.user.password = text;
        });
      },
    );
    return WillPopScope(
        //Wrap out body with a `WillPopScope` widget that handles when a user is cosing current route
        onWillPop: () async => false,
        child: Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomPadding: false,
          backgroundColor: Color.fromRGBO(3, 9, 23, 1),
          body: Container(
            padding: EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FadeAnimation(
                    1.2,
                    Text(
                      "Login",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    )),
                SizedBox(
                  height: 30,
                ),
                FadeAnimation(
                    1.5,
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: Column(
                        children: <Widget>[
                          Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom:
                                          BorderSide(color: Colors.grey[300]))),
                              child: _txtUserName),
                          Container(
                            decoration: BoxDecoration(),
                            child: _txtPassWord,
                          ),
                        ],
                      ),
                    )),
                SizedBox(
                  height: 40,
                ),
                FadeAnimation(
                    1.8,
                    Center(
                        // child: RaisedButton(
                        //   color: Colors.black,
                        //   child: Container(
                        //     width: 120,
                        //     padding: EdgeInsets.all(15),
                        //     decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(50),
                        //         color: Colors.blue[800]),
                        //     child: Center(
                        //         child: Text(
                        //       "Login",
                        //       style: TextStyle(color: Colors.white.withOpacity(.7)),
                        //     )),
                        //   ),
                        //   onPressed: () {
                        //     _kiemtraUser();
                        //   },
                        // ),

                        child: !busy
                            ? FlatButton(
                                color: Color(0xFFC767E7),
                                child: Text(
                                  "Login",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: submit,
                              )
                            : CircularProgressIndicator())),
              ],
            ),
          ),
        ));
  }

  var busy = false;
  var done = false;
  FluttieAnimationController animationCtrl;
  Future<Function> submit() async {
    setState(() {
      busy = true;
      _kiemtraUser();
    });

    // Future.delayed(
    //   const Duration(seconds: 4),
    //   () => setState(
    //     () {
    //       done = true;
    //       animationCtrl.start();
    //     },
    //   ),
    // );
  }
}

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginPageState();
  }
}
