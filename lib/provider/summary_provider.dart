import 'package:ewarung/data/api/api_service.dart';
import 'package:ewarung/data/model/summary_result.dart';
import 'package:ewarung/utils/get_connection.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class SummaryProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();
  final _getConnection = GetConnection();

  Future<SummaryResult> fetchSummaryStore(String idUser) async {
    try {
      notifyListeners();
      final connection = await _getConnection.getConnection();
      if (connection) {
        notifyListeners();
        return apiService.getSummaryStore(http.Client(), idUser);
      } else {
        notifyListeners();
        return SummaryResult(status: false, message: "Tidak ada koneksi internet");
      }
    } catch (e) {
      notifyListeners();
      return SummaryResult(status: false, message: "Failed to login");
    }
  }
}