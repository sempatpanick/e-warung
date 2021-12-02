import 'package:ewarung/common/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  static const routeName = '/cart_page';

  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: colorWhiteBlue,
      body: Center(
        child: Text("Cart pageee"),
      ),
    );
  }
}