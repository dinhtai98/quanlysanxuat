class GiaiDoan1 {
  String id;
  String idHD;
  String hinhThuc;
  String idTinh;
  String benMua;
  String ngayBan;
  String soLuongBan;
  String giaiDoan;
  String ketThuc;
  GiaiDoan1(
      {this.id,
      this.idHD,
      this.hinhThuc,
      this.idTinh,
      this.benMua,
      this.ngayBan,
      this.soLuongBan,
      this.giaiDoan,
      this.ketThuc});

  factory GiaiDoan1.formJson(Map<String, dynamic> json) {
    return GiaiDoan1(
        id: json['id'] as String,
        idHD: json['idhd'] as String,
        hinhThuc: json['hinhthuc'] as String,
        idTinh: json['idtinh'] as String,
        benMua: json['benmua'] as String,
        ngayBan: json['ngayban'] as String,
        soLuongBan: json['soluongban'] as String,
        giaiDoan: json['giaidoan'] as String,
        ketThuc: json['ketthuc'] as String);
  }
}
