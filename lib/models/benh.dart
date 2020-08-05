class Benh{
  String id;
  String tenBenh;
  Benh({this.id,this.tenBenh});
  factory Benh.formJson(Map<String,dynamic> json){
    return Benh(
      id: json['id'],
      tenBenh: json['tenbenh']
    );
  }
}