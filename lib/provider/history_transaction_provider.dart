import 'package:ewarung/data/api/api_service.dart';
import 'package:ewarung/data/model/history_transaction_result.dart';
import 'package:ewarung/utils/get_connection.dart';
import 'package:ewarung/utils/result_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class HistoryTransactionProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();
  final _getConnection = GetConnection();

  HistoryTransactionProvider(String idUser) {
    _fetchHistoryTransaction(idUser);
  }

  HistoryTransactionResult _resultHistoryTransaction = HistoryTransactionResult(status: false, message: "not initialized", data: []);
  ResultState _stateHistoryTransaction = ResultState.loading;
  String _messageHistoryTransaction = '';

  HistoryTransactionResult get resultHistoryTransaction => _resultHistoryTransaction;
  ResultState get stateHistoryTransaction => _stateHistoryTransaction;
  String get messageHistoryTransaction => _messageHistoryTransaction;

  Future<dynamic> _fetchHistoryTransaction(String idUser) async {
    try {
      _stateHistoryTransaction = ResultState.loading;
      notifyListeners();
      final connection = await _getConnection.getConnection();
      if (connection) {
        var result = await apiService.getHistoryTransaction(http.Client(), idUser);
        if (result.data.isNotEmpty) {
          _stateHistoryTransaction = ResultState.hasData;
          notifyListeners();
          return _resultHistoryTransaction = result;
        } else {
          _stateHistoryTransaction = ResultState.noData;
          notifyListeners();
          return _messageHistoryTransaction = result.message;
        }
      } else {
        _stateHistoryTransaction = ResultState.error;
        notifyListeners();
        return _messageHistoryTransaction = 'Error: No connection internet';
      }
    } catch (e) {
      _stateHistoryTransaction = ResultState.error;
      notifyListeners();
      return _messageHistoryTransaction = 'Error: Failed to get history transaction, $e';
    }
  }
}