import 'package:flutter/material.dart';
import 'package:quanlysanxuattom/services/hopDongService.dart';
import 'package:quanlysanxuattom/views/BuilThongKeCacHopDongTheoTinh.dart';
import 'package:quanlysanxuattom/views/ThongKeToanCuc.dart';

class ThongKeNhieuCoSo extends StatefulWidget {
  @override
  _ThongKeNhieuCoSoState createState() => _ThongKeNhieuCoSoState();
}

class _ThongKeNhieuCoSoState extends State<ThongKeNhieuCoSo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Danh sách các cơ sở"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.library_books,
              color: Colors.white,
            ),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => ThongKeToanCuc())),
          ),
        ],
      ),
      body: FutureBuilder(
        future: Service_Hop_Dong.getHopDongCacCoSo(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
          }
          return snapshot.hasData
              ? Container(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        child: Card(
                          elevation: 10,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  snapshot.data[index],
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ThongKeSoLieu(
                                        coSo: snapshot.data[index],
                                      )));
                        },
                      );
                    },
                    itemCount: snapshot.data.length,
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }
}
