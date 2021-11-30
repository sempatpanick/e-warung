class LoginResult {
  LoginResult({
    required this.status,
    required this.message,
    this.data,
  });

  bool status;
  String message;
  Data? data;

  factory LoginResult.fromJson1(Map<String, dynamic> json) => LoginResult(
    status: json["status"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  factory LoginResult.fromJson2(Map<String, dynamic> json) => LoginResult(
    status: json["status"],
    message: json["message"],
  );
}

class Data {
  Data({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.nama,
    required this.alamat,
  });

  String id;
  String? username;
  String email;
  String password;
  String? nama;
  String? alamat;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    username: json["username"],
    email: json["email"],
    password: json["password"],
    nama: json["nama"],
    alamat: json["alamat"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "email": email,
    "password": password,
    "nama": nama,
    "alamat": alamat,
  };
}