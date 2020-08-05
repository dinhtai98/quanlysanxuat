class HopDong {
  String id;
  String benBan;
  String benMua;
  String tinhTrangBenh;
  String ngayKyHD;
  String soLuong;
  String loaiTom;

  HopDong(
      {this.id,
      this.benBan,
      this.benMua,
      this.ngayKyHD,
      this.tinhTrangBenh,
      this.soLuong,
      this.loaiTom});
  factory HopDong.formJson(Map<String, dynamic> json) {
    return HopDong(
        id: json['id'] as String,
        benBan: json['benban'] as String,
        benMua: json['benmua'] as String,
        ngayKyHD: json['ngaykyhp'] as String,
        tinhTrangBenh: json['tinhtrangbenh'] as String,
        soLuong: json['soluongtom'] as String,
        loaiTom: json['loaitombome'] as String);
  }
}
