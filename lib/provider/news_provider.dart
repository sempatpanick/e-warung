import 'package:ewarung/data/api/api_service.dart';
import 'package:ewarung/data/model/news_result.dart';
import 'package:ewarung/utils/get_connection.dart';
import 'package:ewarung/utils/result_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class NewsProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();
  final _getConnection = GetConnection();

  NewsProvider() {
    _fetchNews();
  }

  NewsResult _resultNews = NewsResult(status: false, message: "not initialized", data: []);
  ResultState _stateNews = ResultState.loading;
  String _messageNews = '';

  NewsResult get resultNews => _resultNews;
  ResultState get stateNews => _stateNews;
  String get messageNews => _messageNews;

  Future<dynamic> _fetchNews() async {
    try {
      _stateNews = ResultState.loading;
      notifyListeners();
      final connection = await _getConnection.getConnection();
      if (connection) {
        var result = await apiService.getNews(http.Client());
        if (result.data.isNotEmpty) {
          _stateNews = ResultState.hasData;
          notifyListeners();
          return _resultNews = result;
        } else {
          _stateNews = ResultState.noData;
          notifyListeners();
          return _messageNews = result.message;
        }
      } else {
        _stateNews = ResultState.error;
        notifyListeners();
        return _messageNews = 'Error: No connection internet';
      }
    } catch (e) {
      _stateNews = ResultState.error;
      notifyListeners();
      return _messageNews = 'Error: Failed to get news, $e';
    }
  }
}