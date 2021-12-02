import 'package:ewarung/common/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListPage extends StatelessWidget {
  static const routeName = '/list_page';

  const ListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: colorWhiteBlue,
      body: Center(
        child: Text("List pageee"),
      ),
    );
  }
}