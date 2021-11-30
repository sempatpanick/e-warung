import 'package:ewarung/data/api/api_service.dart';
import 'package:ewarung/data/model/login_result.dart';
import 'package:ewarung/utils/get_connection.dart';
import 'package:ewarung/utils/result_state_login.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class LoginProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();
  final _getConnection = GetConnection();

  late ResultStateLogin _loggedInStatus;
  ResultStateLogin _registeredInStatus = ResultStateLogin.notRegistered;

  ResultStateLogin get loggedInStatus => _loggedInStatus;

  set loggedInStatus(ResultStateLogin value) {
    _loggedInStatus = value;
  }

  ResultStateLogin get registeredInStatus => _registeredInStatus;

  set registeredInStatus(ResultStateLogin value) {
    _registeredInStatus = value;
  }

  Future<LoginResult> fetchLogin(String email, String password) async {
    try {
      notifyListeners();
      final connection = await _getConnection.getConnection();
      if (connection) {
        notifyListeners();
        return await apiService.login(http.Client(), email, password);
      } else {
        notifyListeners();
        return LoginResult(status: false, message: "Error connection");
      }
    } catch (e) {
      notifyListeners();
      return LoginResult(status: false, message: "Failed to login");
    }
  }
}