import 'dart:convert';

import 'package:ewarung/data/model/detail_product_user_result.dart';
import 'package:ewarung/data/model/login_result.dart';
import 'package:ewarung/data/model/products_user_result.dart';
import 'package:ewarung/data/model/register_result.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://e-warung.my.id/api/';

  Future<LoginResult> login(http.Client client, String email, String password) async {
    final response = await http.post(Uri.parse(_baseUrl + "/user/login.php"),
        body: {"email": email, "password": password});
    if (response.statusCode == 200) {
      if (json.decode(response.body)['status']) {
        return LoginResult.fromJson1(json.decode(response.body));
      } else {
        return LoginResult.fromJson2(json.decode(response.body));
      }
    } else {
      return LoginResult.fromJson2(json.decode('{"status":false,"message":"Failed to login"}'));
    }
  }

  Future<RegisterResult> register(http.Client client, String email, String password) async {
    final response = await http.post(Uri.parse(_baseUrl + "/user/signup.php"),
        body: {"email": email, "password": password});
    if (response.statusCode == 200) {
      return RegisterResult.fromJson(json.decode(response.body));
    } else {
      return RegisterResult.fromJson(json.decode('{"status":false,"message":"Failed to register"}'));
    }
  }

  Future<ProductsUserResult> getProductsUser(http.Client client, String id) async {
    final response = await http.post(Uri.parse(_baseUrl + "/product/by_shop.php"),
        body: {"id_users": id});
    if (response.statusCode == 200) {
      return ProductsUserResult.fromJson1(json.decode(response.body));
    } else {
      return ProductsUserResult.fromJson2(json.decode('{"status":false,"message":"Failed to get products"}'));
    }
  }

  Future<DetailProductUserResult> getDetailProductUser(http.Client client, String idUser, String idProduct) async {
    final response = await http.post(Uri.parse(_baseUrl + "/product/by_shop.php"),
        body: {"id_users": idUser, "id_produk": idProduct});
    if (response.statusCode == 200) {
      return DetailProductUserResult.fromJson1(json.decode(response.body));
    } else {
      return DetailProductUserResult.fromJson2(json.decode('{"status":false,"message":"Failed to get products"}'));
    }
  }
}