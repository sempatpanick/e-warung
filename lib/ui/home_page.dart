import 'package:ewarung/provider/preferences_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'login_page.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    PreferencesProvider pref = Provider.of<PreferencesProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Text("home page ${pref.userLogin.email}"),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, LoginPage.routeName);
                  pref.removeUserLogin();
                },
                child: const Text("Logout"),
              )
            ],
          ),
        ),
      ),
      // body: Center(
      //   child: Text("home page"),
      // ),
    );
  }
}