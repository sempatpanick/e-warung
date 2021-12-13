import 'dart:convert';

import 'package:ewarung/data/model/geeneral_result.dart';
import 'package:ewarung/data/model/detail_product_user_result.dart';
import 'package:ewarung/data/model/login_result.dart';
import 'package:ewarung/data/model/products_user_result.dart';
import 'package:ewarung/data/model/recommended_product_result.dart';
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

  Future<RecommendedProductResult> getRecommendedProduct(http.Client client, String id) async {
    final response = await http.post(Uri.parse(_baseUrl + "/product/recommended.php"),
        body: {"id_product": id});
    if (response.statusCode == 200) {
      return RecommendedProductResult.fromJson1(json.decode(response.body));
    } else {
      return RecommendedProductResult.fromJson2(json.decode('{"status":false,"message":"Failed to get recommended product"}'));
    }
  }

  Future<GeneralResult> addProduct(http.Client client, String idUser, String idProduct, String name, String? description, int price, int stock, String image) async {
    final response = await http.post(Uri.parse(_baseUrl + "/product/add.php"),
        body: {"id_user": idUser, "id_product": idProduct, "nama": name, "keterangan": description, "harga": "$price", "stok": "$stock", "gambar": image});
    if (response.statusCode == 200) {
      return GeneralResult.fromJson(json.decode(response.body));
    } else {
      return GeneralResult.fromJson(json.decode('{"status":false,"message":"Failed to add product"}'));
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

  Future<GeneralResult> deleteProduct(http.Client client, String idUser, String idProduct) async {
    final response = await http.post(Uri.parse(_baseUrl + "/product/delete.php"),
        body: {"id_users": idUser, "id_produk": idProduct});
    if (response.statusCode == 200) {
      return GeneralResult.fromJson(json.decode(response.body));
    } else {
      return GeneralResult.fromJson(json.decode('{"status":false,"message":"Failed to delete product"}'));
    }
  }

  Future<GeneralResult> saveTransaction(http.Client client, String idUser, int bill, int paid, int changeBill, List<Map> products) async {
    var body = {
      "id_user": idUser,
      "bill": '$bill',
      "paid": '$paid',
      "change_bill": '$changeBill',
      "products": jsonEncode(products)
    };
    final response = await http.post(Uri.parse(_baseUrl + "/product/transaction.php"),
        body: body);
    if (response.statusCode == 200) {
      return GeneralResult.fromJson(json.decode(response.body));
    } else {
      return GeneralResult.fromJson(json.decode('{"status":false,"message":"Transaction failed"}'));
    }
  }
}
