import 'package:ewarung/common/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home_page';

  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: colorWhiteBlue,
      body: Center(
        child: Text("Home pageeeee"),
      ),
    );
  }
}