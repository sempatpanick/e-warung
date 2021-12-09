import 'dart:async';

import 'package:ewarung/common/styles.dart';
import 'package:ewarung/ui/login_page.dart';
import 'package:ewarung/ui/main_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash_screen';
  final String id;
  const SplashScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 2), () {
      if (widget.id != "") {
        Navigator.pushReplacementNamed(context, MainPage.routeName);
      } else {
        Navigator.pushReplacementNamed(context, LoginPage.routeName);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.add_business_outlined,
              size: 100,
              color: textColorWhite,
            ),
            Text(
              "E-Warung",
              style: Theme.of(context).textTheme.headline3!.copyWith(color: textColorWhite, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}