class Tank {
  String id;
  String tenHo;
  String idTinh;

  Tank({this.id, this.tenHo, this.idTinh});

  factory Tank.formJson(Map<String, dynamic> json) {
    return Tank(
        id: json['id'] as String,
        tenHo: json['tenho'] as String,
        idTinh: json['idtinh'] as String);
  }
}
