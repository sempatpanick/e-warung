import 'package:ewarung/data/api/api_service.dart';
import 'package:ewarung/data/model/summary_result.dart';
import 'package:ewarung/data/preferences/preferences_helper.dart';
import 'package:ewarung/utils/get_connection.dart';
import 'package:ewarung/utils/result_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SummaryProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();
  final _getConnection = GetConnection();
  final String idUser;

  SummaryProvider({required this.idUser}) {
    _fetchSummaryStore(idUser);
  }

  SummaryResult _resultSummary = SummaryResult(status: false, message: "not initialized");
  ResultState _stateSummary = ResultState.loading;
  String _messageSummary = '';

  SummaryResult get resultSummary => _resultSummary;
  ResultState get stateSummary => _stateSummary;
  String get messageSummary => _messageSummary;

  Future<dynamic> _fetchSummaryStore(String idUser) async {
    try {
      _stateSummary = ResultState.loading;
      notifyListeners();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String idUsers = prefs.getString(PreferencesHelper.id) ?? "";

      final connection = await _getConnection.getConnection();
      if (connection) {
        notifyListeners();
        var result = await apiService.getSummaryStore(http.Client(), idUsers);

        if (result.status) {
          _stateSummary = ResultState.hasData;
          notifyListeners();
          return _resultSummary = result;
        } else {
          _stateSummary = ResultState.noData;
          notifyListeners();
          return _messageSummary = result.message;
        }
      } else {
        _stateSummary = ResultState.error;
        notifyListeners();
        return _messageSummary = 'Error: No connection internet';
      }
    } catch (e) {
      _stateSummary = ResultState.error;
      notifyListeners();
      return _messageSummary = 'Error: Failed to get summary, $e';
    }
  }
}