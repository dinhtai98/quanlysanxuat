class User{
  String id;
  String username;
  String password;
  String chucVu;
  User({this.id,this.username,this.password,this.chucVu});
  factory User.formJson(Map<String,dynamic> json){
    return User(
      id: json['id'],
      username: json['username'],
      password: json['password1'],
      chucVu: json['chucvu'],
    );
  }
}