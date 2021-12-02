class LoginResult {
  LoginResult({
    required this.status,
    required this.message,
    this.user,
  });

  bool status;
  String message;
  User? user;

  factory LoginResult.fromJson1(Map<String, dynamic> json) => LoginResult(
    status: json["status"],
    message: json["message"],
    user: User.fromJson(json["data"]),
  );

  factory LoginResult.fromJson2(Map<String, dynamic> json) => LoginResult(
    status: json["status"],
    message: json["message"],
  );
}

class User {
  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.nama,
    required this.alamat,
    required this.noTelp,
    required this.avatar,
  });

  String id;
  String? username;
  String email;
  String password;
  String? nama;
  String? alamat;
  String? noTelp;
  String? avatar;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    username: json["username"],
    email: json["email"],
    password: json["password"],
    nama: json["nama"],
    alamat: json["alamat"],
    noTelp: json["no_telp"],
    avatar: json["avatar"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "email": email,
    "password": password,
    "nama": nama,
    "alamat": alamat,
    "noTelp": noTelp,
    "avatar": avatar,
  };
}