class Tinh {
  String id;
  String tenTinh;
  String diaChi;

  Tinh({this.id, this.tenTinh, this.diaChi});

  factory Tinh.formJson(Map<String, dynamic> json) {
    return Tinh(
        id: json['id'] as String,
        tenTinh: json['tentinh'] as String,
        diaChi: json['diachi'] as String);
  }
}
