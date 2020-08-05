class HoNuoiTom {
  String id;
  String idtank;
  String idgd;
  String ngayTha;
  String soluong;
  String soluongthuduoc;
  String idhd;

  HoNuoiTom(
      {this.id,
      this.idtank,
      this.idgd,
      this.ngayTha,
      this.soluong,
      this.soluongthuduoc,
      this.idhd});

  factory HoNuoiTom.formJson(Map<String, dynamic> json) {
    return HoNuoiTom(
        id: json['id'] as String,
        idtank: json['idtank'] as String,
        idgd: json['idgd'] as String,
        ngayTha: json['ngaytha'] as String,
        soluong: json['soluong'] as String,
        soluongthuduoc: json['soluongthuduoc'] as String,
        idhd: json['idhd'] as String);
  }
}
