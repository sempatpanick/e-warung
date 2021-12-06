import 'package:ewarung/common/styles.dart';
import 'package:ewarung/provider/cart_provider.dart';
import 'package:ewarung/provider/login_provider.dart';
import 'package:ewarung/provider/preferences_provider.dart';
import 'package:ewarung/provider/register_provider.dart';
import 'package:ewarung/provider/user_provider.dart';
import 'package:ewarung/ui/cart_page.dart';
import 'package:ewarung/ui/home_page.dart';
import 'package:ewarung/ui/list_page.dart';
import 'package:ewarung/ui/login_page.dart';
import 'package:ewarung/ui/main_page.dart';
import 'package:ewarung/ui/profile_page.dart';
import 'package:ewarung/ui/register_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common/navigation.dart';
import 'data/preferences/preferences_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var id = prefs.getString(PreferencesHelper.id);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => RegisterProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(
          create: (_) => PreferencesProvider(
            preferencesHelper: PreferencesHelper(),
          ),
        ),
      ],
      child: MaterialApp(
        theme: lightTheme,
        navigatorKey: navigatorKey,
        initialRoute: id == null ? LoginPage.routeName : MainPage.routeName,
        routes: {
          LoginPage.routeName: (context) => const LoginPage(),
          RegisterPage.routeName: (context) => const RegisterPage(),
          MainPage.routeName: (context) => const MainPage(),
          HomePage.routeName: (context) => const HomePage(),
          ListPage.routeName: (context) => const ListPage(),
          CartPage.routeName: (context) => const CartPage(),
          ProfilePage.routeName: (context) => const ProfilePage(),
        },
      ),
    ),
  );
}