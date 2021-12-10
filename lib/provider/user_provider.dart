import 'package:ewarung/data/api/api_service.dart';
import 'package:ewarung/data/model/geeneral_result.dart';
import 'package:ewarung/data/model/detail_product_user_result.dart';
import 'package:ewarung/data/model/products_user_result.dart';
import 'package:ewarung/data/model/recommended_product_result.dart';
import 'package:ewarung/utils/get_connection.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class UserProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();
  final _getConnection = GetConnection();

  Future<RecommendedProductResult> fetchRecommendedProduct(String idUser) async {
    try {
      notifyListeners();
      final connection = await _getConnection.getConnection();
      if (connection) {
        notifyListeners();
        return await apiService.getRecommendedProduct(http.Client(), idUser);
      } else {
        notifyListeners();
        return RecommendedProductResult(status: false, message: "Tidak ada koneksi internet");
      }
    } catch (e) {
      notifyListeners();
      return RecommendedProductResult(status: false, message: "Failed to get recommended product, $e");
    }
  }

  Future<GeneralResult> fetchAddProductUser(String idUser, String idProduct, String name, String description, int price, int stock, String image) async {
    try {
      notifyListeners();
      final connection = await _getConnection.getConnection();
      if (connection) {
        notifyListeners();
        return await apiService.addProduct(http.Client(), idUser, idProduct, name, description, price, stock, image);
      } else {
        notifyListeners();
        return GeneralResult(status: false, message: "Tidak ada koneksi internet");
      }
    } catch (e) {
      notifyListeners();
      return GeneralResult(status: false, message: "Failed to add product, $e");
    }
  }

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
      return ProductsUserResult(status: false, message: "Failed to get product, $e");
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
      return DetailProductUserResult(status: false, message: "Failed to get product, $e");
    }
  }

  Future<GeneralResult> fetchDeleteProductUser(String idUser, String idProduct) async {
    try {
      notifyListeners();
      final connection = await _getConnection.getConnection();
      if (connection) {
        notifyListeners();
        return await apiService.deleteProduct(http.Client(), idUser, idProduct);
      } else {
        notifyListeners();
        return GeneralResult(status: false, message: "Tidak ada koneksi internet");
      }
    } catch (e) {
      notifyListeners();
      return GeneralResult(status: false, message: "Failed to delete product, $e");
    }
  }

  Future<GeneralResult> fetchTransaction(String idUser, int bill, int paid, int changeBill, List<Map> products) async {
    try {
      notifyListeners();
      final connection = await _getConnection.getConnection();
      if (connection) {
        notifyListeners();
        return await apiService.saveTransaction(http.Client(), idUser, bill, paid, changeBill, products);
      } else {
        notifyListeners();
        return GeneralResult(status: false, message: "Tidak ada koneksi internet");
      }
    } catch (e) {
      notifyListeners();
      return GeneralResult(status: false, message: "Transaction failed, $e");
    }
  }
}
