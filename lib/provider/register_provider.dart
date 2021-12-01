
import 'package:ewarung/data/api/api_service.dart';
import 'package:ewarung/data/model/register_result.dart';
import 'package:ewarung/utils/get_connection.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class RegisterProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();
  final _getConnection = GetConnection();

  Future<RegisterResult> fetchRegister(String email, String password) async {
    try {
      notifyListeners();
      final connection = await _getConnection.getConnection();
      if (connection) {
        notifyListeners();
        return await apiService.register(http.Client(), email, password);
      } else {
        notifyListeners();
        return RegisterResult(status: false, message: "Tidak ada koneksi internet");
      }
    } catch (e) {
      notifyListeners();
      return RegisterResult(status: false, message: "Failed to register");
    }
  }
}