import 'package:ewarung/data/model/login_result.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  final Future<SharedPreferences> sharedPreferences = SharedPreferences.getInstance();

  static const id = 'ID';
  static const username = 'USERNAME';
  static const email = 'EMAIL';
  static const nama = 'NAMA';
  static const alamat = 'ALAMAT';
  static const noTelp = 'NO_TELP';

  Future<User> get getUserLogin async {
    final SharedPreferences prefs = await sharedPreferences;
    User user = User(
        id: prefs.getString(id) ?? "",
        username: prefs.getString(username) ?? "",
        email: prefs.getString(email) ?? "",
        password: "",
        nama: prefs.getString(nama) ?? "",
        alamat: prefs.getString(alamat) ?? "",
        noTelp: prefs.getString(noTelp) ?? ""
    );
    return user;
  }

  void setUserLogin(User user) async {
    final SharedPreferences prefs = await sharedPreferences;

    prefs.setString(id, user.id);
    prefs.setString(username, user.username ?? "");
    prefs.setString(email, user.email);
    prefs.setString(nama, user.nama ?? "");
    prefs.setString(alamat, user.alamat ?? "");
    prefs.setString(noTelp, user.noTelp ?? "");
  }

  void removeUserLogin() async {
    final SharedPreferences prefs = await sharedPreferences;

    prefs.remove(id);
    prefs.remove(username);
    prefs.remove(email);
    prefs.remove(nama);
    prefs.remove(alamat);
    prefs.remove(noTelp);
  }
}
