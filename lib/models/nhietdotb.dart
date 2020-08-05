class NhietDoTB {
  String id;
  String idtinh;
  String quy1;
  String quy2;
  String quy3;
  String quy4;

  NhietDoTB({this.id, this.idtinh, this.quy1, this.quy2, this.quy3, this.quy4});
  factory NhietDoTB.formJson(Map<String, dynamic> json) {
    return NhietDoTB(
        id: json['id'],
        idtinh: json['idtinh'],
        quy1: json['quy1'],
        quy2: json['quy2'],
        quy3: json['quy3'],
        quy4: json['quy4']);
  }
}
