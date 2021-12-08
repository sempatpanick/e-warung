import 'package:ewarung/data/api/api_service.dart';
import 'package:ewarung/data/model/delete_product_user_result.dart';
import 'package:ewarung/data/model/detail_product_user_result.dart';
import 'package:ewarung/data/model/products_user_result.dart';
import 'package:ewarung/utils/get_connection.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class UserProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();
  final _getConnection = GetConnection();

  Future<ProductsUserResult> fetchProductsUser(String idUser) async {
    try {
      notifyListeners();
      final connection = await _getConnection.getConnection();
      if (connection) {
        notifyListeners();
        return await apiService.getProductsUser(http.Client(), idUser);
      } else {
        notifyListeners();
        return ProductsUserResult(status: false, message: "Tidak ada koneksi internet");
      }
    } catch (e) {
      notifyListeners();
      return ProductsUserResult(status: false, message: "Failed to get product");
    }
  }

  Future<DetailProductUserResult> fetchProductUser(String idUser, String idProduct) async {
    try {
      notifyListeners();
      final connection = await _getConnection.getConnection();
      if (connection) {
        notifyListeners();
        return await apiService.getDetailProductUser(http.Client(), idUser, idProduct);
      } else {
        notifyListeners();
        return DetailProductUserResult(status: false, message: "Tidak ada koneksi internet");
      }
    } catch (e) {
      notifyListeners();
      return DetailProductUserResult(status: false, message: "Failed to get product");
    }
  }

  Future<DeleteProductUserResult> fetchDeleteProductUser(String idUser, String idProduct) async {
    try {
      notifyListeners();
      final connection = await _getConnection.getConnection();
      if (connection) {
        notifyListeners();
        return await apiService.deleteProduct(http.Client(), idUser, idProduct);
      } else {
        notifyListeners();
        return DeleteProductUserResult(status: false, message: "Tidak ada koneksi internet");
      }
    } catch (e) {
      notifyListeners();
      return DeleteProductUserResult(status: false, message: "Failed to delete product");
    }
  }
}