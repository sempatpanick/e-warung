import 'package:ewarung/common/styles.dart';
import 'package:ewarung/provider/login_provider.dart';
import 'package:ewarung/ui/home_page.dart';
import 'package:ewarung/ui/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'common/navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider())
      ],
      child: MaterialApp(
        theme: lightTheme,
        navigatorKey: navigatorKey,
        initialRoute: LoginPage.routeName,
        routes: {
          LoginPage.routeName: (context) => const LoginPage(),
          HomePage.routeName: (context) => HomePage(),
        },
      ),
    );
  }
}