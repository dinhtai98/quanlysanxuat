class BenhDaNhiem {
  String id;
  String tenBenh;
  String soLuongDaNhiem;
  String soLuongChuaDuoc;
  String soLuongChet;
  String hinhThucTieuHuy;
  String ngayMacBenh;
  String idGD;
  String idHD;
  String idHo;

  BenhDaNhiem(
      {this.id,
      this.tenBenh,
      this.ngayMacBenh,
      this.soLuongDaNhiem,
      this.soLuongChuaDuoc,
      this.soLuongChet,
      this.hinhThucTieuHuy,
      this.idGD,
      this.idHD,
      this.idHo});

  factory BenhDaNhiem.formJson(Map<String, dynamic> json) {
    return BenhDaNhiem(
        id: json['id'],
        tenBenh: json['tenbenh'],
        ngayMacBenh: json['ngaymacbenh'],
        soLuongDaNhiem: json['soluongnhiem'],
        soLuongChuaDuoc: json['soluongchuaduoc'],
        soLuongChet: json['soluongtieuhuy'],
        hinhThucTieuHuy: json['hinhthuctieuhuy'],
        idGD: json['idgd'],
        idHD: json['idhd'],
        idHo: json['idho']);
  }
}
