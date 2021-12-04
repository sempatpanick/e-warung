import 'package:auto_size_text/auto_size_text.dart';
import 'package:ewarung/common/styles.dart';
import 'package:ewarung/provider/cart_provider.dart';
import 'package:ewarung/widgets/item_cart.dart';
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
  bool isButtonDisabled = true;

  @override
  Widget build(BuildContext context) {
    CartProvider cart = Provider.of<CartProvider>(context);

    if (mounted) {
      if (cart.resultBarcode.isNotEmpty) {
        isButtonDisabled = false;
      } else {
        isButtonDisabled = true;
      }
    }

    return Scaffold(
      backgroundColor: colorWhiteBlue,
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return ItemCart(index: index, id: cart.resultBarcode[index]);
                },
                itemCount: cart.resultBarcode.length,
              ),
              const SizedBox(height: 16,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        "Total",
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(color: primaryColor, fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      AutoSizeText(
                        "Rp. 60.000",
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(color: colorBlack, fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                      primary: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: isButtonDisabled ? null :() {
                      checkout();
                    },
                    icon: const Icon(Icons.shopping_cart_outlined, color: textColorWhite,),
                    label: Text(
                      "Checkout",
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(color: textColorWhite, fontSize: 17.0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void checkout() {

  }
}