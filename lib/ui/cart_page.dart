import 'package:ewarung/common/styles.dart';
import 'package:ewarung/provider/cart_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  static const routeName = '/cart_page';

  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    CartProvider pref = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: colorWhiteBlue,
      body: SafeArea(
        child: ListView.builder(
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(pref.resultBarcode[index]),
            );
          },
          itemCount: pref.resultBarcode.length,
        ),
      ),
    );
  }
}