import 'package:ewarung/data/model/login_result.dart';
import 'package:ewarung/data/preferences/preferences_helper.dart';
import 'package:ewarung/utils/result_state.dart';
import 'package:flutter/cupertino.dart';

class PreferencesProvider extends ChangeNotifier {
  PreferencesHelper preferencesHelper;

  PreferencesProvider({required this.preferencesHelper}) {
    _getUserLoginPreferences();
  }

  late ResultState _state;
  ResultState get state => _state;

  User _userLogin = User(id: "", username: "", email: "", password: "", nama: "", alamat: "", noTelp: "", avatar: "");
  User get userLogin => _userLogin;

  void _getUserLoginPreferences() async {
    _userLogin = await preferencesHelper.getUserLogin;
    notifyListeners();
  }

  void setUserLogin(User user) {
    preferencesHelper.setUserLogin(user);
    _getUserLoginPreferences();
  }

  void removeUserLogin() {
    preferencesHelper.removeUserLogin();
    _getUserLoginPreferences();
  }
}
